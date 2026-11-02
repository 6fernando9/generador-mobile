// Providers de los catálogos usados por los modales de descarga.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/services/exportacion_service.dart';
import 'package:mobile/core/network/services/generacion_service.dart';

final generacionServiceProvider = Provider<GeneracionService>(
  (ref) => GeneracionService(),
);

final exportacionServiceProvider = Provider<ExportacionService>(
  (ref) => ExportacionService(),
);
