// Configuración de la app resuelta en tiempo de compilación.
//
// Se sobreescribe con --dart-define, igual que API_BASE_URL:
//   flutter run \
//     --dart-define=API_BASE_URL=http://10.0.2.2:4000/api \
//     --dart-define=WEB_BASE_URL=http://10.0.2.2:3000
//
// Nota: en el emulador de Android `localhost` es el propio emulador;
// la máquina de desarrollo se alcanza con 10.0.2.2. En un dispositivo
// físico hay que usar la IP LAN.
class AppConfig {
  const AppConfig._();

  /// Base del frontend web (draw.io-clone), sin `/api`.
  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// URL del visor público del diagrama de una generación.
  ///
  /// `view_only=true` oculta el panel de descarga del sitio web: en la app
  /// la descarga se hace de forma nativa con la cookie de Dio.
  static String diagramaUrl(String logId) {
    final base = webBaseUrl.endsWith('/')
        ? webBaseUrl.substring(0, webBaseUrl.length - 1)
        : webBaseUrl;
    return '$base/p/$logId/diagrama?view_only=true';
  }
}
