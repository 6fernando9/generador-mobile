// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_catalogos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardCatalogos {

 List<TechItem> get lenguajes; List<TechItem> get frameworks; List<TechItem> get arquitecturas; List<TechItem> get orms;@JsonKey(name: 'bases_datos') List<TechItem> get basesDatos;@JsonKey(name: 'tipos_artefacto') List<TechItem> get tiposArtefacto;@JsonKey(name: 'tipos_reporte') List<TechItem> get tiposReporte;@JsonKey(name: 'tipos_xml') List<TechItem> get tiposXml;
/// Create a copy of DashboardCatalogos
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCatalogosCopyWith<DashboardCatalogos> get copyWith => _$DashboardCatalogosCopyWithImpl<DashboardCatalogos>(this as DashboardCatalogos, _$identity);

  /// Serializes this DashboardCatalogos to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardCatalogos;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCatalogos&&const DeepCollectionEquality().equals(other.lenguajes, _this.lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _this.frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _this.arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _this.orms)&&const DeepCollectionEquality().equals(other.basesDatos, _this.basesDatos)&&const DeepCollectionEquality().equals(other.tiposArtefacto, _this.tiposArtefacto)&&const DeepCollectionEquality().equals(other.tiposReporte, _this.tiposReporte)&&const DeepCollectionEquality().equals(other.tiposXml, _this.tiposXml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardCatalogos;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.lenguajes),const DeepCollectionEquality().hash(_this.frameworks),const DeepCollectionEquality().hash(_this.arquitecturas),const DeepCollectionEquality().hash(_this.orms),const DeepCollectionEquality().hash(_this.basesDatos),const DeepCollectionEquality().hash(_this.tiposArtefacto),const DeepCollectionEquality().hash(_this.tiposReporte),const DeepCollectionEquality().hash(_this.tiposXml));
}

@override
String toString() {
  final _this = this as DashboardCatalogos;
  return 'DashboardCatalogos(lenguajes: ${_this.lenguajes}, frameworks: ${_this.frameworks}, arquitecturas: ${_this.arquitecturas}, orms: ${_this.orms}, basesDatos: ${_this.basesDatos}, tiposArtefacto: ${_this.tiposArtefacto}, tiposReporte: ${_this.tiposReporte}, tiposXml: ${_this.tiposXml})';
}


}

/// @nodoc
abstract mixin class $DashboardCatalogosCopyWith<$Res>  {
  factory $DashboardCatalogosCopyWith(DashboardCatalogos value, $Res Function(DashboardCatalogos) _then) = _$DashboardCatalogosCopyWithImpl;
@useResult
$Res call({
 List<TechItem> lenguajes, List<TechItem> frameworks, List<TechItem> arquitecturas, List<TechItem> orms,@JsonKey(name: 'bases_datos') List<TechItem> basesDatos,@JsonKey(name: 'tipos_artefacto') List<TechItem> tiposArtefacto,@JsonKey(name: 'tipos_reporte') List<TechItem> tiposReporte,@JsonKey(name: 'tipos_xml') List<TechItem> tiposXml
});




}
/// @nodoc
class _$DashboardCatalogosCopyWithImpl<$Res>
    implements $DashboardCatalogosCopyWith<$Res> {
  _$DashboardCatalogosCopyWithImpl(this._self, this._then);

  final DashboardCatalogos _self;
  final $Res Function(DashboardCatalogos) _then;

/// Create a copy of DashboardCatalogos
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposArtefacto = null,Object? tiposReporte = null,Object? tiposXml = null,}) {
  return _then(DashboardCatalogos(
lenguajes: null == lenguajes ? _self.lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<TechItem>,frameworks: null == frameworks ? _self.frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<TechItem>,arquitecturas: null == arquitecturas ? _self.arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<TechItem>,orms: null == orms ? _self.orms : orms // ignore: cast_nullable_to_non_nullable
as List<TechItem>,basesDatos: null == basesDatos ? _self.basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposArtefacto: null == tiposArtefacto ? _self.tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposReporte: null == tiposReporte ? _self.tiposReporte : tiposReporte // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposXml: null == tiposXml ? _self.tiposXml : tiposXml // ignore: cast_nullable_to_non_nullable
as List<TechItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardCatalogos].
extension DashboardCatalogosPatterns on DashboardCatalogos {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCatalogos value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCatalogos() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCatalogos value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCatalogos():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCatalogos value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCatalogos() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms, @JsonKey(name: 'bases_datos')  List<TechItem> basesDatos, @JsonKey(name: 'tipos_artefacto')  List<TechItem> tiposArtefacto, @JsonKey(name: 'tipos_reporte')  List<TechItem> tiposReporte, @JsonKey(name: 'tipos_xml')  List<TechItem> tiposXml)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardCatalogos() when $default != null:
return $default(_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto,_that.tiposReporte,_that.tiposXml);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms, @JsonKey(name: 'bases_datos')  List<TechItem> basesDatos, @JsonKey(name: 'tipos_artefacto')  List<TechItem> tiposArtefacto, @JsonKey(name: 'tipos_reporte')  List<TechItem> tiposReporte, @JsonKey(name: 'tipos_xml')  List<TechItem> tiposXml)  $default,) {final _that = this;
switch (_that) {
case _DashboardCatalogos():
return $default(_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto,_that.tiposReporte,_that.tiposXml);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TechItem> lenguajes,  List<TechItem> frameworks,  List<TechItem> arquitecturas,  List<TechItem> orms, @JsonKey(name: 'bases_datos')  List<TechItem> basesDatos, @JsonKey(name: 'tipos_artefacto')  List<TechItem> tiposArtefacto, @JsonKey(name: 'tipos_reporte')  List<TechItem> tiposReporte, @JsonKey(name: 'tipos_xml')  List<TechItem> tiposXml)?  $default,) {final _that = this;
switch (_that) {
case _DashboardCatalogos() when $default != null:
return $default(_that.lenguajes,_that.frameworks,_that.arquitecturas,_that.orms,_that.basesDatos,_that.tiposArtefacto,_that.tiposReporte,_that.tiposXml);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCatalogos implements DashboardCatalogos {
  const _DashboardCatalogos({ List<TechItem> lenguajes = const [],  List<TechItem> frameworks = const [],  List<TechItem> arquitecturas = const [],  List<TechItem> orms = const [], @JsonKey(name: 'bases_datos')  List<TechItem> basesDatos = const [], @JsonKey(name: 'tipos_artefacto')  List<TechItem> tiposArtefacto = const [], @JsonKey(name: 'tipos_reporte')  List<TechItem> tiposReporte = const [], @JsonKey(name: 'tipos_xml')  List<TechItem> tiposXml = const []}): _lenguajes = lenguajes,_frameworks = frameworks,_arquitecturas = arquitecturas,_orms = orms,_basesDatos = basesDatos,_tiposArtefacto = tiposArtefacto,_tiposReporte = tiposReporte,_tiposXml = tiposXml;
  factory _DashboardCatalogos.fromJson(Map<String, dynamic> json) => _$DashboardCatalogosFromJson(json);

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
@override@JsonKey(name: 'bases_datos') List<TechItem> get basesDatos {
  if (_basesDatos is EqualUnmodifiableListView) return _basesDatos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_basesDatos);
}

 final  List<TechItem> _tiposArtefacto;
@override@JsonKey(name: 'tipos_artefacto') List<TechItem> get tiposArtefacto {
  if (_tiposArtefacto is EqualUnmodifiableListView) return _tiposArtefacto;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposArtefacto);
}

 final  List<TechItem> _tiposReporte;
@override@JsonKey(name: 'tipos_reporte') List<TechItem> get tiposReporte {
  if (_tiposReporte is EqualUnmodifiableListView) return _tiposReporte;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposReporte);
}

 final  List<TechItem> _tiposXml;
@override@JsonKey(name: 'tipos_xml') List<TechItem> get tiposXml {
  if (_tiposXml is EqualUnmodifiableListView) return _tiposXml;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiposXml);
}


/// Create a copy of DashboardCatalogos
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCatalogosCopyWith<_DashboardCatalogos> get copyWith => __$DashboardCatalogosCopyWithImpl<_DashboardCatalogos>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCatalogosToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCatalogos&&const DeepCollectionEquality().equals(other.lenguajes, _lenguajes)&&const DeepCollectionEquality().equals(other.frameworks, _frameworks)&&const DeepCollectionEquality().equals(other.arquitecturas, _arquitecturas)&&const DeepCollectionEquality().equals(other.orms, _orms)&&const DeepCollectionEquality().equals(other.basesDatos, _basesDatos)&&const DeepCollectionEquality().equals(other.tiposArtefacto, _tiposArtefacto)&&const DeepCollectionEquality().equals(other.tiposReporte, _tiposReporte)&&const DeepCollectionEquality().equals(other.tiposXml, _tiposXml));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_lenguajes),const DeepCollectionEquality().hash(_frameworks),const DeepCollectionEquality().hash(_arquitecturas),const DeepCollectionEquality().hash(_orms),const DeepCollectionEquality().hash(_basesDatos),const DeepCollectionEquality().hash(_tiposArtefacto),const DeepCollectionEquality().hash(_tiposReporte),const DeepCollectionEquality().hash(_tiposXml));
}

@override
String toString() {
    return 'DashboardCatalogos(lenguajes: $lenguajes, frameworks: $frameworks, arquitecturas: $arquitecturas, orms: $orms, basesDatos: $basesDatos, tiposArtefacto: $tiposArtefacto, tiposReporte: $tiposReporte, tiposXml: $tiposXml)';
}


}

/// @nodoc
abstract mixin class _$DashboardCatalogosCopyWith<$Res> implements $DashboardCatalogosCopyWith<$Res> {
  factory _$DashboardCatalogosCopyWith(_DashboardCatalogos value, $Res Function(_DashboardCatalogos) _then) = __$DashboardCatalogosCopyWithImpl;
@override @useResult
$Res call({
 List<TechItem> lenguajes, List<TechItem> frameworks, List<TechItem> arquitecturas, List<TechItem> orms,@JsonKey(name: 'bases_datos') List<TechItem> basesDatos,@JsonKey(name: 'tipos_artefacto') List<TechItem> tiposArtefacto,@JsonKey(name: 'tipos_reporte') List<TechItem> tiposReporte,@JsonKey(name: 'tipos_xml') List<TechItem> tiposXml
});




}
/// @nodoc
class __$DashboardCatalogosCopyWithImpl<$Res>
    implements _$DashboardCatalogosCopyWith<$Res> {
  __$DashboardCatalogosCopyWithImpl(this._self, this._then);

  final _DashboardCatalogos _self;
  final $Res Function(_DashboardCatalogos) _then;

/// Create a copy of DashboardCatalogos
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lenguajes = null,Object? frameworks = null,Object? arquitecturas = null,Object? orms = null,Object? basesDatos = null,Object? tiposArtefacto = null,Object? tiposReporte = null,Object? tiposXml = null,}) {
  return _then(_DashboardCatalogos(
lenguajes: null == lenguajes ? _self._lenguajes : lenguajes // ignore: cast_nullable_to_non_nullable
as List<TechItem>,frameworks: null == frameworks ? _self._frameworks : frameworks // ignore: cast_nullable_to_non_nullable
as List<TechItem>,arquitecturas: null == arquitecturas ? _self._arquitecturas : arquitecturas // ignore: cast_nullable_to_non_nullable
as List<TechItem>,orms: null == orms ? _self._orms : orms // ignore: cast_nullable_to_non_nullable
as List<TechItem>,basesDatos: null == basesDatos ? _self._basesDatos : basesDatos // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposArtefacto: null == tiposArtefacto ? _self._tiposArtefacto : tiposArtefacto // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposReporte: null == tiposReporte ? _self._tiposReporte : tiposReporte // ignore: cast_nullable_to_non_nullable
as List<TechItem>,tiposXml: null == tiposXml ? _self._tiposXml : tiposXml // ignore: cast_nullable_to_non_nullable
as List<TechItem>,
  ));
}


}

// dart format on
