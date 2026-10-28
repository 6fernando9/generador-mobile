// Profile models for KrakenDraw - Manual JSON serialization

/// Rol (role) model - from backend roles array
class Rol {
  final String nombre;
  final String? nombreCode;
  final String? scope;

  const Rol({
    required this.nombre,
    this.nombreCode,
    this.scope,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      nombre: json['nombre'] as String? ?? json['nombre_code'] as String? ?? '',
      nombreCode: json['nombre_code'] as String?,
      scope: json['scope'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      if (nombreCode != null) 'nombre_code': nombreCode,
      if (scope != null) 'scope': scope,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rol &&
          runtimeType == other.runtimeType &&
          nombre == other.nombre &&
          nombreCode == other.nombreCode &&
          scope == other.scope;

  @override
  int get hashCode => nombre.hashCode ^ (nombreCode?.hashCode ?? 0) ^ (scope?.hashCode ?? 0);

  @override
  String toString() => 'Rol(nombre: $nombre, nombreCode: $nombreCode)';
}

/// Plan model
class Plan {
  final String nombre;
  final String? nombreCode;

  const Plan({
    required this.nombre,
    this.nombreCode,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      nombre: json['nombre'] as String? ?? json['nombre_code'] as String? ?? '',
      nombreCode: json['nombre_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      if (nombreCode != null) 'nombre_code': nombreCode,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Plan && runtimeType == other.runtimeType && nombre == other.nombre;

  @override
  int get hashCode => nombre.hashCode;

  @override
  String toString() => 'Plan(nombre: $nombre)';
}

/// EstadisticasPerfil - generation statistics from backend
class EstadisticasPerfil {
  final int generacionesHoy;
  final int generacionesTotal;

  const EstadisticasPerfil({
    required this.generacionesHoy,
    required this.generacionesTotal,
  });

  factory EstadisticasPerfil.fromJson(Map<String, dynamic> json) {
    return EstadisticasPerfil(
      generacionesHoy: json['generaciones_hoy'] as int? ?? 0,
      generacionesTotal: json['generaciones_total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'generaciones_hoy': generacionesHoy,
      'generaciones_total': generacionesTotal,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstadisticasPerfil &&
          runtimeType == other.runtimeType &&
          generacionesHoy == other.generacionesHoy &&
          generacionesTotal == other.generacionesTotal;

  @override
  int get hashCode => generacionesHoy.hashCode ^ generacionesTotal.hashCode;

  @override
  String toString() =>
      'EstadisticasPerfil(hoy: $generacionesHoy, total: $generacionesTotal)';
}

/// Perfil (profile) model from GET /api/perfil/
class Perfil {
  final int? id;
  final String username;
  final String email;
  final String? profileIcon;
  final String? profileIconTipo;
  final String? estado;
  final List<Rol> roles;
  final List<String> permisos;
  final Plan? plan;
  final EstadisticasPerfil estadisticas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Perfil({
    this.id,
    required this.username,
    required this.email,
    this.profileIcon,
    this.profileIconTipo,
    this.estado,
    this.roles = const [],
    this.permisos = const [],
    this.plan,
    required this.estadisticas,
    this.createdAt,
    this.updatedAt,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    // Parse roles array
    List<Rol> roles = [];
    if (json['roles'] != null) {
      roles = (json['roles'] as List).map((r) => Rol.fromJson(r as Map<String, dynamic>)).toList();
    }

    // Parse plan - could be in suscripcion.plan or directly
    Plan? plan;
    if (json['plan'] != null) {
      plan = Plan.fromJson(json['plan'] as Map<String, dynamic>);
    } else if (json['suscripcion'] != null && json['suscripcion']['plan'] != null) {
      plan = Plan.fromJson(json['suscripcion']['plan'] as Map<String, dynamic>);
    }

    // Parse estadisticas
    final estadisticas = json['estadisticas'] != null
        ? EstadisticasPerfil.fromJson(json['estadisticas'] as Map<String, dynamic>)
        : const EstadisticasPerfil(generacionesHoy: 0, generacionesTotal: 0);

    return Perfil(
      id: json['id'] as int?,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileIcon: json['profile_icon'] as String?,
      profileIconTipo: json['profile_icon_tipo'] as String?,
      estado: json['estado'] as String?,
      roles: roles,
      permisos: json['permisos'] != null ? (json['permisos'] as List).map((p) => p.toString()).toList() : [],
      plan: plan,
      estadisticas: estadisticas,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
    );
  }

  /// Get primary role name for display
  String get primaryRoleName => roles.isNotEmpty ? roles.first.nombre : 'Sin rol';

  /// Get primary role nombre_code for permission checks
  String? get primaryRoleCode => roles.isNotEmpty ? roles.first.nombreCode : null;

  /// Get plan name for display
  String get planName => plan?.nombre ?? 'Sin plan';

  /// Get generations today
  int get generacionesHoy => estadisticas.generacionesHoy;

  /// Get total generations
  int get generacionesTotal => estadisticas.generacionesTotal;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'profile_icon': profileIcon,
      if (profileIconTipo != null) 'profile_icon_tipo': profileIconTipo,
      if (estado != null) 'estado': estado,
      'roles': roles.map((r) => r.toJson()).toList(),
      'permisos': permisos,
      if (plan != null) 'plan': plan!.toJson(),
      'estadisticas': estadisticas.toJson(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Perfil &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          profileIcon == other.profileIcon &&
          estado == other.estado &&
          plan == other.plan &&
          estadisticas == other.estadisticas &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      (id?.hashCode ?? 0) ^
      username.hashCode ^
      email.hashCode ^
      (profileIcon?.hashCode ?? 0) ^
      (estado?.hashCode ?? 0) ^
      (plan?.hashCode ?? 0) ^
      estadisticas.hashCode ^
      (createdAt?.hashCode ?? 0);

  @override
  String toString() =>
      'Perfil(username: $username, email: $email, role: $primaryRoleName, plan: $planName, stats: $estadisticas)';
}

/// Update profile request payload
class UpdateProfileRequest {
  final String username;
  final String email;

  const UpdateProfileRequest({
    required this.username,
    required this.email,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateProfileRequest &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          email == other.email;

  @override
  int get hashCode => username.hashCode ^ email.hashCode;

  @override
  String toString() => 'UpdateProfileRequest(username: $username, email: $email)';
}

/// Change password request payload
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      currentPassword: json['password_actual'] as String,
      newPassword: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password_actual': currentPassword,
      'password': newPassword,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangePasswordRequest &&
          runtimeType == other.runtimeType &&
          currentPassword == other.currentPassword &&
          newPassword == other.newPassword;

  @override
  int get hashCode => currentPassword.hashCode ^ newPassword.hashCode;

  @override
  String toString() => 'ChangePasswordRequest()';
}