// Catálogos del motor de generación (`GET /generacion/opciones`).
//
// Se usan en el modal de regeneración de proyecto: tipo de artefacto,
// lenguajes, frameworks, ORMs, arquitecturas y bases de datos destino.
// Serialización manual para evitar codegen en catálogos de solo lectura.

/// Dimensión tecnológica (lenguaje, framework, ORM, arquitectura, BD...).
class OpcionDimension {
  final int id;
  final String nombre;
  final String nombreCode;
  final String? icono;
  final String? iconoTipo;

  const OpcionDimension({
    required this.id,
    required this.nombre,
    this.nombreCode = '',
    this.icono,
    this.iconoTipo,
  });

  factory OpcionDimension.fromJson(Map<String, dynamic> json) {
    return OpcionDimension(
      id: asInt(json['id']),
      nombre: (json['nombre'] ?? '').toString(),
      nombreCode: (json['nombre_code'] ?? '').toString(),
      icono: json['icono'] as String?,
      iconoTipo: json['icono_tipo']?.toString(),
    );
  }
}

/// Framework con sus ORMs compatibles.
class OpcionFramework extends OpcionDimension {
  final List<OpcionDimension> orms;

  const OpcionFramework({
    required super.id,
    required super.nombre,
    super.nombreCode,
    super.icono,
    super.iconoTipo,
    this.orms = const [],
  });

  factory OpcionFramework.fromJson(Map<String, dynamic> json) {
    final base = OpcionDimension.fromJson(json);
    return OpcionFramework(
      id: base.id,
      nombre: base.nombre,
      nombreCode: base.nombreCode,
      icono: base.icono,
      iconoTipo: base.iconoTipo,
      orms: _lista(json['orms'])
          .map((e) => OpcionDimension.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Lenguaje con sus frameworks compatibles.
class OpcionLenguaje extends OpcionDimension {
  final List<OpcionFramework> frameworks;

  const OpcionLenguaje({
    required super.id,
    required super.nombre,
    super.nombreCode,
    super.icono,
    super.iconoTipo,
    this.frameworks = const [],
  });

  factory OpcionLenguaje.fromJson(Map<String, dynamic> json) {
    final base = OpcionDimension.fromJson(json);
    return OpcionLenguaje(
      id: base.id,
      nombre: base.nombre,
      nombreCode: base.nombreCode,
      icono: base.icono,
      iconoTipo: base.iconoTipo,
      frameworks: _lista(json['frameworks'])
          .map((e) => OpcionFramework.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Qué dimensiones exige el tipo de artefacto para poder generarse.
class RequerimientosGeneracion {
  final bool orm;
  final bool baseDatos;
  final bool arquitectura;

  const RequerimientosGeneracion({
    this.orm = false,
    this.baseDatos = false,
    this.arquitectura = false,
  });

  factory RequerimientosGeneracion.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RequerimientosGeneracion();
    return RequerimientosGeneracion(
      orm: json['orm'] == true,
      baseDatos: json['base_datos'] == true,
      arquitectura: json['arquitectura'] == true,
    );
  }
}

/// Tipo de artefacto generable (backend, frontend, mobile).
class OpcionTipoArtefacto extends OpcionDimension {
  final RequerimientosGeneracion requiere;
  final List<OpcionDimension> arquitecturas;
  final List<OpcionLenguaje> lenguajes;

  const OpcionTipoArtefacto({
    required super.id,
    required super.nombre,
    super.nombreCode,
    super.icono,
    super.iconoTipo,
    this.requiere = const RequerimientosGeneracion(),
    this.arquitecturas = const [],
    this.lenguajes = const [],
  });

  factory OpcionTipoArtefacto.fromJson(Map<String, dynamic> json) {
    final base = OpcionDimension.fromJson(json);
    return OpcionTipoArtefacto(
      id: base.id,
      nombre: base.nombre,
      nombreCode: base.nombreCode,
      icono: base.icono,
      iconoTipo: base.iconoTipo,
      requiere: RequerimientosGeneracion.fromJson(
        json['requiere'] as Map<String, dynamic>?,
      ),
      arquitecturas: _lista(json['arquitecturas'])
          .map((e) => OpcionDimension.fromJson(e))
          .toList(growable: false),
      lenguajes: _lista(json['lenguajes'])
          .map((e) => OpcionLenguaje.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Respuesta completa de `/generacion/opciones`.
class OpcionesGeneracion {
  final List<OpcionTipoArtefacto> tiposArtefacto;
  final List<OpcionDimension> basesDatosDestino;

  const OpcionesGeneracion({
    this.tiposArtefacto = const [],
    this.basesDatosDestino = const [],
  });

  factory OpcionesGeneracion.fromJson(Map<String, dynamic> json) {
    return OpcionesGeneracion(
      tiposArtefacto: _lista(json['tipos_artefacto'])
          .map((e) => OpcionTipoArtefacto.fromJson(e))
          .toList(growable: false),
      basesDatosDestino: _lista(json['bases_datos_destino'])
          .map((e) => OpcionDimension.fromJson(e))
          .toList(growable: false),
    );
  }
}

/// Credenciales de la base de datos destino que se embeben al regenerar.
class DatabaseConfiguration {
  final String host;
  final String name;
  final String user;
  final String password;
  final String port;

  const DatabaseConfiguration({
    this.host = '',
    this.name = '',
    this.user = '',
    this.password = '',
    this.port = '5432',
  });

  factory DatabaseConfiguration.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DatabaseConfiguration();
    return DatabaseConfiguration(
      host: (json['host'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      user: (json['user'] ?? '').toString(),
      password: (json['password'] ?? '').toString(),
      port: (json['port'] ?? '5432').toString(),
    );
  }

  DatabaseConfiguration copyWith({
    String? host,
    String? name,
    String? user,
    String? password,
    String? port,
  }) {
    return DatabaseConfiguration(
      host: host ?? this.host,
      name: name ?? this.name,
      user: user ?? this.user,
      password: password ?? this.password,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toJson() => {
    'host': host,
    'name': name,
    'user': user,
    'password': password,
    'port': port,
  };
}

List<Map<String, dynamic>> _lista(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList(growable: false);
}

/// Convierte `num`/`String` a `int` sin lanzar.
int asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
