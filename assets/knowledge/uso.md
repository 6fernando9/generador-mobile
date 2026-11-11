# Kraken Draw — uso de la aplicación móvil

Kraken Draw es una plataforma de Kraken S.R.L. para diseñar diagramas de clases UML de forma colaborativa y generar, a partir de ellos, proyectos de software con operaciones CRUD.

## Qué permite la app móvil

- Consultar el **dashboard personal**: generaciones de hoy, ayer, semana, mes y total histórico.
- Ver la **tendencia** de generaciones, la **distribución de tecnologías** (lenguajes, frameworks, arquitecturas, ORM y bases de datos), el **mapa de actividad** y el **ranking de proyectos**.
- Revisar el **historial de generaciones** y abrir el **visor de solo lectura** del diagrama y de los archivos descargados.
- Regenerar proyectos ZIP y exportaciones SQL desde el historial. Al guardar puedes elegir una ubicación; si cierras el selector, el archivo se guarda en la carpeta predeterminada de KrakenDraw.
- Gestionar el **perfil**: nombre de usuario, avatar, contraseña y plan actual.
- Conversar con el **asistente local** sobre el uso de la app y los términos y la privacidad.
- Generar **reportes dinámicos** a partir de las métricas personales. Los reportes requieren plan Pro; el rol administrador está exento.
- Dictar mensajes con el **micrófono**: el audio se transcribe en el dispositivo y solo el texto se envía al asistente.

## Qué no permite la app móvil

- No crea ni edita diagramas. El lienzo y la edición colaborativa están en el panel web.
- No administra usuarios, roles, permisos, planes ni pagos. Eso corresponde al panel web.
- No genera proyectos nuevos desde cero. La generación se inicia desde el panel web; la app consulta y descarga resultados.
- No sincroniza el historial del asistente entre dispositivos: el chat se guarda solo en este teléfono.
- Los reportes son personales. No hay reportes administrativos ni globales en el móvil.

## Flujo habitual

1. Inicia sesión con tu cuenta de Kraken Draw.
2. Revisa el dashboard y el historial de generaciones.
3. Abre una generación para ver el diagrama o descargar sus archivos.
4. Después de guardar una regeneración, usa **Abrir** en el aviso o pregunta al asistente dónde quedó para encontrarla y abrirla.
5. Usa el asistente para dudas de uso, términos o privacidad.
6. Si tienes plan Pro, pide un reporte en lenguaje natural, por ejemplo: «lenguajes más usados este mes» o «cuántas generaciones hice ayer».

El móvil conserva en el dispositivo las últimas 20 regeneraciones por cuenta para poder indicar su ubicación y volver a abrirlas. Ese historial no se sincroniza con el backend ni con otros dispositivos.

## Configuración avanzada

La configuración avanzada se realiza en el **panel web** de Kraken Draw: administración de proyectos, integrantes, generación de código, planes y permisos. La app móvil es un cliente de consulta y no reemplaza al panel web.

## Planes

- **Free**: dashboard, historial y visor de diagramas. Sin reportes dinámicos en el móvil.
- **Pro**: todo lo anterior más reportes dinámicos y exportación en PDF/CSV.
- **Administrador**: exento de la restricción de plan para los reportes.

El plan se consulta desde tu perfil. Los cambios de plan se gestionan en el panel web.

## Sin conexión

- El asistente de uso funciona sin internet una vez descargado el modelo local.
- Los reportes sin conexión solo pueden responder con datos ya consultados y guardados; en ese caso se indica la fecha de los datos.
- Si no hay datos guardados para el período pedido, el reporte necesita conexión.
