// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_proyectos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardProyectos {

 int get total; List<ProjectRanking> get proyectos; List<UserRanking> get usuarios;
/// Create a copy of DashboardProyectos
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardProyectosCopyWith<DashboardProyectos> get copyWith => _$DashboardProyectosCopyWithImpl<DashboardProyectos>(this as DashboardProyectos, _$identity);

  /// Serializes this DashboardProyectos to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardProyectos;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardProyectos&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.proyectos, _this.proyectos)&&const DeepCollectionEquality().equals(other.usuarios, _this.usuarios));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardProyectos;
  return Object.hash(runtimeType,_this.total,const DeepCollectionEquality().hash(_this.proyectos),const DeepCollectionEquality().hash(_this.usuarios));
}

@override
String toString() {
  final _this = this as DashboardProyectos;
  return 'DashboardProyectos(total: ${_this.total}, proyectos: ${_this.proyectos}, usuarios: ${_this.usuarios})';
}


}

/// @nodoc
abstract mixin class $DashboardProyectosCopyWith<$Res>  {
  factory $DashboardProyectosCopyWith(DashboardProyectos value, $Res Function(DashboardProyectos) _then) = _$DashboardProyectosCopyWithImpl;
@useResult
$Res call({
 int total, List<ProjectRanking> proyectos, List<UserRanking> usuarios
});




}
/// @nodoc
class _$DashboardProyectosCopyWithImpl<$Res>
    implements $DashboardProyectosCopyWith<$Res> {
  _$DashboardProyectosCopyWithImpl(this._self, this._then);

  final DashboardProyectos _self;
  final $Res Function(DashboardProyectos) _then;

/// Create a copy of DashboardProyectos
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? proyectos = null,Object? usuarios = null,}) {
  return _then(DashboardProyectos(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,proyectos: null == proyectos ? _self.proyectos : proyectos // ignore: cast_nullable_to_non_nullable
as List<ProjectRanking>,usuarios: null == usuarios ? _self.usuarios : usuarios // ignore: cast_nullable_to_non_nullable
as List<UserRanking>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardProyectos].
extension DashboardProyectosPatterns on DashboardProyectos {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardProyectos value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardProyectos() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardProyectos value)  $default,){
final _that = this;
switch (_that) {
case _DashboardProyectos():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardProyectos value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardProyectos() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<ProjectRanking> proyectos,  List<UserRanking> usuarios)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardProyectos() when $default != null:
return $default(_that.total,_that.proyectos,_that.usuarios);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<ProjectRanking> proyectos,  List<UserRanking> usuarios)  $default,) {final _that = this;
switch (_that) {
case _DashboardProyectos():
return $default(_that.total,_that.proyectos,_that.usuarios);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<ProjectRanking> proyectos,  List<UserRanking> usuarios)?  $default,) {final _that = this;
switch (_that) {
case _DashboardProyectos() when $default != null:
return $default(_that.total,_that.proyectos,_that.usuarios);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardProyectos implements DashboardProyectos {
  const _DashboardProyectos({this.total = 0,  List<ProjectRanking> proyectos = const [],  List<UserRanking> usuarios = const []}): _proyectos = proyectos,_usuarios = usuarios;
  factory _DashboardProyectos.fromJson(Map<String, dynamic> json) => _$DashboardProyectosFromJson(json);

@override@JsonKey() final  int total;
 final  List<ProjectRanking> _proyectos;
@override@JsonKey() List<ProjectRanking> get proyectos {
  if (_proyectos is EqualUnmodifiableListView) return _proyectos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_proyectos);
}

 final  List<UserRanking> _usuarios;
@override@JsonKey() List<UserRanking> get usuarios {
  if (_usuarios is EqualUnmodifiableListView) return _usuarios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usuarios);
}


/// Create a copy of DashboardProyectos
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardProyectosCopyWith<_DashboardProyectos> get copyWith => __$DashboardProyectosCopyWithImpl<_DashboardProyectos>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardProyectosToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardProyectos&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.proyectos, _proyectos)&&const DeepCollectionEquality().equals(other.usuarios, _usuarios));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_proyectos),const DeepCollectionEquality().hash(_usuarios));
}

@override
String toString() {
    return 'DashboardProyectos(total: $total, proyectos: $proyectos, usuarios: $usuarios)';
}


}

/// @nodoc
abstract mixin class _$DashboardProyectosCopyWith<$Res> implements $DashboardProyectosCopyWith<$Res> {
  factory _$DashboardProyectosCopyWith(_DashboardProyectos value, $Res Function(_DashboardProyectos) _then) = __$DashboardProyectosCopyWithImpl;
@override @useResult
$Res call({
 int total, List<ProjectRanking> proyectos, List<UserRanking> usuarios
});




}
/// @nodoc
class __$DashboardProyectosCopyWithImpl<$Res>
    implements _$DashboardProyectosCopyWith<$Res> {
  __$DashboardProyectosCopyWithImpl(this._self, this._then);

  final _DashboardProyectos _self;
  final $Res Function(_DashboardProyectos) _then;

/// Create a copy of DashboardProyectos
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? proyectos = null,Object? usuarios = null,}) {
  return _then(_DashboardProyectos(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,proyectos: null == proyectos ? _self._proyectos : proyectos // ignore: cast_nullable_to_non_nullable
as List<ProjectRanking>,usuarios: null == usuarios ? _self._usuarios : usuarios // ignore: cast_nullable_to_non_nullable
as List<UserRanking>,
  ));
}


}


/// @nodoc
mixin _$ProjectRanking {

 String get id; String get nombre; int get total; double get porcentaje;
/// Create a copy of ProjectRanking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectRankingCopyWith<ProjectRanking> get copyWith => _$ProjectRankingCopyWithImpl<ProjectRanking>(this as ProjectRanking, _$identity);

  /// Serializes this ProjectRanking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectRanking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectRanking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.porcentaje, _this.porcentaje) || other.porcentaje == _this.porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectRanking;
  return Object.hash(runtimeType,_this.id,_this.nombre,_this.total,_this.porcentaje);
}

@override
String toString() {
  final _this = this as ProjectRanking;
  return 'ProjectRanking(id: ${_this.id}, nombre: ${_this.nombre}, total: ${_this.total}, porcentaje: ${_this.porcentaje})';
}


}

/// @nodoc
abstract mixin class $ProjectRankingCopyWith<$Res>  {
  factory $ProjectRankingCopyWith(ProjectRanking value, $Res Function(ProjectRanking) _then) = _$ProjectRankingCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, int total, double porcentaje
});




}
/// @nodoc
class _$ProjectRankingCopyWithImpl<$Res>
    implements $ProjectRankingCopyWith<$Res> {
  _$ProjectRankingCopyWithImpl(this._self, this._then);

  final ProjectRanking _self;
  final $Res Function(ProjectRanking) _then;

/// Create a copy of ProjectRanking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? total = null,Object? porcentaje = null,}) {
  return _then(ProjectRanking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectRanking].
extension ProjectRankingPatterns on ProjectRanking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectRanking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectRanking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectRanking value)  $default,){
final _that = this;
switch (_that) {
case _ProjectRanking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectRanking value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectRanking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  int total,  double porcentaje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectRanking() when $default != null:
return $default(_that.id,_that.nombre,_that.total,_that.porcentaje);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  int total,  double porcentaje)  $default,) {final _that = this;
switch (_that) {
case _ProjectRanking():
return $default(_that.id,_that.nombre,_that.total,_that.porcentaje);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  int total,  double porcentaje)?  $default,) {final _that = this;
switch (_that) {
case _ProjectRanking() when $default != null:
return $default(_that.id,_that.nombre,_that.total,_that.porcentaje);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectRanking implements ProjectRanking {
  const _ProjectRanking({this.id = '', this.nombre = '', this.total = 0, this.porcentaje = 0.0});
  factory _ProjectRanking.fromJson(Map<String, dynamic> json) => _$ProjectRankingFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String nombre;
@override@JsonKey() final  int total;
@override@JsonKey() final  double porcentaje;

/// Create a copy of ProjectRanking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectRankingCopyWith<_ProjectRanking> get copyWith => __$ProjectRankingCopyWithImpl<_ProjectRanking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectRankingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectRanking&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.total, total) || other.total == total)&&(identical(other.porcentaje, porcentaje) || other.porcentaje == porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nombre,total,porcentaje);
}

@override
String toString() {
    return 'ProjectRanking(id: $id, nombre: $nombre, total: $total, porcentaje: $porcentaje)';
}


}

/// @nodoc
abstract mixin class _$ProjectRankingCopyWith<$Res> implements $ProjectRankingCopyWith<$Res> {
  factory _$ProjectRankingCopyWith(_ProjectRanking value, $Res Function(_ProjectRanking) _then) = __$ProjectRankingCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, int total, double porcentaje
});




}
/// @nodoc
class __$ProjectRankingCopyWithImpl<$Res>
    implements _$ProjectRankingCopyWith<$Res> {
  __$ProjectRankingCopyWithImpl(this._self, this._then);

  final _ProjectRanking _self;
  final $Res Function(_ProjectRanking) _then;

/// Create a copy of ProjectRanking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? total = null,Object? porcentaje = null,}) {
  return _then(_ProjectRanking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$UserRanking {

 int get id; String get username; String? get profileIcon;@JsonKey(name: 'profile_icon_tipo') String? get profileIconTipo; int get total; double get porcentaje;
/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRankingCopyWith<UserRanking> get copyWith => _$UserRankingCopyWithImpl<UserRanking>(this as UserRanking, _$identity);

  /// Serializes this UserRanking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRanking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRanking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.profileIcon, _this.profileIcon) || other.profileIcon == _this.profileIcon)&&(identical(other.profileIconTipo, _this.profileIconTipo) || other.profileIconTipo == _this.profileIconTipo)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.porcentaje, _this.porcentaje) || other.porcentaje == _this.porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRanking;
  return Object.hash(runtimeType,_this.id,_this.username,_this.profileIcon,_this.profileIconTipo,_this.total,_this.porcentaje);
}

@override
String toString() {
  final _this = this as UserRanking;
  return 'UserRanking(id: ${_this.id}, username: ${_this.username}, profileIcon: ${_this.profileIcon}, profileIconTipo: ${_this.profileIconTipo}, total: ${_this.total}, porcentaje: ${_this.porcentaje})';
}


}

/// @nodoc
abstract mixin class $UserRankingCopyWith<$Res>  {
  factory $UserRankingCopyWith(UserRanking value, $Res Function(UserRanking) _then) = _$UserRankingCopyWithImpl;
@useResult
$Res call({
 int id, String username, String? profileIcon,@JsonKey(name: 'profile_icon_tipo') String? profileIconTipo, int total, double porcentaje
});




}
/// @nodoc
class _$UserRankingCopyWithImpl<$Res>
    implements $UserRankingCopyWith<$Res> {
  _$UserRankingCopyWithImpl(this._self, this._then);

  final UserRanking _self;
  final $Res Function(UserRanking) _then;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? profileIcon = freezed,Object? profileIconTipo = freezed,Object? total = null,Object? porcentaje = null,}) {
  return _then(UserRanking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileIcon: freezed == profileIcon ? _self.profileIcon : profileIcon // ignore: cast_nullable_to_non_nullable
as String?,profileIconTipo: freezed == profileIconTipo ? _self.profileIconTipo : profileIconTipo // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRanking].
extension UserRankingPatterns on UserRanking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRanking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRanking value)  $default,){
final _that = this;
switch (_that) {
case _UserRanking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRanking value)?  $default,){
final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo,  int total,  double porcentaje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo,_that.total,_that.porcentaje);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo,  int total,  double porcentaje)  $default,) {final _that = this;
switch (_that) {
case _UserRanking():
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo,_that.total,_that.porcentaje);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo,  int total,  double porcentaje)?  $default,) {final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo,_that.total,_that.porcentaje);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRanking implements UserRanking {
  const _UserRanking({this.id = 0, this.username = '', this.profileIcon, @JsonKey(name: 'profile_icon_tipo') this.profileIconTipo, this.total = 0, this.porcentaje = 0.0});
  factory _UserRanking.fromJson(Map<String, dynamic> json) => _$UserRankingFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String username;
@override final  String? profileIcon;
@override@JsonKey(name: 'profile_icon_tipo') final  String? profileIconTipo;
@override@JsonKey() final  int total;
@override@JsonKey() final  double porcentaje;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRankingCopyWith<_UserRanking> get copyWith => __$UserRankingCopyWithImpl<_UserRanking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRankingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRanking&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.profileIcon, profileIcon) || other.profileIcon == profileIcon)&&(identical(other.profileIconTipo, profileIconTipo) || other.profileIconTipo == profileIconTipo)&&(identical(other.total, total) || other.total == total)&&(identical(other.porcentaje, porcentaje) || other.porcentaje == porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,profileIcon,profileIconTipo,total,porcentaje);
}

@override
String toString() {
    return 'UserRanking(id: $id, username: $username, profileIcon: $profileIcon, profileIconTipo: $profileIconTipo, total: $total, porcentaje: $porcentaje)';
}


}

/// @nodoc
abstract mixin class _$UserRankingCopyWith<$Res> implements $UserRankingCopyWith<$Res> {
  factory _$UserRankingCopyWith(_UserRanking value, $Res Function(_UserRanking) _then) = __$UserRankingCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String? profileIcon,@JsonKey(name: 'profile_icon_tipo') String? profileIconTipo, int total, double porcentaje
});




}
/// @nodoc
class __$UserRankingCopyWithImpl<$Res>
    implements _$UserRankingCopyWith<$Res> {
  __$UserRankingCopyWithImpl(this._self, this._then);

  final _UserRanking _self;
  final $Res Function(_UserRanking) _then;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? profileIcon = freezed,Object? profileIconTipo = freezed,Object? total = null,Object? porcentaje = null,}) {
  return _then(_UserRanking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileIcon: freezed == profileIcon ? _self.profileIcon : profileIcon // ignore: cast_nullable_to_non_nullable
as String?,profileIconTipo: freezed == profileIconTipo ? _self.profileIconTipo : profileIconTipo // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
