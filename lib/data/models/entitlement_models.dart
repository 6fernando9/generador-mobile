import 'package:mobile/data/models/profile_models.dart';

/// Derechos de acceso inferidos en el dispositivo y cacheados para el modo
/// offline. No vienen del backend: se derivan de `roles` y `plan.nombre_code`.
class CachedEntitlement {
  final bool esAdmin;
  final bool puedeReportes;
  final String? planCode;
  final String? username;
  final DateTime validadoEn;

  const CachedEntitlement({
    required this.esAdmin,
    required this.puedeReportes,
    this.planCode,
    this.username,
    required this.validadoEn,
  });

  static const Duration grace = Duration(days: 7);

  bool get vigente =>
      DateTime.now().difference(validadoEn) <= grace;

  factory CachedEntitlement.fromPerfil(Perfil perfil) {
    return CachedEntitlement(
      esAdmin: perfil.esAdmin,
      puedeReportes: perfil.puedeReportes,
      planCode: perfil.plan?.nombreCode ?? perfil.plan?.nombre,
      username: perfil.username,
      validadoEn: DateTime.now(),
    );
  }

  Map<String, Object?> toMap() => {
    'id': 1,
    'es_admin': esAdmin ? 1 : 0,
    'puede_reportes': puedeReportes ? 1 : 0,
    'plan_code': planCode,
    'username': username,
    'validado_en': validadoEn.millisecondsSinceEpoch,
  };

  factory CachedEntitlement.fromMap(Map<String, Object?> map) {
    return CachedEntitlement(
      esAdmin: (map['es_admin'] as int? ?? 0) == 1,
      puedeReportes: (map['puede_reportes'] as int? ?? 0) == 1,
      planCode: map['plan_code'] as String?,
      username: map['username'] as String?,
      validadoEn: DateTime.fromMillisecondsSinceEpoch(
        map['validado_en'] as int? ?? 0,
      ),
    );
  }
}
