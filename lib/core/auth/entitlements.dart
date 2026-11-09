import 'package:mobile/core/storage/local_database.dart';
import 'package:mobile/data/models/entitlement_models.dart';
import 'package:mobile/data/models/profile_models.dart';

/// Acceso a reportes inferido en el dispositivo.
///
/// El backend no devuelve `esAdmin` ni `puedeReportes`: se derivan de `roles`
/// y `plan.nombre_code`. Para el modo offline se guarda la última validación y
/// se respeta un máximo de 7 días.
class Entitlements {
  const Entitlements._();

  static Future<CachedEntitlement?> cached() =>
      LocalDatabase.instance.loadEntitlement();

  /// Guarda la validación de un perfil obtenido con conexión.
  static Future<CachedEntitlement> saveFromProfile(Perfil perfil) async {
    final entitlement = CachedEntitlement.fromPerfil(perfil);
    await LocalDatabase.instance.saveEntitlement(entitlement);
    return entitlement;
  }

  /// Decide si el usuario puede generar reportes ahora.
  ///
  /// - Con perfil en línea: manda el perfil (plan/rol actuales).
  /// - Sin conexión: manda la última validación cacheada si tiene ≤ 7 días.
  static Future<bool> puedeReportes({
    Perfil? perfil,
    required bool offline,
  }) async {
    if (!offline && perfil != null) {
      return perfil.puedeReportes;
    }

    final cached = await Entitlements.cached();
    if (cached != null && cached.vigente) {
      return cached.puedeReportes;
    }

    // Sin caché vigente no se habilitan reportes offline. Si el perfil está
    // disponible (aunque sea el cacheado), se usa como última referencia.
    return perfil?.puedeReportes ?? false;
  }

  static Future<void> clear() async {
    await LocalDatabase.instance.clearAll();
  }
}
