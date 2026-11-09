# Fase 0 — Decisiones técnicas del asistente móvil

Estado: **cerrada**  
Fecha: 2026-11-09  
Alcance: asistente de uso + reportes dinámicos en la app Flutter Android.

## 1. Decisiones cerradas

| Tema | Decisión |
|---|---|
| Plataforma | Android |
| Motor de inferencia | `flutter_edge_ai` 2.6.0 + `flutter_edge_ai_mediapipe` 1.3.0 |
| Formato del modelo | `.task` (MediaPipe) |
| Modelo | Qwen 2.5 1.5B Instruct, cuantización q8 |
| Android mínimo | API 26 (Android 8) |
| Descarga | Primer uso, Wi-Fi recomendado, con progreso, cancelación y verificación |
| Chat de uso | Gratis, local, offline tras descargar el modelo |
| Reportes | Solo plan Pro; administrador exento |
| Regla de acceso | `esAdmin || plan.nombre_code === "pro"` |
| Fallback al servidor | Fuera del MVP |
| Historial | SQLite local; sin tablas nuevas en PostgreSQL |
| Caché de reportes | Solo datos crudos para modo offline, con “Datos al …” |
| Exportación | PDF con marca + CSV con BOM y separador `;` |
| Voz | `speech_to_text` del sistema, solo STT |
| Suscripción offline | Gracia de 7 días con `puedeReportes` cacheado |
| Logo PDF | Fallback temporal hasta tener PNG/SVG oficial |

## 2. Modelo exacto

| Campo | Valor |
|---|---|
| Repositorio | `litert-community/Qwen2.5-1.5B-Instruct` |
| Commit | `2f23bacf8ec78b83dfcd7271c5cb25777b1be5e0` |
| Archivo | `Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.task` |
| Tamaño | `1598556720` bytes (~1.49 GiB) |
| SHA-256 | `82968d0a6c3872cf016fdbcfc591571605f4c7fd2b0f64d2533df502cc6596b3` |
| Licencia | Apache-2.0 |
| Gated | No |
| Contexto KV | 4096 tokens |

URL de descarga:

```
https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/2f23bacf8ec78b83dfcd7271c5cb25777b1be5e0/Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv4096.task
```

No se usa la variante `.litertlm` porque el motor elegido es MediaPipe. El archivo `.task` es el que corresponde a MediaPipe LLM Inference.

## 3. Verificaciones realizadas

- `HEAD` a la URL: `HTTP 200`, `content-type: application/octet-stream`, `content-length: 1598556720`.
- `x-linked-etag` de Hugging Face: `82968d0a6c3872cf016fdbcfc591571605f4c7fd2b0f64d2533df502cc6596b3`, igual al SHA-256 del archivo.
- `accept-ranges: bytes` confirmado.
- Primeros bytes del archivo: cabecera ZIP (`PK\x03\x04`), consistente con un bundle `.task`.
- Flutter: `3.47.2` stable.
- Dart: `3.13.2` stable.
- `flutter_edge_ai` 2.6.0 requiere Dart `>=3.12`; se cumple.
- `flutter_edge_ai_mediapipe` 1.3.0 declara `minSdkVersion 24` y usa `com.google.mediapipe:tasks-genai:0.10.35`; API 26 es compatible.
- `minSdk` actual del proyecto: `flutter.minSdkVersion`, que en Flutter 3.47.2 es `24`. En Fase 2 se fijará explícitamente en `26`.

## 4. Rendimiento de referencia

Datos del model card, Samsung S25 Ultra, q8, contexto 4096:

| Backend | Prefill | Decode | Time to first token | RAM pico |
|---|---:|---:|---:|---:|
| CPU | 162.72 tk/s | 26.06 tk/s | 6.57 s | ~2216 MB |
| GPU | 933.45 tk/s | 27.30 tk/s | 4.77 s | ~1869 MB |

Consecuencia para el producto:

- Gama media/alta con 4 GB o más es el objetivo.
- El primer token puede tardar varios segundos; la UI debe mostrar estado de generación.
- `maxTokens` se mantendrá en 2048, por debajo del límite de 4096 del archivo.
- El modelo se descarga en primer uso; no se empaqueta en el APK.

## 5. Contrato de backend

### `/auth/login` y `/auth/me`

Deben devolver dentro de `usuario` los datos mínimos para que el móvil infiera el acceso:

```json
{
  "roles": [
    { "nombre_code": "cliente", "scope": "sistema" }
  ],
  "suscripcion": {
    "plan": {
      "nombre": "Pro",
      "nombre_code": "pro"
    }
  }
}
```

`esAdmin` y `puedeReportes` **no** se devuelven desde el backend; Flutter los infiere a partir de `roles` y `plan.nombre_code`. El endpoint de reportes vuelve a calcular el acceso internamente y responde `403` si no corresponde, pero tampoco expone esas banderas.

### `/api/reportes/consultar`

```
GET /api/reportes/consultar
  ?metrica=resumen|tecnologias|actividad|tendencia|proyectos
  &categoria=lenguajes|frameworks|arquitecturas|orm|bd
  &desde=ISO&hasta=ISO&tz=America/La_Paz
```

- `authMiddleware`
- Gate `puedeReportes`
- Reutiliza `DashboardService`
- Respuesta:

```json
{
  "metrica": "tecnologias",
  "rango": { "desde": "...", "hasta": "...", "tz": "America/La_Paz" },
  "generadoEn": "...",
  "payload": {}
}
```

No se pone el gate a `/dashboard/mi-*` para no romper el dashboard web de usuarios Free.

## 6. Reglas de acceso

Flutter:

```dart
final esAdmin = usuario.roles.any(
  (r) => r.scope == 'sistema' && r.nombreCode == 'administrador',
);
final puedeReportes =
    esAdmin || usuario.plan?.nombreCode == 'pro';
```

Backend (solo para el gate de `/api/reportes/consultar`, sin devolver las banderas):

```ts
const esAdmin =
  roles.some(
    (r) =>
      r.scope === RolScope.SISTEMA &&
      r.nombre_code === RolEnum.ADMINISTRADOR
  );

const puedeReportes =
  esAdmin || suscripcion?.plan?.nombre_code === Plan.PRO;
```

Sin permisos nuevos, sin roles nuevos, sin `Plan.caracteristicas`, sin archivo `capacidades.ts`.

## 7. Modo offline

- El chat funciona sin red una vez descargado el modelo.
- Si `/auth/me` falla por red, se usa el último perfil cacheado; si responde `401`, se cierra sesión.
- `puedeReportes` se cachea y se respeta hasta 7 días después de la última validación.
- Los reportes offline solo se generan con una entrada exacta de caché y muestran “Datos al {fecha}”.
- Si no hay caché para el período, se indica que el reporte necesita conexión.
- No hay pantalla de historial de reportes ni botón de regeneración.

## 8. Fuera de alcance del MVP

- Fallback al asistente web u Ollama.
- Reportes administrativos en el móvil.
- Edición del lienzo o del diagrama.
- Cambios en `/diagramar` o en FastAPI.
- Tablas `ConversacionIA` / `MensajeIA` en PostgreSQL.
- RAG vectorial.
- Sincronización de historial entre web y móvil.

## 9. Criterios de aceptación de la fase

- [x] Motor, formato y modelo definidos.
- [x] URL, tamaño y checksum verificados.
- [x] Compatibilidad de MediaPipe con API 26 verificada.
- [x] Versiones de Flutter/Dart compatibles con `flutter_edge_ai`.
- [x] Contrato de backend definido.
- [x] Regla de acceso definida.
- [x] Política offline definida.
- [x] Exportación definida.
- [x] Fuera de alcance documentado.

## 10. Siguiente fase

Fase 1 — Backend:

1. Agregar `nombre_code` al `select` del plan en `login` y `me`.
2. Actualizar `authResponseDTO.ts` (sin devolver `esAdmin` ni `puedeReportes`).
3. Crear `/api/reportes/consultar` con lista blanca y gate interno.
4. Registrar la ruta en `src/presentation/router.ts`.
5. Probar con `curl`: Free 403, Pro 200, Admin exento 200, sin cookie 401.
