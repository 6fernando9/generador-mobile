// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_tecnologias.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardTecnologias {

 int get total; List<TechItem> get lenguajes; List<TechItem> get frameworks; List<TechItem> get arquitecturas; List<TechItem> get orms; List<TechItem> get basesDatos; List<TechItem> get tiposArtefacto;
/// Create a copy of DashboardTecnologias
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTecnologiasCopyWith<DashboardTecnologias> get copyWith => _$DashboardTecnologiasCopyWithImpl<DashboardTecnologias>(this as DashboardTecnologias, _$identity);

  /// Serializes this DashboardTecnologias to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardTecnologias;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTecnologias&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.lenguajes, _this.lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _this.frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _this.arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _this.orms)&&const DeepCollectionEquality().equals(other.basesDatos, _this.basesDatos)&&const DeepCollectionEquality().equals(other.tiposArtefacto, _this.tiposArtefacto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardTecnologias;
  return Object.hash(runtimeType,_this.total,const DeepCollectionEquality().hash(_this.lenguajes),const DeepCollectionEquality().hash(_this.frameworks),const DeepCollectionEquality().hash(_this.arquitecturas),const DeepCollectionEquality().hash(_this.orms),const DeepCollectionEquality().hash(_this.basesDatos),const DeepCollectionEquality().hash(_this.tiposArtefacto));
}

@override
String toString() {
  final _this = this as DashboardTecnologias;
  return 'DashboardTecnologias(total: ${_this.total}, lenguajes: ${_this.lenguajes}, frameworks: ${_this.frameworks}, arquitecturas: ${_this.arquitecturas}, orms: ${_this.orms}, basesDatos: ${_this.basesDatos}, tiposArtefacto: ${_this.tiposArtefacto})';
}


}

/// @nodoc
abstract mixin class $DashboardTecnologiasCopyWith<$Res>  {
  factory $DashboardTecnologiasCopyWith(DashboardTecnologias value, $Res Function(DashboardTecnologias) _then) = _$DashboardTecnologiasCopyWithImpl;
@useResult
$Res call({
 int total, List<TechItem> lenguajes, List<TechItem> frameworks, List<TechItem> arquitecturas, List<TechItem> orms, List<TechItem> basesDatos, List<TechItem> tiposArtefacto
});




}
/// @nodoc
class _$DashboardTecnologiasCopyWithImpl<$Res>
    implements $DashboardTecnologiasCopyWith<$Res> {
  _$DashboardTecnologiasCopyWithImpl(this._self, this._then);

  final DashboardTecnologias _self;
  final $Res Function(DashboardTecnologias) _then;

/// Create a copy of DashboardTecnologias
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposArtefacto = null,}) {
  return _then(DashboardTecnologias(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lenguajes: null == lenguajes ? _self.lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<TechItem>,frameworks: null == frameworks ? _self.frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<TechItem>,arquitecturas: null == arquitecturas ? _self.arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<TechItem>,orms: null == orms ? _self.orms : orms // ignore: cast_nullable_to_non_nullable
as List<TechItem>,basesDatos: null == basesDatos ? _self.basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposArtefacto: null == tiposArtefacto ? _self.tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<TechItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTecnologias].
extension DashboardTecnologiasPatterns on DashboardTecnologias {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTecnologias value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTecnologias() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTecnologias value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTecnologias():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTecnologias value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTecnologias() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms,  List<TechItem> basesDatos,  List<TechItem> tiposArtefacto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTecnologias() when $default != null:
return $default(_that.total,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms,  List<TechItem> basesDatos,  List<TechItem> tiposArtefacto)  $default,) {final _that = this;
switch (_that) {
case _DashboardTecnologias():
return $default(_that.total,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms,  List<TechItem> basesDatos,  List<TechItem> tiposArtefacto)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTecnologias() when $default != null:
return $default(_that.total,_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTecnologias implements DashboardTecnologias {
  const _DashboardTecnologias({this.total = 0,  List<TechItem> lenguajes = const [],  List<TechItem> frameworks = const [],  List<TechItem> arquitecturas = const [],  List<TechItem> orms = const [],  List<TechItem> basesDatos = const [],  List<TechItem> tiposArtefacto = const []}): _lenguajes = lenguajes,_frameworks = frameworks,_arquitecturas = arquitecturas,_orms = orms,_basesDatos = basesDatos,_tiposArtefacto = tiposArtefacto;
  factory _DashboardTecnologias.fromJson(Map<String, dynamic> json) => _$DashboardTecnologiasFromJson(json);

@override@JsonKey() final  int total;
 final  List<TechItem> _lenguajes;
@override@JsonKey() List<TechItem> get lenguajes {
  if (_lenguajes is EqualUnmodifiableListView) return _lenguajes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lenguajes);
}

 final  List<TechItem> _frameworks;
@override@JsonKey() List<TechItem> get frameworks {
  if (_frameworks is EqualUnmodifiableListView) return _frameworks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_frameworks);
}

 final  List<TechItem> _arquitecturas;
@override@JsonKey() List<TechItem> get arquitecturas {
  if (_arquitecturas is EqualUnmodifiableListView) return _arquitecturas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arquitecturas);
}

 final  List<TechItem> _orms;
@override@JsonKey() List<TechItem> get orms {
  if (_orms is EqualUnmodifiableListView) return _orms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orms);
}

 final  List<TechItem> _basesDatos;
@override@JsonKey() List<TechItem> get basesDatos {
  if (_basesDatos is EqualUnmodifiableListView) return _basesDatos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_basesDatos);
}

 final  List<TechItem> _tiposArtefacto;
@override@JsonKey() List<TechItem> get tiposArtefacto {
  if (_tiposArtefacto is EqualUnmodifiableListView) return _tiposArtefacto;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposArtefacto);
}


/// Create a copy of DashboardTecnologias
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTecnologiasCopyWith<_DashboardTecnologias> get copyWith => __$DashboardTecnologiasCopyWithImpl<_DashboardTecnologias>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTecnologiasToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTecnologias&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.lenguajes, _lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _orms)&&const DeepCollectionEquality().equals(other.basesDatos, _basesDatos)&&const DeepCollectionEquality().equals(other.tiposArtefacto, _tiposArtefacto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_lenguajes),const DeepCollectionEquality().hash(_frameworks),const DeepCollectionEquality().hash(_arquitecturas),const DeepCollectionEquality().hash(_orms),const DeepCollectionEquality().hash(_basesDatos),const DeepCollectionEquality().hash(_tiposArtefacto));
}

@override
String toString() {
    return 'DashboardTecnologias(total: $total, lenguajes: $lenguajes, frameworks: $frameworks, arquitecturas: $arquitecturas, orms: $orms, basesDatos: $basesDatos, tiposArtefacto: $tiposArtefacto)';
}


}

/// @nodoc
abstract mixin class _$DashboardTecnologiasCopyWith<$Res> implements $DashboardTecnologiasCopyWith<$Res> {
  factory _$DashboardTecnologiasCopyWith(_DashboardTecnologias value, $Res Function(_DashboardTecnologias) _then) = __$DashboardTecnologiasCopyWithImpl;
@override @useResult
$Res call({
 int total, List<TechItem> lenguajes, List<TechItem> frameworks, List<TechItem> arquitecturas, List<TechItem> orms, List<TechItem> basesDatos, List<TechItem> tiposArtefacto
});




}
/// @nodoc
class __$DashboardTecnologiasCopyWithImpl<$Res>
    implements _$DashboardTecnologiasCopyWith<$Res> {
  __$DashboardTecnologiasCopyWithImpl(this._self, this._then);

  final _DashboardTecnologias _self;
  final $Res Function(_DashboardTecnologias) _then;

/// Create a copy of DashboardTecnologias
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposArtefacto = null,}) {
  return _then(_DashboardTecnologias(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,lenguajes: null == lenguajes ? _self._lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<TechItem>,frameworks: null == frameworks ? _self._frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<TechItem>,arquitecturas: null == arquitecturas ? _self._arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<TechItem>,orms: null == orms ? _self._orms : orms // ignore: cast_nullable_to_non_nullable
as List<TechItem>,basesDatos: null == basesDatos ? _self._basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposArtefacto: null == tiposArtefacto ? _self._tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<TechItem>,
  ));
}


}


/// @nodoc
mixin _$TechItem {

 int get id; String get nombre;@JsonKey(name: 'nombre_code') String get nombreCode; String? get icono;@JsonKey(name: 'icono_tipo') String? get iconoTipo; int get total; double get porcentaje;
/// Create a copy of TechItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechItemCopyWith<TechItem> get copyWith => _$TechItemCopyWithImpl<TechItem>(this as TechItem, _$identity);

  /// Serializes this TechItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TechItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre)&&(identical(other.nombreCode, _this.nombreCode) || other.nombreCode == _this.nombreCode)&&(identical(other.icono, _this.icono) || other.icono == _this.icono)&&(identical(other.iconoTipo, _this.iconoTipo) || other.iconoTipo == _this.iconoTipo)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.porcentaje, _this.porcentaje) || other.porcentaje == _this.porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TechItem;
  return Object.hash(runtimeType,_this.id,_this.nombre,_this.nombreCode,_this.icono,_this.iconoTipo,_this.total,_this.porcentaje);
}

@override
String toString() {
  final _this = this as TechItem;
  return 'TechItem(id: ${_this.id}, nombre: ${_this.nombre}, nombreCode: ${_this.nombreCode}, icono: ${_this.icono}, iconoTipo: ${_this.iconoTipo}, total: ${_this.total}, porcentaje: ${_this.porcentaje})';
}


}

/// @nodoc
abstract mixin class $TechItemCopyWith<$Res>  {
  factory $TechItemCopyWith(TechItem value, $Res Function(TechItem) _then) = _$TechItemCopyWithImpl;
@useResult
$Res call({
 int id, String nombre,@JsonKey(name: 'nombre_code') String nombreCode, String? icono,@JsonKey(name: 'icono_tipo') String? iconoTipo, int total, double porcentaje
});




}
/// @nodoc
class _$TechItemCopyWithImpl<$Res>
    implements $TechItemCopyWith<$Res> {
  _$TechItemCopyWithImpl(this._self, this._then);

  final TechItem _self;
  final $Res Function(TechItem) _then;

/// Create a copy of TechItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? nombreCode = null,Object? icono = freezed,Object? iconoTipo = freezed,Object? total = null,Object? porcentaje = null,}) {
  return _then(TechItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,nombreCode: null == nombreCode ? _self.nombreCode : nombreCode // ignore: cast_nullable_to_non_nullable
as String,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,iconoTipo: freezed == iconoTipo ? _self.iconoTipo : iconoTipo // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TechItem].
extension TechItemPatterns on TechItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechItem value)  $default,){
final _that = this;
switch (_that) {
case _TechItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechItem value)?  $default,){
final _that = this;
switch (_that) {
case _TechItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo,  int total,  double porcentaje)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechItem() when $default != null:
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo,_that.total,_that.porcentaje);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo,  int total,  double porcentaje)  $default,) {final _that = this;
switch (_that) {
case _TechItem():
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo,_that.total,_that.porcentaje);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nombre, @JsonKey(name: 'nombre_code')  String nombreCode,  String? icono, @JsonKey(name: 'icono_tipo')  String? iconoTipo,  int total,  double porcentaje)?  $default,) {final _that = this;
switch (_that) {
case _TechItem() when $default != null:
return $default(_that.id,_that.nombre,_that.nombreCode,_that.icono,_that.iconoTipo,_that.total,_that.porcentaje);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechItem implements TechItem {
  const _TechItem({this.id = 0, this.nombre = '', @JsonKey(name: 'nombre_code') this.nombreCode = '', this.icono, @JsonKey(name: 'icono_tipo') this.iconoTipo, this.total = 0, this.porcentaje = 0.0});
  factory _TechItem.fromJson(Map<String, dynamic> json) => _$TechItemFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String nombre;
@override@JsonKey(name: 'nombre_code') final  String nombreCode;
@override final  String? icono;
@override@JsonKey(name: 'icono_tipo') final  String? iconoTipo;
@override@JsonKey() final  int total;
@override@JsonKey() final  double porcentaje;

/// Create a copy of TechItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechItemCopyWith<_TechItem> get copyWith => __$TechItemCopyWithImpl<_TechItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechItem&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.nombreCode, nombreCode) || other.nombreCode == nombreCode)&&(identical(other.icono, icono) || other.icono == icono)&&(identical(other.iconoTipo, iconoTipo) || other.iconoTipo == iconoTipo)&&(identical(other.total, total) || other.total == total)&&(identical(other.porcentaje, porcentaje) || other.porcentaje == porcentaje));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nombre,nombreCode,icono,iconoTipo,total,porcentaje);
}

@override
String toString() {
    return 'TechItem(id: $id, nombre: $nombre, nombreCode: $nombreCode, icono: $icono, iconoTipo: $iconoTipo, total: $total, porcentaje: $porcentaje)';
}


}

/// @nodoc
abstract mixin class _$TechItemCopyWith<$Res> implements $TechItemCopyWith<$Res> {
  factory _$TechItemCopyWith(_TechItem value, $Res Function(_TechItem) _then) = __$TechItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String nombre,@JsonKey(name: 'nombre_code') String nombreCode, String? icono,@JsonKey(name: 'icono_tipo') String? iconoTipo, int total, double porcentaje
});




}
/// @nodoc
class __$TechItemCopyWithImpl<$Res>
    implements _$TechItemCopyWith<$Res> {
  __$TechItemCopyWithImpl(this._self, this._then);

  final _TechItem _self;
  final $Res Function(_TechItem) _then;

/// Create a copy of TechItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? nombreCode = null,Object? icono = freezed,Object? iconoTipo = freezed,Object? total = null,Object? porcentaje = null,}) {
  return _then(_TechItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,nombreCode: null == nombreCode ? _self.nombreCode : nombreCode // ignore: cast_nullable_to_non_nullable
as String,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,iconoTipo: freezed == iconoTipo ? _self.iconoTipo : iconoTipo // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porcentaje: null == porcentaje ? _self.porcentaje : porcentaje // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
