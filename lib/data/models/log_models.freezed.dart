// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogDimensionRef {

 int get id; String get nombre;@JsonKey(name: 'nombre_code') String get nombreCode; String? get icono;@JsonKey(name: 'icono_tipo') String? get iconoTipo;
/// Create a copy of LogDimensionRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<LogDimensionRef> get copyWith => _$LogDimensionRefCopyWithImpl<LogDimensionRef>(this as LogDimensionRef, _$identity);

  /// Serializes this LogDimensionRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogDimensionRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogDimensionRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre)&&(identical(other.nombreCode, _this.nombreCode) || other.nombreCode == _this.nombreCode)&&(identical(other.icono, _this.icono) || other.icono == _this.icono)&&(identical(other.iconoTipo, _this.iconoTipo) || other.iconoTipo == _this.iconoTipo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogDimensionRef;
  return Object.hash(runtimeType,_this.id,_this.nombre,_this.nombreCode,_this.icono,_this.iconoTipo);
}

@override
String toString() {
  final _this = this as LogDimensionRef;
  return 'LogDimensionRef(id: ${_this.id}, nombre: ${_this.nombre}, nombreCode: ${_this.nombreCode}, icono: ${_this.icono}, iconoTipo: ${_this.iconoTipo})';
}


}

/// @nodoc
abstract mixin class $LogDimensionRefCopyWith<$Res>  {
  factory $LogDimensionRefCopyWith(LogDimensionRef value, $Res Function(LogDimensionRef) _then) = _$LogDimensionRefCopyWithImpl;
@useResult
$Res call({
 int id, String nombre,@JsonKey(name: 'nombre_code') String nombreCode, String? icono,@JsonKey(name: 'icono_tipo') String? iconoTipo
});




}
/// @nodoc
class _$LogDimensionRefCopyWithImpl<$Res>
    implements $LogDimensionRefCopyWith<$Res> {
  _$LogDimensionRefCopyWithImpl(this._self, this._then);

  final LogDimensionRef _self;
  final $Res Function(LogDimensionRef) _then;

/// Create a copy of LogDimensionRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? nombreCode = null,Object? icono = freezed,Object? iconoTipo = freezed,}) {
  return _then(LogDimensionRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,nombreCode: null == nombreCode ? _self.nombreCode : nombreCode // ignore: cast_nullable_to_non_nullable
as String,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,iconoTipo: freezed == iconoTipo ? _self.iconoTipo : iconoTipo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LogDimensionRef].
extension LogDimensionRefPatterns on LogDimensionRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogDimensionRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogDimensionRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogDimensionRef value)  $default,){
final _that = this;
switch (_that) {
case _LogDimensionRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogDimensionRef value)?  $default,){
final _that = this;
switch (_that) {
case _LogDimensionRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogDimensionRef() when $default != null:
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo)  $default,) {final _that = this;
switch (_that) {
case _LogDimensionRef():
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo)?  $default,) {final _that = this;
switch (_that) {
case _LogDimensionRef() when $default != null:
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogDimensionRef implements LogDimensionRef {
  const _LogDimensionRef({this.id = 0, this.nombre = '', @JsonKey(name: 'nombre_code') this.nombreCode = '', this.icono, @JsonKey(name: 'icono_tipo') this.iconoTipo});
  factory _LogDimensionRef.fromJson(Map<String, dynamic> json) => _$LogDimensionRefFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String nombre;
@override@JsonKey(name: 'nombre_code') final  String nombreCode;
@override final  String? icono;
@override@JsonKey(name: 'icono_tipo') final  String? iconoTipo;

/// Create a copy of LogDimensionRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogDimensionRefCopyWith<_LogDimensionRef> get copyWith => __$LogDimensionRefCopyWithImpl<_LogDimensionRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogDimensionRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogDimensionRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.nombreCode, nombreCode) || other.nombreCode == nombreCode)&&(identical(other.icono, icono) || other.icono == icono)&&(identical(other.iconoTipo, iconoTipo) || other.iconoTipo == iconoTipo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nombre,nombreCode,icono,iconoTipo);
}

@override
String toString() {
    return 'LogDimensionRef(id: $id, nombre: $nombre, nombreCode: $nombreCode, icono: $icono, iconoTipo: $iconoTipo)';
}


}

/// @nodoc
abstract mixin class _$LogDimensionRefCopyWith<$Res> implements $LogDimensionRefCopyWith<$Res> {
  factory _$LogDimensionRefCopyWith(_LogDimensionRef value, $Res Function(_LogDimensionRef) _then) = __$LogDimensionRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String nombre,@JsonKey(name: 'nombre_code') String nombreCode, String? icono,@JsonKey(name: 'icono_tipo') String? iconoTipo
});




}
/// @nodoc
class __$LogDimensionRefCopyWithImpl<$Res>
    implements _$LogDimensionRefCopyWith<$Res> {
  __$LogDimensionRefCopyWithImpl(this._self, this._then);

  final _LogDimensionRef _self;
  final $Res Function(_LogDimensionRef) _then;

/// Create a copy of LogDimensionRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? nombreCode = null,Object? icono = freezed,Object? iconoTipo = freezed,}) {
  return _then(_LogDimensionRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,nombreCode: null == nombreCode ? _self.nombreCode : nombreCode // ignore: cast_nullable_to_non_nullable
as String,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,iconoTipo: freezed == iconoTipo ? _self.iconoTipo : iconoTipo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LogProyectoRef {

 String get id; String get nombre;
/// Create a copy of LogProyectoRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogProyectoRefCopyWith<LogProyectoRef> get copyWith => _$LogProyectoRefCopyWithImpl<LogProyectoRef>(this as LogProyectoRef, _$identity);

  /// Serializes this LogProyectoRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogProyectoRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogProyectoRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogProyectoRef;
  return Object.hash(runtimeType,_this.id,_this.nombre);
}

@override
String toString() {
  final _this = this as LogProyectoRef;
  return 'LogProyectoRef(id: ${_this.id}, nombre: ${_this.nombre})';
}


}

/// @nodoc
abstract mixin class $LogProyectoRefCopyWith<$Res>  {
  factory $LogProyectoRefCopyWith(LogProyectoRef value, $Res Function(LogProyectoRef) _then) = _$LogProyectoRefCopyWithImpl;
@useResult
$Res call({
 String id, String nombre
});




}
/// @nodoc
class _$LogProyectoRefCopyWithImpl<$Res>
    implements $LogProyectoRefCopyWith<$Res> {
  _$LogProyectoRefCopyWithImpl(this._self, this._then);

  final LogProyectoRef _self;
  final $Res Function(LogProyectoRef) _then;

/// Create a copy of LogProyectoRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,}) {
  return _then(LogProyectoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LogProyectoRef].
extension LogProyectoRefPatterns on LogProyectoRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogProyectoRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogProyectoRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogProyectoRef value)  $default,){
final _that = this;
switch (_that) {
case _LogProyectoRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogProyectoRef value)?  $default,){
final _that = this;
switch (_that) {
case _LogProyectoRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogProyectoRef() when $default != null:
return $default(_that.id,_that.nombre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre)  $default,) {final _that = this;
switch (_that) {
case _LogProyectoRef():
return $default(_that.id,_that.nombre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre)?  $default,) {final _that = this;
switch (_that) {
case _LogProyectoRef() when $default != null:
return $default(_that.id,_that.nombre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogProyectoRef implements LogProyectoRef {
  const _LogProyectoRef({this.id = '', this.nombre = ''});
  factory _LogProyectoRef.fromJson(Map<String, dynamic> json) => _$LogProyectoRefFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String nombre;

/// Create a copy of LogProyectoRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogProyectoRefCopyWith<_LogProyectoRef> get copyWith => __$LogProyectoRefCopyWithImpl<_LogProyectoRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogProyectoRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogProyectoRef&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nombre);
}

@override
String toString() {
    return 'LogProyectoRef(id: $id, nombre: $nombre)';
}


}

/// @nodoc
abstract mixin class _$LogProyectoRefCopyWith<$Res> implements $LogProyectoRefCopyWith<$Res> {
  factory _$LogProyectoRefCopyWith(_LogProyectoRef value, $Res Function(_LogProyectoRef) _then) = __$LogProyectoRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre
});




}
/// @nodoc
class __$LogProyectoRefCopyWithImpl<$Res>
    implements _$LogProyectoRefCopyWith<$Res> {
  __$LogProyectoRefCopyWithImpl(this._self, this._then);

  final _LogProyectoRef _self;
  final $Res Function(_LogProyectoRef) _then;

/// Create a copy of LogProyectoRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,}) {
  return _then(_LogProyectoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LogUsuarioRef {

 int get id; String get username;@JsonKey(name: 'profile_icon') String? get profileIcon;@JsonKey(name: 'profile_icon_tipo') String? get profileIconTipo;
/// Create a copy of LogUsuarioRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogUsuarioRefCopyWith<LogUsuarioRef> get copyWith => _$LogUsuarioRefCopyWithImpl<LogUsuarioRef>(this as LogUsuarioRef, _$identity);

  /// Serializes this LogUsuarioRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogUsuarioRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogUsuarioRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.profileIcon, _this.profileIcon) || other.profileIcon == _this.profileIcon)&&(identical(other.profileIconTipo, _this.profileIconTipo) || other.profileIconTipo == _this.profileIconTipo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogUsuarioRef;
  return Object.hash(runtimeType,_this.id,_this.username,_this.profileIcon,_this.profileIconTipo);
}

@override
String toString() {
  final _this = this as LogUsuarioRef;
  return 'LogUsuarioRef(id: ${_this.id}, username: ${_this.username}, profileIcon: ${_this.profileIcon}, profileIconTipo: ${_this.profileIconTipo})';
}


}

/// @nodoc
abstract mixin class $LogUsuarioRefCopyWith<$Res>  {
  factory $LogUsuarioRefCopyWith(LogUsuarioRef value, $Res Function(LogUsuarioRef) _then) = _$LogUsuarioRefCopyWithImpl;
@useResult
$Res call({
 int id, String username,@JsonKey(name: 'profile_icon') String? profileIcon,@JsonKey(name: 'profile_icon_tipo') String? profileIconTipo
});




}
/// @nodoc
class _$LogUsuarioRefCopyWithImpl<$Res>
    implements $LogUsuarioRefCopyWith<$Res> {
  _$LogUsuarioRefCopyWithImpl(this._self, this._then);

  final LogUsuarioRef _self;
  final $Res Function(LogUsuarioRef) _then;

/// Create a copy of LogUsuarioRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? profileIcon = freezed,Object? profileIconTipo = freezed,}) {
  return _then(LogUsuarioRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileIcon: freezed == profileIcon ? _self.profileIcon : profileIcon // ignore: cast_nullable_to_non_nullable
as String?,profileIconTipo: freezed == profileIconTipo ? _self.profileIconTipo : profileIconTipo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LogUsuarioRef].
extension LogUsuarioRefPatterns on LogUsuarioRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogUsuarioRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogUsuarioRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogUsuarioRef value)  $default,){
final _that = this;
switch (_that) {
case _LogUsuarioRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogUsuarioRef value)?  $default,){
final _that = this;
switch (_that) {
case _LogUsuarioRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'profile_icon')  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogUsuarioRef() when $default != null:
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'profile_icon')  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo)  $default,) {final _that = this;
switch (_that) {
case _LogUsuarioRef():
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username, @JsonKey(name: 'profile_icon')  String? profileIcon, @JsonKey(name: 'profile_icon_tipo')  String? profileIconTipo)?  $default,) {final _that = this;
switch (_that) {
case _LogUsuarioRef() when $default != null:
return $default(_that.id,_that.username,_that.profileIcon,_that.profileIconTipo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogUsuarioRef implements LogUsuarioRef {
  const _LogUsuarioRef({this.id = 0, this.username = '', @JsonKey(name: 'profile_icon') this.profileIcon, @JsonKey(name: 'profile_icon_tipo') this.profileIconTipo});
  factory _LogUsuarioRef.fromJson(Map<String, dynamic> json) => _$LogUsuarioRefFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String username;
@override@JsonKey(name: 'profile_icon') final  String? profileIcon;
@override@JsonKey(name: 'profile_icon_tipo') final  String? profileIconTipo;

/// Create a copy of LogUsuarioRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogUsuarioRefCopyWith<_LogUsuarioRef> get copyWith => __$LogUsuarioRefCopyWithImpl<_LogUsuarioRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogUsuarioRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogUsuarioRef&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.profileIcon, profileIcon) || other.profileIcon == profileIcon)&&(identical(other.profileIconTipo, profileIconTipo) || other.profileIconTipo == profileIconTipo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,profileIcon,profileIconTipo);
}

@override
String toString() {
    return 'LogUsuarioRef(id: $id, username: $username, profileIcon: $profileIcon, profileIconTipo: $profileIconTipo)';
}


}

/// @nodoc
abstract mixin class _$LogUsuarioRefCopyWith<$Res> implements $LogUsuarioRefCopyWith<$Res> {
  factory _$LogUsuarioRefCopyWith(_LogUsuarioRef value, $Res Function(_LogUsuarioRef) _then) = __$LogUsuarioRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String username,@JsonKey(name: 'profile_icon') String? profileIcon,@JsonKey(name: 'profile_icon_tipo') String? profileIconTipo
});




}
/// @nodoc
class __$LogUsuarioRefCopyWithImpl<$Res>
    implements _$LogUsuarioRefCopyWith<$Res> {
  __$LogUsuarioRefCopyWithImpl(this._self, this._then);

  final _LogUsuarioRef _self;
  final $Res Function(_LogUsuarioRef) _then;

/// Create a copy of LogUsuarioRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? profileIcon = freezed,Object? profileIconTipo = freezed,}) {
  return _then(_LogUsuarioRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileIcon: freezed == profileIcon ? _self.profileIcon : profileIcon // ignore: cast_nullable_to_non_nullable
as String?,profileIconTipo: freezed == profileIconTipo ? _self.profileIconTipo : profileIconTipo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LogGeneracion {

 String get id;@JsonKey(name: 'proyecto_id') String get proyectoId;@JsonKey(name: 'usuario_id') int get usuarioId;@JsonKey(name: 'rol_id') int get rolId;@JsonKey(name: 'rol_momento_code') String get rolMomentoCode;@JsonKey(name: 'tipo_artefacto_id') int? get tipoArtefactoId;@JsonKey(name: 'lenguaje_id') int? get lenguajeId;@JsonKey(name: 'framework_id') int? get frameworkId;@JsonKey(name: 'arquitectura_id') int? get arquitecturaId;@JsonKey(name: 'orm_id') int? get ormId;@JsonKey(name: 'base_datos_id') int? get baseDatosId;@JsonKey(name: 'tipo_reporte_id') int? get tipoReporteId;@JsonKey(name: 'tipo_xml_id') int? get tipoXmlId;@JsonKey(name: 'version_generador') String? get versionGenerador;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'tipo_artefacto') LogDimensionRef? get tipoArtefacto; LogDimensionRef? get lenguaje; LogDimensionRef? get framework; LogDimensionRef? get arquitectura; LogDimensionRef? get orm;@JsonKey(name: 'base_datos') LogDimensionRef? get baseDatos;@JsonKey(name: 'tipo_reporte') LogDimensionRef? get tipoReporte;@JsonKey(name: 'tipo_xml') LogDimensionRef? get tipoXml; LogProyectoRef? get proyecto; LogUsuarioRef? get usuario;
/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogGeneracionCopyWith<LogGeneracion> get copyWith => _$LogGeneracionCopyWithImpl<LogGeneracion>(this as LogGeneracion, _$identity);

  /// Serializes this LogGeneracion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogGeneracion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogGeneracion&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.proyectoId, _this.proyectoId) || other.proyectoId == _this.proyectoId)&&(identical(other.usuarioId, _this.usuarioId) || other.usuarioId == _this.usuarioId)&&(identical(other.rolId, _this.rolId) || other.rolId == _this.rolId)&&(identical(other.rolMomentoCode, _this.rolMomentoCode) || other.rolMomentoCode == _this.rolMomentoCode)&&(identical(other.tipoArtefactoId, _this.tipoArtefactoId) || other.tipoArtefactoId == _this.tipoArtefactoId)&&(identical(other.lenguajeId, _this.lenguajeId) || other.lenguajeId == _this.lenguajeId)&&(identical(other.frameworkId, _this.frameworkId) || other.frameworkId == _this.frameworkId)&&(identical(other.arquitecturaId, _this.arquitecturaId) || other.arquitecturaId == _this.arquitecturaId)&&(identical(other.ormId, _this.ormId) || other.ormId == _this.ormId)&&(identical(other.baseDatosId, _this.baseDatosId) || other.baseDatosId == _this.baseDatosId)&&(identical(other.tipoReporteId, _this.tipoReporteId) || other.tipoReporteId == _this.tipoReporteId)&&(identical(other.tipoXmlId, _this.tipoXmlId) || other.tipoXmlId == _this.tipoXmlId)&&(identical(other.versionGenerador, _this.versionGenerador) || other.versionGenerador == _this.versionGenerador)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.tipoArtefacto, _this.tipoArtefacto) || other.tipoArtefacto == _this.tipoArtefacto)&&(identical(other.lenguaje, _this.lenguaje) || other.lenguaje == _this.lenguaje)&&(identical(other.framework, _this.framework) || other.framework == _this.framework)&&(identical(other.arquitectura, _this.arquitectura) || other.arquitectura == _this.arquitectura)&&(identical(other.orm, _this.orm) || other.orm == _this.orm)&&(identical(other.baseDatos, _this.baseDatos) || other.baseDatos == _this.baseDatos)&&(identical(other.tipoReporte, _this.tipoReporte) || other.tipoReporte == _this.tipoReporte)&&(identical(other.tipoXml, _this.tipoXml) || other.tipoXml == _this.tipoXml)&&(identical(other.proyecto, _this.proyecto) || other.proyecto == _this.proyecto)&&(identical(other.usuario, _this.usuario) || other.usuario == _this.usuario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogGeneracion;
  return Object.hashAll([runtimeType,_this.id,_this.proyectoId,_this.usuarioId,_this.rolId,_this.rolMomentoCode,_this.tipoArtefactoId,_this.lenguajeId,_this.frameworkId,_this.arquitecturaId,_this.ormId,_this.baseDatosId,_this.tipoReporteId,_this.tipoXmlId,_this.versionGenerador,_this.createdAt,_this.updatedAt,_this.tipoArtefacto,_this.lenguaje,_this.framework,_this.arquitectura,_this.orm,_this.baseDatos,_this.tipoReporte,_this.tipoXml,_this.proyecto,_this.usuario]);
}

@override
String toString() {
  final _this = this as LogGeneracion;
  return 'LogGeneracion(id: ${_this.id}, proyectoId: ${_this.proyectoId}, usuarioId: ${_this.usuarioId}, rolId: ${_this.rolId}, rolMomentoCode: ${_this.rolMomentoCode}, tipoArtefactoId: ${_this.tipoArtefactoId}, lenguajeId: ${_this.lenguajeId}, frameworkId: ${_this.frameworkId}, arquitecturaId: ${_this.arquitecturaId}, ormId: ${_this.ormId}, baseDatosId: ${_this.baseDatosId}, tipoReporteId: ${_this.tipoReporteId}, tipoXmlId: ${_this.tipoXmlId}, versionGenerador: ${_this.versionGenerador}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, tipoArtefacto: ${_this.tipoArtefacto}, lenguaje: ${_this.lenguaje}, framework: ${_this.framework}, arquitectura: ${_this.arquitectura}, orm: ${_this.orm}, baseDatos: ${_this.baseDatos}, tipoReporte: ${_this.tipoReporte}, tipoXml: ${_this.tipoXml}, proyecto: ${_this.proyecto}, usuario: ${_this.usuario})';
}


}

/// @nodoc
abstract mixin class $LogGeneracionCopyWith<$Res>  {
  factory $LogGeneracionCopyWith(LogGeneracion value, $Res Function(LogGeneracion) _then) = _$LogGeneracionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'proyecto_id') String proyectoId,@JsonKey(name: 'usuario_id') int usuarioId,@JsonKey(name: 'rol_id') int rolId,@JsonKey(name: 'rol_momento_code') String rolMomentoCode,@JsonKey(name: 'tipo_artefacto_id') int? tipoArtefactoId,@JsonKey(name: 'lenguaje_id') int? lenguajeId,@JsonKey(name: 'framework_id') int? frameworkId,@JsonKey(name: 'arquitectura_id') int? arquitecturaId,@JsonKey(name: 'orm_id') int? ormId,@JsonKey(name: 'base_datos_id') int? baseDatosId,@JsonKey(name: 'tipo_reporte_id') int? tipoReporteId,@JsonKey(name: 'tipo_xml_id') int? tipoXmlId,@JsonKey(name: 'version_generador') String? versionGenerador,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'tipo_artefacto') LogDimensionRef? tipoArtefacto, LogDimensionRef? lenguaje, LogDimensionRef? framework, LogDimensionRef? arquitectura, LogDimensionRef? orm,@JsonKey(name: 'base_datos') LogDimensionRef? baseDatos,@JsonKey(name: 'tipo_reporte') LogDimensionRef? tipoReporte,@JsonKey(name: 'tipo_xml') LogDimensionRef? tipoXml, LogProyectoRef? proyecto, LogUsuarioRef? usuario
});


$LogDimensionRefCopyWith<$Res>? get tipoArtefacto;$LogDimensionRefCopyWith<$Res>? get lenguaje;$LogDimensionRefCopyWith<$Res>? get framework;$LogDimensionRefCopyWith<$Res>? get arquitectura;$LogDimensionRefCopyWith<$Res>? get orm;$LogDimensionRefCopyWith<$Res>? get baseDatos;$LogDimensionRefCopyWith<$Res>? get tipoReporte;$LogDimensionRefCopyWith<$Res>? get tipoXml;$LogProyectoRefCopyWith<$Res>? get proyecto;$LogUsuarioRefCopyWith<$Res>? get usuario;

}
/// @nodoc
class _$LogGeneracionCopyWithImpl<$Res>
    implements $LogGeneracionCopyWith<$Res> {
  _$LogGeneracionCopyWithImpl(this._self, this._then);

  final LogGeneracion _self;
  final $Res Function(LogGeneracion) _then;

/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? proyectoId = null,Object? usuarioId = null,Object? rolId = null,Object? rolMomentoCode = null,Object? tipoArtefactoId = freezed,Object? lenguajeId = freezed,Object? frameworkId = freezed,Object? arquitecturaId = freezed,Object? ormId = freezed,Object? baseDatosId = freezed,Object? tipoReporteId = freezed,Object? tipoXmlId = freezed,Object? versionGenerador = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? tipoArtefacto = freezed,Object? lenguaje = freezed,Object? framework = freezed,Object? arquitectura = freezed,Object? orm = freezed,Object? baseDatos = freezed,Object? tipoReporte = freezed,Object? tipoXml = freezed,Object? proyecto = freezed,Object? usuario = freezed,}) {
  return _then(LogGeneracion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,proyectoId: null == proyectoId ? _self.proyectoId : proyectoId // ignore: cast_nullable_to_non_nullable
as String,usuarioId: null == usuarioId ? _self.usuarioId : usuarioId // ignore: cast_nullable_to_non_nullable
as int,rolId: null == rolId ? _self.rolId : rolId // ignore: cast_nullable_to_non_nullable
as int,rolMomentoCode: null == rolMomentoCode ? _self.rolMomentoCode : rolMomentoCode // ignore: cast_nullable_to_non_nullable
as String,tipoArtefactoId: freezed == tipoArtefactoId ? _self.tipoArtefactoId : tipoArtefactoId // ignore: cast_nullable_to_non_nullable
as int?,lenguajeId: freezed == lenguajeId ? _self.lenguajeId : lenguajeId // ignore: cast_nullable_to_non_nullable
as int?,frameworkId: freezed == frameworkId ? _self.frameworkId : frameworkId // ignore: cast_nullable_to_non_nullable
as int?,arquitecturaId: freezed == arquitecturaId ? _self.arquitecturaId : arquitecturaId // ignore: cast_nullable_to_non_nullable
as int?,ormId: freezed == ormId ? _self.ormId : ormId // ignore: cast_nullable_to_non_nullable
as int?,baseDatosId: freezed == baseDatosId ? _self.baseDatosId : baseDatosId // ignore: cast_nullable_to_non_nullable
as int?,tipoReporteId: freezed == tipoReporteId ? _self.tipoReporteId : tipoReporteId // ignore: cast_nullable_to_non_nullable
as int?,tipoXmlId: freezed == tipoXmlId ? _self.tipoXmlId : tipoXmlId // ignore: cast_nullable_to_non_nullable
as int?,versionGenerador: freezed == versionGenerador ? _self.versionGenerador : versionGenerador // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tipoArtefacto: freezed == tipoArtefacto ? _self.tipoArtefacto : tipoArtefacto // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,lenguaje: freezed == lenguaje ? _self.lenguaje : lenguaje // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,framework: freezed == framework ? _self.framework : framework // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,arquitectura: freezed == arquitectura ? _self.arquitectura : arquitectura // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,orm: freezed == orm ? _self.orm : orm // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,baseDatos: freezed == baseDatos ? _self.baseDatos : baseDatos // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,tipoReporte: freezed == tipoReporte ? _self.tipoReporte : tipoReporte // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,tipoXml: freezed == tipoXml ? _self.tipoXml : tipoXml // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,proyecto: freezed == proyecto ? _self.proyecto : proyecto // ignore: cast_nullable_to_non_nullable
as LogProyectoRef?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as LogUsuarioRef?,
  ));
}
/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoArtefacto {
    if (_self.tipoArtefacto == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoArtefacto!, (value) {
    return _then(_self.copyWith(tipoArtefacto: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get lenguaje {
    if (_self.lenguaje == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.lenguaje!, (value) {
    return _then(_self.copyWith(lenguaje: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get framework {
    if (_self.framework == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.framework!, (value) {
    return _then(_self.copyWith(framework: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get arquitectura {
    if (_self.arquitectura == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.arquitectura!, (value) {
    return _then(_self.copyWith(arquitectura: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get orm {
    if (_self.orm == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.orm!, (value) {
    return _then(_self.copyWith(orm: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get baseDatos {
    if (_self.baseDatos == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.baseDatos!, (value) {
    return _then(_self.copyWith(baseDatos: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoReporte {
    if (_self.tipoReporte == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoReporte!, (value) {
    return _then(_self.copyWith(tipoReporte: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoXml {
    if (_self.tipoXml == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoXml!, (value) {
    return _then(_self.copyWith(tipoXml: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogProyectoRefCopyWith<$Res>? get proyecto {
    if (_self.proyecto == null) {
    return null;
  }

  return $LogProyectoRefCopyWith<$Res>(_self.proyecto!, (value) {
    return _then(_self.copyWith(proyecto: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogUsuarioRefCopyWith<$Res>? get usuario {
    if (_self.usuario == null) {
    return null;
  }

  return $LogUsuarioRefCopyWith<$Res>(_self.usuario!, (value) {
    return _then(_self.copyWith(usuario: value));
  });
}
}


/// Adds pattern-matching-related methods to [LogGeneracion].
extension LogGeneracionPatterns on LogGeneracion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogGeneracion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogGeneracion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogGeneracion value)  $default,){
final _that = this;
switch (_that) {
case _LogGeneracion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogGeneracion value)?  $default,){
final _that = this;
switch (_that) {
case _LogGeneracion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'proyecto_id')  String proyectoId, @JsonKey(name: 'usuario_id')  int usuarioId, @JsonKey(name: 'rol_id')  int rolId, @JsonKey(name: 'rol_momento_code')  String rolMomentoCode, @JsonKey(name: 'tipo_artefacto_id')  int? tipoArtefactoId, @JsonKey(name: 'lenguaje_id')  int? lenguajeId, @JsonKey(name: 'framework_id')  int? frameworkId, @JsonKey(name: 'arquitectura_id')  int? arquitecturaId, @JsonKey(name: 'orm_id')  int? ormId, @JsonKey(name: 'base_datos_id')  int? baseDatosId, @JsonKey(name: 'tipo_reporte_id')  int? tipoReporteId, @JsonKey(name: 'tipo_xml_id')  int? tipoXmlId, @JsonKey(name: 'version_generador')  String? versionGenerador, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'tipo_artefacto')  LogDimensionRef? tipoArtefacto,  LogDimensionRef? lenguaje,  LogDimensionRef? framework,  LogDimensionRef? arquitectura,  LogDimensionRef? orm, @JsonKey(name: 'base_datos')  LogDimensionRef? baseDatos, @JsonKey(name: 'tipo_reporte')  LogDimensionRef? tipoReporte, @JsonKey(name: 'tipo_xml')  LogDimensionRef? tipoXml,  LogProyectoRef? proyecto,  LogUsuarioRef? usuario)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogGeneracion() when $default != null:
return $default(_that.id,_that.proyectoId,_that.usuarioId,_that.rolId,_that.rolMomentoCode,_that.tipoArtefactoId,_that.lenguajeId,_that.frameworkId,_that.arquitecturaId,_that.ormId,_that.baseDatosId,_that.tipoReporteId,_that.tipoXmlId,_that.versionGenerador,_that.createdAt,_that.updatedAt,_that.tipoArtefacto,_that.lenguaje,_that.framework,_that.arquitectura,_that.orm,_that.baseDatos,_that.tipoReporte,_that.tipoXml,_that.proyecto,_that.usuario);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'proyecto_id')  String proyectoId, @JsonKey(name: 'usuario_id')  int usuarioId, @JsonKey(name: 'rol_id')  int rolId, @JsonKey(name: 'rol_momento_code')  String rolMomentoCode, @JsonKey(name: 'tipo_artefacto_id')  int? tipoArtefactoId, @JsonKey(name: 'lenguaje_id')  int? lenguajeId, @JsonKey(name: 'framework_id')  int? frameworkId, @JsonKey(name: 'arquitectura_id')  int? arquitecturaId, @JsonKey(name: 'orm_id')  int? ormId, @JsonKey(name: 'base_datos_id')  int? baseDatosId, @JsonKey(name: 'tipo_reporte_id')  int? tipoReporteId, @JsonKey(name: 'tipo_xml_id')  int? tipoXmlId, @JsonKey(name: 'version_generador')  String? versionGenerador, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'tipo_artefacto')  LogDimensionRef? tipoArtefacto,  LogDimensionRef? lenguaje,  LogDimensionRef? framework,  LogDimensionRef? arquitectura,  LogDimensionRef? orm, @JsonKey(name: 'base_datos')  LogDimensionRef? baseDatos, @JsonKey(name: 'tipo_reporte')  LogDimensionRef? tipoReporte, @JsonKey(name: 'tipo_xml')  LogDimensionRef? tipoXml,  LogProyectoRef? proyecto,  LogUsuarioRef? usuario)  $default,) {final _that = this;
switch (_that) {
case _LogGeneracion():
return $default(_that.id,_that.proyectoId,_that.usuarioId,_that.rolId,_that.rolMomentoCode,_that.tipoArtefactoId,_that.lenguajeId,_that.frameworkId,_that.arquitecturaId,_that.ormId,_that.baseDatosId,_that.tipoReporteId,_that.tipoXmlId,_that.versionGenerador,_that.createdAt,_that.updatedAt,_that.tipoArtefacto,_that.lenguaje,_that.framework,_that.arquitectura,_that.orm,_that.baseDatos,_that.tipoReporte,_that.tipoXml,_that.proyecto,_that.usuario);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'proyecto_id')  String proyectoId, @JsonKey(name: 'usuario_id')  int usuarioId, @JsonKey(name: 'rol_id')  int rolId, @JsonKey(name: 'rol_momento_code')  String rolMomentoCode, @JsonKey(name: 'tipo_artefacto_id')  int? tipoArtefactoId, @JsonKey(name: 'lenguaje_id')  int? lenguajeId, @JsonKey(name: 'framework_id')  int? frameworkId, @JsonKey(name: 'arquitectura_id')  int? arquitecturaId, @JsonKey(name: 'orm_id')  int? ormId, @JsonKey(name: 'base_datos_id')  int? baseDatosId, @JsonKey(name: 'tipo_reporte_id')  int? tipoReporteId, @JsonKey(name: 'tipo_xml_id')  int? tipoXmlId, @JsonKey(name: 'version_generador')  String? versionGenerador, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'tipo_artefacto')  LogDimensionRef? tipoArtefacto,  LogDimensionRef? lenguaje,  LogDimensionRef? framework,  LogDimensionRef? arquitectura,  LogDimensionRef? orm, @JsonKey(name: 'base_datos')  LogDimensionRef? baseDatos, @JsonKey(name: 'tipo_reporte')  LogDimensionRef? tipoReporte, @JsonKey(name: 'tipo_xml')  LogDimensionRef? tipoXml,  LogProyectoRef? proyecto,  LogUsuarioRef? usuario)?  $default,) {final _that = this;
switch (_that) {
case _LogGeneracion() when $default != null:
return $default(_that.id,_that.proyectoId,_that.usuarioId,_that.rolId,_that.rolMomentoCode,_that.tipoArtefactoId,_that.lenguajeId,_that.frameworkId,_that.arquitecturaId,_that.ormId,_that.baseDatosId,_that.tipoReporteId,_that.tipoXmlId,_that.versionGenerador,_that.createdAt,_that.updatedAt,_that.tipoArtefacto,_that.lenguaje,_that.framework,_that.arquitectura,_that.orm,_that.baseDatos,_that.tipoReporte,_that.tipoXml,_that.proyecto,_that.usuario);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogGeneracion implements LogGeneracion {
  const _LogGeneracion({this.id = '', @JsonKey(name: 'proyecto_id') this.proyectoId = '', @JsonKey(name: 'usuario_id') this.usuarioId = 0, @JsonKey(name: 'rol_id') this.rolId = 0, @JsonKey(name: 'rol_momento_code') this.rolMomentoCode = '', @JsonKey(name: 'tipo_artefacto_id') this.tipoArtefactoId, @JsonKey(name: 'lenguaje_id') this.lenguajeId, @JsonKey(name: 'framework_id') this.frameworkId, @JsonKey(name: 'arquitectura_id') this.arquitecturaId, @JsonKey(name: 'orm_id') this.ormId, @JsonKey(name: 'base_datos_id') this.baseDatosId, @JsonKey(name: 'tipo_reporte_id') this.tipoReporteId, @JsonKey(name: 'tipo_xml_id') this.tipoXmlId, @JsonKey(name: 'version_generador') this.versionGenerador, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'tipo_artefacto') this.tipoArtefacto, this.lenguaje, this.framework, this.arquitectura, this.orm, @JsonKey(name: 'base_datos') this.baseDatos, @JsonKey(name: 'tipo_reporte') this.tipoReporte, @JsonKey(name: 'tipo_xml') this.tipoXml, this.proyecto, this.usuario});
  factory _LogGeneracion.fromJson(Map<String, dynamic> json) => _$LogGeneracionFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'proyecto_id') final  String proyectoId;
@override@JsonKey(name: 'usuario_id') final  int usuarioId;
@override@JsonKey(name: 'rol_id') final  int rolId;
@override@JsonKey(name: 'rol_momento_code') final  String rolMomentoCode;
@override@JsonKey(name: 'tipo_artefacto_id') final  int? tipoArtefactoId;
@override@JsonKey(name: 'lenguaje_id') final  int? lenguajeId;
@override@JsonKey(name: 'framework_id') final  int? frameworkId;
@override@JsonKey(name: 'arquitectura_id') final  int? arquitecturaId;
@override@JsonKey(name: 'orm_id') final  int? ormId;
@override@JsonKey(name: 'base_datos_id') final  int? baseDatosId;
@override@JsonKey(name: 'tipo_reporte_id') final  int? tipoReporteId;
@override@JsonKey(name: 'tipo_xml_id') final  int? tipoXmlId;
@override@JsonKey(name: 'version_generador') final  String? versionGenerador;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'tipo_artefacto') final  LogDimensionRef? tipoArtefacto;
@override final  LogDimensionRef? lenguaje;
@override final  LogDimensionRef? framework;
@override final  LogDimensionRef? arquitectura;
@override final  LogDimensionRef? orm;
@override@JsonKey(name: 'base_datos') final  LogDimensionRef? baseDatos;
@override@JsonKey(name: 'tipo_reporte') final  LogDimensionRef? tipoReporte;
@override@JsonKey(name: 'tipo_xml') final  LogDimensionRef? tipoXml;
@override final  LogProyectoRef? proyecto;
@override final  LogUsuarioRef? usuario;

/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogGeneracionCopyWith<_LogGeneracion> get copyWith => __$LogGeneracionCopyWithImpl<_LogGeneracion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogGeneracionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogGeneracion&&(identical(other.id, id) || other.id == id)&&(identical(other.proyectoId, proyectoId) || other.proyectoId == proyectoId)&&(identical(other.usuarioId, usuarioId) || other.usuarioId == usuarioId)&&(identical(other.rolId, rolId) || other.rolId == rolId)&&(identical(other.rolMomentoCode, rolMomentoCode) || other.rolMomentoCode == rolMomentoCode)&&(identical(other.tipoArtefactoId, tipoArtefactoId) || other.tipoArtefactoId == tipoArtefactoId)&&(identical(other.lenguajeId, lenguajeId) || other.lenguajeId == lenguajeId)&&(identical(other.frameworkId, frameworkId) || other.frameworkId == frameworkId)&&(identical(other.arquitecturaId, arquitecturaId) || other.arquitecturaId == arquitecturaId)&&(identical(other.ormId, ormId) || other.ormId == ormId)&&(identical(other.baseDatosId, baseDatosId) || other.baseDatosId == baseDatosId)&&(identical(other.tipoReporteId, tipoReporteId) || other.tipoReporteId == tipoReporteId)&&(identical(other.tipoXmlId, tipoXmlId) || other.tipoXmlId == tipoXmlId)&&(identical(other.versionGenerador, versionGenerador) || other.versionGenerador == versionGenerador)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.tipoArtefacto, tipoArtefacto) || other.tipoArtefacto == tipoArtefacto)&&(identical(other.lenguaje, lenguaje) || other.lenguaje == lenguaje)&&(identical(other.framework, framework) || other.framework == framework)&&(identical(other.arquitectura, arquitectura) || other.arquitectura == arquitectura)&&(identical(other.orm, orm) || other.orm == orm)&&(identical(other.baseDatos, baseDatos) || other.baseDatos == baseDatos)&&(identical(other.tipoReporte, tipoReporte) || other.tipoReporte == tipoReporte)&&(identical(other.tipoXml, tipoXml) || other.tipoXml == tipoXml)&&(identical(other.proyecto, proyecto) || other.proyecto == proyecto)&&(identical(other.usuario, usuario) || other.usuario == usuario));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,proyectoId,usuarioId,rolId,rolMomentoCode,tipoArtefactoId,lenguajeId,frameworkId,arquitecturaId,ormId,baseDatosId,tipoReporteId,tipoXmlId,versionGenerador,createdAt,updatedAt,tipoArtefacto,lenguaje,framework,arquitectura,orm,baseDatos,tipoReporte,tipoXml,proyecto,usuario]);
}

@override
String toString() {
    return 'LogGeneracion(id: $id, proyectoId: $proyectoId, usuarioId: $usuarioId, rolId: $rolId, rolMomentoCode: $rolMomentoCode, tipoArtefactoId: $tipoArtefactoId, lenguajeId: $lenguajeId, frameworkId: $frameworkId, arquitecturaId: $arquitecturaId, ormId: $ormId, baseDatosId: $baseDatosId, tipoReporteId: $tipoReporteId, tipoXmlId: $tipoXmlId, versionGenerador: $versionGenerador, createdAt: $createdAt, updatedAt: $updatedAt, tipoArtefacto: $tipoArtefacto, lenguaje: $lenguaje, framework: $framework, arquitectura: $arquitectura, orm: $orm, baseDatos: $baseDatos, tipoReporte: $tipoReporte, tipoXml: $tipoXml, proyecto: $proyecto, usuario: $usuario)';
}


}

/// @nodoc
abstract mixin class _$LogGeneracionCopyWith<$Res> implements $LogGeneracionCopyWith<$Res> {
  factory _$LogGeneracionCopyWith(_LogGeneracion value, $Res Function(_LogGeneracion) _then) = __$LogGeneracionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'proyecto_id') String proyectoId,@JsonKey(name: 'usuario_id') int usuarioId,@JsonKey(name: 'rol_id') int rolId,@JsonKey(name: 'rol_momento_code') String rolMomentoCode,@JsonKey(name: 'tipo_artefacto_id') int? tipoArtefactoId,@JsonKey(name: 'lenguaje_id') int? lenguajeId,@JsonKey(name: 'framework_id') int? frameworkId,@JsonKey(name: 'arquitectura_id') int? arquitecturaId,@JsonKey(name: 'orm_id') int? ormId,@JsonKey(name: 'base_datos_id') int? baseDatosId,@JsonKey(name: 'tipo_reporte_id') int? tipoReporteId,@JsonKey(name: 'tipo_xml_id') int? tipoXmlId,@JsonKey(name: 'version_generador') String? versionGenerador,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'tipo_artefacto') LogDimensionRef? tipoArtefacto, LogDimensionRef? lenguaje, LogDimensionRef? framework, LogDimensionRef? arquitectura, LogDimensionRef? orm,@JsonKey(name: 'base_datos') LogDimensionRef? baseDatos,@JsonKey(name: 'tipo_reporte') LogDimensionRef? tipoReporte,@JsonKey(name: 'tipo_xml') LogDimensionRef? tipoXml, LogProyectoRef? proyecto, LogUsuarioRef? usuario
});


@override $LogDimensionRefCopyWith<$Res>? get tipoArtefacto;@override $LogDimensionRefCopyWith<$Res>? get lenguaje;@override $LogDimensionRefCopyWith<$Res>? get framework;@override $LogDimensionRefCopyWith<$Res>? get arquitectura;@override $LogDimensionRefCopyWith<$Res>? get orm;@override $LogDimensionRefCopyWith<$Res>? get baseDatos;@override $LogDimensionRefCopyWith<$Res>? get tipoReporte;@override $LogDimensionRefCopyWith<$Res>? get tipoXml;@override $LogProyectoRefCopyWith<$Res>? get proyecto;@override $LogUsuarioRefCopyWith<$Res>? get usuario;

}
/// @nodoc
class __$LogGeneracionCopyWithImpl<$Res>
    implements _$LogGeneracionCopyWith<$Res> {
  __$LogGeneracionCopyWithImpl(this._self, this._then);

  final _LogGeneracion _self;
  final $Res Function(_LogGeneracion) _then;

/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? proyectoId = null,Object? usuarioId = null,Object? rolId = null,Object? rolMomentoCode = null,Object? tipoArtefactoId = freezed,Object? lenguajeId = freezed,Object? frameworkId = freezed,Object? arquitecturaId = freezed,Object? ormId = freezed,Object? baseDatosId = freezed,Object? tipoReporteId = freezed,Object? tipoXmlId = freezed,Object? versionGenerador = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? tipoArtefacto = freezed,Object? lenguaje = freezed,Object? framework = freezed,Object? arquitectura = freezed,Object? orm = freezed,Object? baseDatos = freezed,Object? tipoReporte = freezed,Object? tipoXml = freezed,Object? proyecto = freezed,Object? usuario = freezed,}) {
  return _then(_LogGeneracion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,proyectoId: null == proyectoId ? _self.proyectoId : proyectoId // ignore: cast_nullable_to_non_nullable
as String,usuarioId: null == usuarioId ? _self.usuarioId : usuarioId // ignore: cast_nullable_to_non_nullable
as int,rolId: null == rolId ? _self.rolId : rolId // ignore: cast_nullable_to_non_nullable
as int,rolMomentoCode: null == rolMomentoCode ? _self.rolMomentoCode : rolMomentoCode // ignore: cast_nullable_to_non_nullable
as String,tipoArtefactoId: freezed == tipoArtefactoId ? _self.tipoArtefactoId : tipoArtefactoId // ignore: cast_nullable_to_non_nullable
as int?,lenguajeId: freezed == lenguajeId ? _self.lenguajeId : lenguajeId // ignore: cast_nullable_to_non_nullable
as int?,frameworkId: freezed == frameworkId ? _self.frameworkId : frameworkId // ignore: cast_nullable_to_non_nullable
as int?,arquitecturaId: freezed == arquitecturaId ? _self.arquitecturaId : arquitecturaId // ignore: cast_nullable_to_non_nullable
as int?,ormId: freezed == ormId ? _self.ormId : ormId // ignore: cast_nullable_to_non_nullable
as int?,baseDatosId: freezed == baseDatosId ? _self.baseDatosId : baseDatosId // ignore: cast_nullable_to_non_nullable
as int?,tipoReporteId: freezed == tipoReporteId ? _self.tipoReporteId : tipoReporteId // ignore: cast_nullable_to_non_nullable
as int?,tipoXmlId: freezed == tipoXmlId ? _self.tipoXmlId : tipoXmlId // ignore: cast_nullable_to_non_nullable
as int?,versionGenerador: freezed == versionGenerador ? _self.versionGenerador : versionGenerador // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tipoArtefacto: freezed == tipoArtefacto ? _self.tipoArtefacto : tipoArtefacto // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,lenguaje: freezed == lenguaje ? _self.lenguaje : lenguaje // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,framework: freezed == framework ? _self.framework : framework // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,arquitectura: freezed == arquitectura ? _self.arquitectura : arquitectura // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,orm: freezed == orm ? _self.orm : orm // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,baseDatos: freezed == baseDatos ? _self.baseDatos : baseDatos // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,tipoReporte: freezed == tipoReporte ? _self.tipoReporte : tipoReporte // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,tipoXml: freezed == tipoXml ? _self.tipoXml : tipoXml // ignore: cast_nullable_to_non_nullable
as LogDimensionRef?,proyecto: freezed == proyecto ? _self.proyecto : proyecto // ignore: cast_nullable_to_non_nullable
as LogProyectoRef?,usuario: freezed == usuario ? _self.usuario : usuario // ignore: cast_nullable_to_non_nullable
as LogUsuarioRef?,
  ));
}

/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoArtefacto {
    if (_self.tipoArtefacto == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoArtefacto!, (value) {
    return _then(_self.copyWith(tipoArtefacto: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get lenguaje {
    if (_self.lenguaje == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.lenguaje!, (value) {
    return _then(_self.copyWith(lenguaje: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get framework {
    if (_self.framework == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.framework!, (value) {
    return _then(_self.copyWith(framework: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get arquitectura {
    if (_self.arquitectura == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.arquitectura!, (value) {
    return _then(_self.copyWith(arquitectura: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get orm {
    if (_self.orm == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.orm!, (value) {
    return _then(_self.copyWith(orm: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get baseDatos {
    if (_self.baseDatos == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.baseDatos!, (value) {
    return _then(_self.copyWith(baseDatos: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoReporte {
    if (_self.tipoReporte == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoReporte!, (value) {
    return _then(_self.copyWith(tipoReporte: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogDimensionRefCopyWith<$Res>? get tipoXml {
    if (_self.tipoXml == null) {
    return null;
  }

  return $LogDimensionRefCopyWith<$Res>(_self.tipoXml!, (value) {
    return _then(_self.copyWith(tipoXml: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogProyectoRefCopyWith<$Res>? get proyecto {
    if (_self.proyecto == null) {
    return null;
  }

  return $LogProyectoRefCopyWith<$Res>(_self.proyecto!, (value) {
    return _then(_self.copyWith(proyecto: value));
  });
}/// Create a copy of LogGeneracion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogUsuarioRefCopyWith<$Res>? get usuario {
    if (_self.usuario == null) {
    return null;
  }

  return $LogUsuarioRefCopyWith<$Res>(_self.usuario!, (value) {
    return _then(_self.copyWith(usuario: value));
  });
}
}


/// @nodoc
mixin _$LogFilterOptions {

@JsonKey(name: 'tipos_artefacto') List<LogDimensionRef> get tiposArtefacto; List<LogDimensionRef> get lenguajes; List<LogDimensionRef> get frameworks; List<LogDimensionRef> get arquitecturas; List<LogDimensionRef> get orms;@JsonKey(name: 'bases_datos') List<LogDimensionRef> get basesDatos;@JsonKey(name: 'tipos_reporte') List<LogDimensionRef> get tiposReporte;@JsonKey(name: 'tipos_xml') List<LogDimensionRef> get tiposXml;
/// Create a copy of LogFilterOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogFilterOptionsCopyWith<LogFilterOptions> get copyWith => _$LogFilterOptionsCopyWithImpl<LogFilterOptions>(this as LogFilterOptions, _$identity);

  /// Serializes this LogFilterOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogFilterOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogFilterOptions&&const DeepCollectionEquality().equals(other.tiposArtefacto, _this.tiposArtefacto)&&const DeepCollectionEquality().equals(other.lenguajes, _this.lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _this.frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _this.arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _this.orms)&&const DeepCollectionEquality().equals(other.basesDatos, _this.basesDatos)&&const DeepCollectionEquality().equals(other.tiposReporte, _this.tiposReporte)&&const DeepCollectionEquality().equals(other.tiposXml, _this.tiposXml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogFilterOptions;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.tiposArtefacto),const DeepCollectionEquality().hash(_this.lenguajes),const DeepCollectionEquality().hash(_this.frameworks),const DeepCollectionEquality().hash(_this.arquitecturas),const DeepCollectionEquality().hash(_this.orms),const DeepCollectionEquality().hash(_this.basesDatos),const DeepCollectionEquality().hash(_this.tiposReporte),const DeepCollectionEquality().hash(_this.tiposXml));
}

@override
String toString() {
  final _this = this as LogFilterOptions;
  return 'LogFilterOptions(tiposArtefacto: ${_this.tiposArtefacto}, lenguajes: ${_this.lenguajes}, frameworks: ${_this.frameworks}, arquitecturas: ${_this.arquitecturas}, orms: ${_this.orms}, basesDatos: ${_this.basesDatos}, tiposReporte: ${_this.tiposReporte}, tiposXml: ${_this.tiposXml})';
}


}

/// @nodoc
abstract mixin class $LogFilterOptionsCopyWith<$Res>  {
  factory $LogFilterOptionsCopyWith(LogFilterOptions value, $Res Function(LogFilterOptions) _then) = _$LogFilterOptionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tipos_artefacto') List<LogDimensionRef> tiposArtefacto, List<LogDimensionRef> lenguajes, List<LogDimensionRef> frameworks, List<LogDimensionRef> arquitecturas, List<LogDimensionRef> orms,@JsonKey(name: 'bases_datos') List<LogDimensionRef> basesDatos,@JsonKey(name: 'tipos_reporte') List<LogDimensionRef> tiposReporte,@JsonKey(name: 'tipos_xml') List<LogDimensionRef> tiposXml
});




}
/// @nodoc
class _$LogFilterOptionsCopyWithImpl<$Res>
    implements $LogFilterOptionsCopyWith<$Res> {
  _$LogFilterOptionsCopyWithImpl(this._self, this._then);

  final LogFilterOptions _self;
  final $Res Function(LogFilterOptions) _then;

/// Create a copy of LogFilterOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tiposArtefacto = null,Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposReporte = null,Object? tiposXml = null,}) {
  return _then(LogFilterOptions(
tiposArtefacto: null == tiposArtefacto ? _self.tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,lenguajes: null == lenguajes ? _self.lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,frameworks: null == frameworks ? _self.frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,arquitecturas: null == arquitecturas ? _self.arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,orms: null == orms ? _self.orms : orms // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,basesDatos: null == basesDatos ? _self.basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,tiposReporte: null == tiposReporte ? _self.tiposReporte : tiposReporte // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,tiposXml: null == tiposXml ? _self.tiposXml : tiposXml // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [LogFilterOptions].
extension LogFilterOptionsPatterns on LogFilterOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogFilterOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogFilterOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogFilterOptions value)  $default,){
final _that = this;
switch (_that) {
case _LogFilterOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogFilterOptions value)?  $default,){
final _that = this;
switch (_that) {
case _LogFilterOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tipos_artefacto')  List<LogDimensionRef> tiposArtefacto,  List<LogDimensionRef> lenguajes,  List<LogDimensionRef> frameworks,  List<LogDimensionRef> arquitecturas,  List<LogDimensionRef> orms, @JsonKey(name: 'bases_datos')  List<LogDimensionRef> basesDatos, @JsonKey(name: 'tipos_reporte')  List<LogDimensionRef> tiposReporte, @JsonKey(name: 'tipos_xml')  List<LogDimensionRef> tiposXml)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogFilterOptions() when $default != null:
return $default(_that.tiposArtefacto,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposReporte,_that.tiposXml);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tipos_artefacto')  List<LogDimensionRef> tiposArtefacto,  List<LogDimensionRef> lenguajes,  List<LogDimensionRef> frameworks,  List<LogDimensionRef> arquitecturas,  List<LogDimensionRef> orms, @JsonKey(name: 'bases_datos')  List<LogDimensionRef> basesDatos, @JsonKey(name: 'tipos_reporte')  List<LogDimensionRef> tiposReporte, @JsonKey(name: 'tipos_xml')  List<LogDimensionRef> tiposXml)  $default,) {final _that = this;
switch (_that) {
case _LogFilterOptions():
return $default(_that.tiposArtefacto,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposReporte,_that.tiposXml);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tipos_artefacto')  List<LogDimensionRef> tiposArtefacto,  List<LogDimensionRef> lenguajes,  List<LogDimensionRef> frameworks,  List<LogDimensionRef> arquitecturas,  List<LogDimensionRef> orms, @JsonKey(name: 'bases_datos')  List<LogDimensionRef> basesDatos, @JsonKey(name: 'tipos_reporte')  List<LogDimensionRef> tiposReporte, @JsonKey(name: 'tipos_xml')  List<LogDimensionRef> tiposXml)?  $default,) {final _that = this;
switch (_that) {
case _LogFilterOptions() when $default != null:
return $default(_that.tiposArtefacto,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposReporte,_that.tiposXml);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogFilterOptions implements LogFilterOptions {
  const _LogFilterOptions({@JsonKey(name: 'tipos_artefacto')  List<LogDimensionRef> tiposArtefacto = const [],  List<LogDimensionRef> lenguajes = const [],  List<LogDimensionRef> frameworks = const [],  List<LogDimensionRef> arquitecturas = const [],  List<LogDimensionRef> orms = const [], @JsonKey(name: 'bases_datos')  List<LogDimensionRef> basesDatos = const [], @JsonKey(name: 'tipos_reporte')  List<LogDimensionRef> tiposReporte = const [], @JsonKey(name: 'tipos_xml')  List<LogDimensionRef> tiposXml = const []}): _tiposArtefacto = tiposArtefacto,_lenguajes = lenguajes,_frameworks = frameworks,_arquitecturas = arquitecturas,_orms = orms,_basesDatos = basesDatos,_tiposReporte = tiposReporte,_tiposXml = tiposXml;
  factory _LogFilterOptions.fromJson(Map<String, dynamic> json) => _$LogFilterOptionsFromJson(json);

 final  List<LogDimensionRef> _tiposArtefacto;
@override@JsonKey(name: 'tipos_artefacto') List<LogDimensionRef> get tiposArtefacto {
  if (_tiposArtefacto is EqualUnmodifiableListView) return _tiposArtefacto;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposArtefacto);
}

 final  List<LogDimensionRef> _lenguajes;
@override@JsonKey() List<LogDimensionRef> get lenguajes {
  if (_lenguajes is EqualUnmodifiableListView) return _lenguajes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lenguajes);
}

 final  List<LogDimensionRef> _frameworks;
@override@JsonKey() List<LogDimensionRef> get frameworks {
  if (_frameworks is EqualUnmodifiableListView) return _frameworks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_frameworks);
}

 final  List<LogDimensionRef> _arquitecturas;
@override@JsonKey() List<LogDimensionRef> get arquitecturas {
  if (_arquitecturas is EqualUnmodifiableListView) return _arquitecturas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arquitecturas);
}

 final  List<LogDimensionRef> _orms;
@override@JsonKey() List<LogDimensionRef> get orms {
  if (_orms is EqualUnmodifiableListView) return _orms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orms);
}

 final  List<LogDimensionRef> _basesDatos;
@override@JsonKey(name: 'bases_datos') List<LogDimensionRef> get basesDatos {
  if (_basesDatos is EqualUnmodifiableListView) return _basesDatos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_basesDatos);
}

 final  List<LogDimensionRef> _tiposReporte;
@override@JsonKey(name: 'tipos_reporte') List<LogDimensionRef> get tiposReporte {
  if (_tiposReporte is EqualUnmodifiableListView) return _tiposReporte;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposReporte);
}

 final  List<LogDimensionRef> _tiposXml;
@override@JsonKey(name: 'tipos_xml') List<LogDimensionRef> get tiposXml {
  if (_tiposXml is EqualUnmodifiableListView) return _tiposXml;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposXml);
}


/// Create a copy of LogFilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogFilterOptionsCopyWith<_LogFilterOptions> get copyWith => __$LogFilterOptionsCopyWithImpl<_LogFilterOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogFilterOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogFilterOptions&&const DeepCollectionEquality().equals(other.tiposArtefacto, _tiposArtefacto)&&const DeepCollectionEquality().equals(other.lenguajes, _lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _orms)&&const DeepCollectionEquality().equals(other.basesDatos, _basesDatos)&&const DeepCollectionEquality().equals(other.tiposReporte, _tiposReporte)&&const DeepCollectionEquality().equals(other.tiposXml, _tiposXml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_tiposArtefacto),const DeepCollectionEquality().hash(_lenguajes),const DeepCollectionEquality().hash(_frameworks),const DeepCollectionEquality().hash(_arquitecturas),const DeepCollectionEquality().hash(_orms),const DeepCollectionEquality().hash(_basesDatos),const DeepCollectionEquality().hash(_tiposReporte),const DeepCollectionEquality().hash(_tiposXml));
}

@override
String toString() {
    return 'LogFilterOptions(tiposArtefacto: $tiposArtefacto, lenguajes: $lenguajes, frameworks: $frameworks, arquitecturas: $arquitecturas, orms: $orms, basesDatos: $basesDatos, tiposReporte: $tiposReporte, tiposXml: $tiposXml)';
}


}

/// @nodoc
abstract mixin class _$LogFilterOptionsCopyWith<$Res> implements $LogFilterOptionsCopyWith<$Res> {
  factory _$LogFilterOptionsCopyWith(_LogFilterOptions value, $Res Function(_LogFilterOptions) _then) = __$LogFilterOptionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tipos_artefacto') List<LogDimensionRef> tiposArtefacto, List<LogDimensionRef> lenguajes, List<LogDimensionRef> frameworks, List<LogDimensionRef> arquitecturas, List<LogDimensionRef> orms,@JsonKey(name: 'bases_datos') List<LogDimensionRef> basesDatos,@JsonKey(name: 'tipos_reporte') List<LogDimensionRef> tiposReporte,@JsonKey(name: 'tipos_xml') List<LogDimensionRef> tiposXml
});




}
/// @nodoc
class __$LogFilterOptionsCopyWithImpl<$Res>
    implements _$LogFilterOptionsCopyWith<$Res> {
  __$LogFilterOptionsCopyWithImpl(this._self, this._then);

  final _LogFilterOptions _self;
  final $Res Function(_LogFilterOptions) _then;

/// Create a copy of LogFilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tiposArtefacto = null,Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposReporte = null,Object? tiposXml = null,}) {
  return _then(_LogFilterOptions(
tiposArtefacto: null == tiposArtefacto ? _self._tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,lenguajes: null == lenguajes ? _self._lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,frameworks: null == frameworks ? _self._frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,arquitecturas: null == arquitecturas ? _self._arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,orms: null == orms ? _self._orms : orms // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,basesDatos: null == basesDatos ? _self._basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,tiposReporte: null == tiposReporte ? _self._tiposReporte : tiposReporte // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,tiposXml: null == tiposXml ? _self._tiposXml : tiposXml // ignore: cast_nullable_to_non_nullable
as List<LogDimensionRef>,
  ));
}


}


/// @nodoc
mixin _$PaginatedLogs {

 List<LogGeneracion> get items; PaginationMeta get meta;
/// Create a copy of PaginatedLogs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedLogsCopyWith<PaginatedLogs> get copyWith => _$PaginatedLogsCopyWithImpl<PaginatedLogs>(this as PaginatedLogs, _$identity);

  /// Serializes this PaginatedLogs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginatedLogs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLogs&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginatedLogs;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.meta);
}

@override
String toString() {
  final _this = this as PaginatedLogs;
  return 'PaginatedLogs(items: ${_this.items}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $PaginatedLogsCopyWith<$Res>  {
  factory $PaginatedLogsCopyWith(PaginatedLogs value, $Res Function(PaginatedLogs) _then) = _$PaginatedLogsCopyWithImpl;
@useResult
$Res call({
 List<LogGeneracion> items, PaginationMeta meta
});




}
/// @nodoc
class _$PaginatedLogsCopyWithImpl<$Res>
    implements $PaginatedLogsCopyWith<$Res> {
  _$PaginatedLogsCopyWithImpl(this._self, this._then);

  final PaginatedLogs _self;
  final $Res Function(PaginatedLogs) _then;

/// Create a copy of PaginatedLogs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(PaginatedLogs(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LogGeneracion>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedLogs].
extension PaginatedLogsPatterns on PaginatedLogs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedLogs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedLogs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedLogs value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedLogs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedLogs value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedLogs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LogGeneracion> items,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedLogs() when $default != null:
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LogGeneracion> items,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _PaginatedLogs():
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LogGeneracion> items,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedLogs() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedLogs implements PaginatedLogs {
  const _PaginatedLogs({ List<LogGeneracion> items = const [], required this.meta}): _items = items;
  factory _PaginatedLogs.fromJson(Map<String, dynamic> json) => _$PaginatedLogsFromJson(json);

 final  List<LogGeneracion> _items;
@override@JsonKey() List<LogGeneracion> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  PaginationMeta meta;

/// Create a copy of PaginatedLogs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedLogsCopyWith<_PaginatedLogs> get copyWith => __$PaginatedLogsCopyWithImpl<_PaginatedLogs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedLogsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedLogs&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);
}

@override
String toString() {
    return 'PaginatedLogs(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginatedLogsCopyWith<$Res> implements $PaginatedLogsCopyWith<$Res> {
  factory _$PaginatedLogsCopyWith(_PaginatedLogs value, $Res Function(_PaginatedLogs) _then) = __$PaginatedLogsCopyWithImpl;
@override @useResult
$Res call({
 List<LogGeneracion> items, PaginationMeta meta
});




}
/// @nodoc
class __$PaginatedLogsCopyWithImpl<$Res>
    implements _$PaginatedLogsCopyWith<$Res> {
  __$PaginatedLogsCopyWithImpl(this._self, this._then);

  final _PaginatedLogs _self;
  final $Res Function(_PaginatedLogs) _then;

/// Create a copy of PaginatedLogs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_PaginatedLogs(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LogGeneracion>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}


}

// dart format on
