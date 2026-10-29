// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_proyectos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardProyectos _$DashboardProyectosFromJson(Map<String, dynamic> json) =>
    _DashboardProyectos(
      total: (json['total'] as num?)?.toInt() ?? 0,
      proyectos:
          (json['proyectos'] as List<dynamic>?)
              ?.map((e) => ProjectRanking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      usuarios:
          (json['usuarios'] as List<dynamic>?)
              ?.map((e) => UserRanking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DashboardProyectosToJson(_DashboardProyectos instance) =>
    <String, dynamic>{
      'total': instance.total,
      'proyectos': instance.proyectos,
      'usuarios': instance.usuarios,
    };

_ProjectRanking _$ProjectRankingFromJson(Map<String, dynamic> json) =>
    _ProjectRanking(
      id: json['id'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      porcentaje: (json['porcentaje'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ProjectRankingToJson(_ProjectRanking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'total': instance.total,
      'porcentaje': instance.porcentaje,
    };

_UserRanking _$UserRankingFromJson(Map<String, dynamic> json) => _UserRanking(
  id: (json['id'] as num?)?.toInt() ?? 0,
  username: json['username'] as String? ?? '',
  profileIcon: json['profileIcon'] as String?,
  profileIconTipo: json['profile_icon_tipo'] as String?,
  total: (json['total'] as num?)?.toInt() ?? 0,
  porcentaje: (json['porcentaje'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$UserRankingToJson(_UserRanking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profileIcon': instance.profileIcon,
      'profile_icon_tipo': instance.profileIconTipo,
      'total': instance.total,
      'porcentaje': instance.porcentaje,
    };
