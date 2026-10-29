// Dashboard Proyectos (Top Projects & Users) models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_proyectos.freezed.dart';
part 'dashboard_proyectos.g.dart';

@freezed
abstract class DashboardProyectos with _$DashboardProyectos {
  const factory DashboardProyectos({
    @Default(0) int total,
    @Default([]) List<ProjectRanking> proyectos,
    @Default([]) List<UserRanking> usuarios,
  }) = _DashboardProyectos;

  factory DashboardProyectos.fromJson(Map<String, dynamic> json) =>
      _$DashboardProyectosFromJson(json);
}

@freezed
abstract class ProjectRanking with _$ProjectRanking {
  const factory ProjectRanking({
    @Default('') String id,
    @Default('') String nombre,
    @Default(0) int total,
    @Default(0.0) double porcentaje,
  }) = _ProjectRanking;

  factory ProjectRanking.fromJson(Map<String, dynamic> json) =>
      _$ProjectRankingFromJson(json);
}

@freezed
abstract class UserRanking with _$UserRanking {
  const factory UserRanking({
    @Default(0) int id,
    @Default('') String username,
    String? profileIcon,
    @JsonKey(name: 'profile_icon_tipo') String? profileIconTipo,
    @Default(0) int total,
    @Default(0.0) double porcentaje,
  }) = _UserRanking;

  factory UserRanking.fromJson(Map<String, dynamic> json) =>
      _$UserRankingFromJson(json);
}