# Kraken Draw — seguridad y privacidad (resumen)

Última actualización del documento oficial: 20 de octubre de 2026.

1. **Responsable.** Kraken Draw es operado por Kraken S.R.L, con domicilio en Av. La Guardia, Santa Cruz de la Sierra, Bolivia. Contacto: contacto@krakensrl.com.
2. **Datos que se recopilan.**
   - Datos de cuenta: nombre de usuario, correo electrónico, contraseña cifrada y, opcionalmente, foto de perfil.
   - Contenido de trabajo: proyectos, diagramas de clases, atributos, relaciones y configuraciones de generación.
   - Datos del formulario de contacto: nombre, correo y mensaje.
   - Datos técnicos: registros de actividad e historial de generaciones.
3. **Finalidad.** Crear y administrar la cuenta y permisos; almacenar diagramas y generar proyectos; gestionar colaboración; responder consultas; prevenir fraudes y mantener la seguridad. No se usan datos para publicidad ni se venden a terceros.
4. **Base legal.** Ejecución del servicio, consentimiento al registrarse o enviar el formulario, e interés legítimo en seguridad y mejora.
5. **Almacenamiento.** Los datos se guardan en PostgreSQL y en almacenamiento de objetos para archivos e imágenes. Se conservan mientras la cuenta esté activa o hasta solicitar su eliminación, salvo obligación legal.
6. **Cookies y sesión.** Se usa una cookie de sesión `jwt` con atributo HttpOnly. No hay cookies publicitarias ni de seguimiento.
7. **Terceros.** El mapa del landing usa mosaicos de OpenStreetMap. Los proyectos generados pueden incluir dependencias con políticas propias.
8. **Seguridad.** Contraseñas con hash, sesiones firmadas con JWT y cookies HttpOnly, control de acceso por roles y permisos, y HTTPS en producción.
9. **Derechos.** Puedes acceder, rectificar, eliminar tu cuenta y contenido, oponerte o limitar tratamientos y solicitar portabilidad de tus diagramas escribiendo a contacto@krakensrl.com.
10. **Menores.** La plataforma está orientada a estudiantes y profesionales; no se recopilan a sabiendas datos de menores sin autorización de sus tutores.
11. **Cambios.** La política puede actualizarse y la versión vigente se publica con su fecha.

## Privacidad del asistente local

El asistente de uso y los reportes se ejecutan en el teléfono. El modelo de lenguaje se descarga una vez y las conversaciones se guardan en una base de datos local del dispositivo. Las consultas de reportes sí se envían al servidor de Kraken Draw para calcular las métricas con tus datos reales; el modelo local no recibe esos datos. El texto dictado se transcribe en el dispositivo y solo se envía al asistente como texto.
