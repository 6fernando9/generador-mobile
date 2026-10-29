// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_actividad.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardActividad {

 int get total; List<DayOfWeekStat> get porDiaSemana; List<HourStat> get porHora; List<HeatmapPoint> get heatmap;
/// Create a copy of DashboardActividad
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardActividadCopyWith<DashboardActividad> get copyWith => _$DashboardActividadCopyWithImpl<DashboardActividad>(this as DashboardActividad, _$identity);

  /// Serializes this DashboardActividad to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardActividad;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardActividad&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.porDiaSemana, _this.porDiaSemana)&&const DeepCollectionEquality().equals(other.porHora, _this.porHora)&&const DeepCollectionEquality().equals(other.heatmap, _this.heatmap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardActividad;
  return Object.hash(runtimeType,_this.total,const DeepCollectionEquality().hash(_this.porDiaSemana),const DeepCollectionEquality().hash(_this.porHora),const DeepCollectionEquality().hash(_this.heatmap));
}

@override
String toString() {
  final _this = this as DashboardActividad;
  return 'DashboardActividad(total: ${_this.total}, porDiaSemana: ${_this.porDiaSemana}, porHora: ${_this.porHora}, heatmap: ${_this.heatmap})';
}


}

/// @nodoc
abstract mixin class $DashboardActividadCopyWith<$Res>  {
  factory $DashboardActividadCopyWith(DashboardActividad value, $Res Function(DashboardActividad) _then) = _$DashboardActividadCopyWithImpl;
@useResult
$Res call({
 int total, List<DayOfWeekStat> porDiaSemana, List<HourStat> porHora, List<HeatmapPoint> heatmap
});




}
/// @nodoc
class _$DashboardActividadCopyWithImpl<$Res>
    implements $DashboardActividadCopyWith<$Res> {
  _$DashboardActividadCopyWithImpl(this._self, this._then);

  final DashboardActividad _self;
  final $Res Function(DashboardActividad) _then;

/// Create a copy of DashboardActividad
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? porDiaSemana = null,Object? porHora = null,Object? heatmap = null,}) {
  return _then(DashboardActividad(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porDiaSemana: null == porDiaSemana ? _self.porDiaSemana : porDiaSemana // ignore: cast_nullable_to_non_nullable
as List<DayOfWeekStat>,porHora: null == porHora ? _self.porHora : porHora // ignore: cast_nullable_to_non_nullable
as List<HourStat>,heatmap: null == heatmap ? _self.heatmap : heatmap // ignore: cast_nullable_to_non_nullable
as List<HeatmapPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardActividad].
extension DashboardActividadPatterns on DashboardActividad {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardActividad value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardActividad() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardActividad value)  $default,){
final _that = this;
switch (_that) {
case _DashboardActividad():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardActividad value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardActividad() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<DayOfWeekStat> porDiaSemana,  List<HourStat> porHora,  List<HeatmapPoint> heatmap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardActividad() when $default != null:
return $default(_that.total,_that.porDiaSemana,_that.porHora,_that.heatmap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<DayOfWeekStat> porDiaSemana,  List<HourStat> porHora,  List<HeatmapPoint> heatmap)  $default,) {final _that = this;
switch (_that) {
case _DashboardActividad():
return $default(_that.total,_that.porDiaSemana,_that.porHora,_that.heatmap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<DayOfWeekStat> porDiaSemana,  List<HourStat> porHora,  List<HeatmapPoint> heatmap)?  $default,) {final _that = this;
switch (_that) {
case _DashboardActividad() when $default != null:
return $default(_that.total,_that.porDiaSemana,_that.porHora,_that.heatmap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardActividad implements DashboardActividad {
  const _DashboardActividad({this.total = 0,  List<DayOfWeekStat> porDiaSemana = const [],  List<HourStat> porHora = const [],  List<HeatmapPoint> heatmap = const []}): _porDiaSemana = porDiaSemana,_porHora = porHora,_heatmap = heatmap;
  factory _DashboardActividad.fromJson(Map<String, dynamic> json) => _$DashboardActividadFromJson(json);

@override@JsonKey() final  int total;
 final  List<DayOfWeekStat> _porDiaSemana;
@override@JsonKey() List<DayOfWeekStat> get porDiaSemana {
  if (_porDiaSemana is EqualUnmodifiableListView) return _porDiaSemana;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_porDiaSemana);
}

 final  List<HourStat> _porHora;
@override@JsonKey() List<HourStat> get porHora {
  if (_porHora is EqualUnmodifiableListView) return _porHora;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_porHora);
}

 final  List<HeatmapPoint> _heatmap;
@override@JsonKey() List<HeatmapPoint> get heatmap {
  if (_heatmap is EqualUnmodifiableListView) return _heatmap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heatmap);
}


/// Create a copy of DashboardActividad
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardActividadCopyWith<_DashboardActividad> get copyWith => __$DashboardActividadCopyWithImpl<_DashboardActividad>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardActividadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardActividad&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.porDiaSemana, _porDiaSemana)&&const DeepCollectionEquality().equals(other.porHora, _porHora)&&const DeepCollectionEquality().equals(other.heatmap, _heatmap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_porDiaSemana),const DeepCollectionEquality().hash(_porHora),const DeepCollectionEquality().hash(_heatmap));
}

@override
String toString() {
    return 'DashboardActividad(total: $total, porDiaSemana: $porDiaSemana, porHora: $porHora, heatmap: $heatmap)';
}


}

/// @nodoc
abstract mixin class _$DashboardActividadCopyWith<$Res> implements $DashboardActividadCopyWith<$Res> {
  factory _$DashboardActividadCopyWith(_DashboardActividad value, $Res Function(_DashboardActividad) _then) = __$DashboardActividadCopyWithImpl;
@override @useResult
$Res call({
 int total, List<DayOfWeekStat> porDiaSemana, List<HourStat> porHora, List<HeatmapPoint> heatmap
});




}
/// @nodoc
class __$DashboardActividadCopyWithImpl<$Res>
    implements _$DashboardActividadCopyWith<$Res> {
  __$DashboardActividadCopyWithImpl(this._self, this._then);

  final _DashboardActividad _self;
  final $Res Function(_DashboardActividad) _then;

/// Create a copy of DashboardActividad
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? porDiaSemana = null,Object? porHora = null,Object? heatmap = null,}) {
  return _then(_DashboardActividad(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,porDiaSemana: null == porDiaSemana ? _self._porDiaSemana : porDiaSemana // ignore: cast_nullable_to_non_nullable
as List<DayOfWeekStat>,porHora: null == porHora ? _self._porHora : porHora // ignore: cast_nullable_to_non_nullable
as List<HourStat>,heatmap: null == heatmap ? _self._heatmap : heatmap // ignore: cast_nullable_to_non_nullable
as List<HeatmapPoint>,
  ));
}


}


/// @nodoc
mixin _$DayOfWeekStat {

 int get dia; String get nombre; int get total;
/// Create a copy of DayOfWeekStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayOfWeekStatCopyWith<DayOfWeekStat> get copyWith => _$DayOfWeekStatCopyWithImpl<DayOfWeekStat>(this as DayOfWeekStat, _$identity);

  /// Serializes this DayOfWeekStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayOfWeekStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayOfWeekStat&&(identical(other.dia, _this.dia) || other.dia == _this.dia)&&(identical(other.nombre, _this.nombre) || other.nombre == _this.nombre)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayOfWeekStat;
  return Object.hash(runtimeType,_this.dia,_this.nombre,_this.total);
}

@override
String toString() {
  final _this = this as DayOfWeekStat;
  return 'DayOfWeekStat(dia: ${_this.dia}, nombre: ${_this.nombre}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $DayOfWeekStatCopyWith<$Res>  {
  factory $DayOfWeekStatCopyWith(DayOfWeekStat value, $Res Function(DayOfWeekStat) _then) = _$DayOfWeekStatCopyWithImpl;
@useResult
$Res call({
 int dia, String nombre, int total
});




}
/// @nodoc
class _$DayOfWeekStatCopyWithImpl<$Res>
    implements $DayOfWeekStatCopyWith<$Res> {
  _$DayOfWeekStatCopyWithImpl(this._self, this._then);

  final DayOfWeekStat _self;
  final $Res Function(DayOfWeekStat) _then;

/// Create a copy of DayOfWeekStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dia = null,Object? nombre = null,Object? total = null,}) {
  return _then(DayOfWeekStat(
dia: null == dia ? _self.dia : dia // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayOfWeekStat].
extension DayOfWeekStatPatterns on DayOfWeekStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayOfWeekStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayOfWeekStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayOfWeekStat value)  $default,){
final _that = this;
switch (_that) {
case _DayOfWeekStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayOfWeekStat value)?  $default,){
final _that = this;
switch (_that) {
case _DayOfWeekStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dia,  String nombre,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayOfWeekStat() when $default != null:
return $default(_that.dia,_that.nombre,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dia,  String nombre,  int total)  $default,) {final _that = this;
switch (_that) {
case _DayOfWeekStat():
return $default(_that.dia,_that.nombre,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dia,  String nombre,  int total)?  $default,) {final _that = this;
switch (_that) {
case _DayOfWeekStat() when $default != null:
return $default(_that.dia,_that.nombre,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayOfWeekStat implements DayOfWeekStat {
  const _DayOfWeekStat({this.dia = 0, this.nombre = '', this.total = 0});
  factory _DayOfWeekStat.fromJson(Map<String, dynamic> json) => _$DayOfWeekStatFromJson(json);

@override@JsonKey() final  int dia;
@override@JsonKey() final  String nombre;
@override@JsonKey() final  int total;

/// Create a copy of DayOfWeekStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayOfWeekStatCopyWith<_DayOfWeekStat> get copyWith => __$DayOfWeekStatCopyWithImpl<_DayOfWeekStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayOfWeekStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayOfWeekStat&&(identical(other.dia, dia) || other.dia == dia)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dia,nombre,total);
}

@override
String toString() {
    return 'DayOfWeekStat(dia: $dia, nombre: $nombre, total: $total)';
}


}

/// @nodoc
abstract mixin class _$DayOfWeekStatCopyWith<$Res> implements $DayOfWeekStatCopyWith<$Res> {
  factory _$DayOfWeekStatCopyWith(_DayOfWeekStat value, $Res Function(_DayOfWeekStat) _then) = __$DayOfWeekStatCopyWithImpl;
@override @useResult
$Res call({
 int dia, String nombre, int total
});




}
/// @nodoc
class __$DayOfWeekStatCopyWithImpl<$Res>
    implements _$DayOfWeekStatCopyWith<$Res> {
  __$DayOfWeekStatCopyWithImpl(this._self, this._then);

  final _DayOfWeekStat _self;
  final $Res Function(_DayOfWeekStat) _then;

/// Create a copy of DayOfWeekStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dia = null,Object? nombre = null,Object? total = null,}) {
  return _then(_DayOfWeekStat(
dia: null == dia ? _self.dia : dia // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HourStat {

 int get hora; int get total;
/// Create a copy of HourStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourStatCopyWith<HourStat> get copyWith => _$HourStatCopyWithImpl<HourStat>(this as HourStat, _$identity);

  /// Serializes this HourStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HourStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourStat&&(identical(other.hora, _this.hora) || other.hora == _this.hora)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HourStat;
  return Object.hash(runtimeType,_this.hora,_this.total);
}

@override
String toString() {
  final _this = this as HourStat;
  return 'HourStat(hora: ${_this.hora}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $HourStatCopyWith<$Res>  {
  factory $HourStatCopyWith(HourStat value, $Res Function(HourStat) _then) = _$HourStatCopyWithImpl;
@useResult
$Res call({
 int hora, int total
});




}
/// @nodoc
class _$HourStatCopyWithImpl<$Res>
    implements $HourStatCopyWith<$Res> {
  _$HourStatCopyWithImpl(this._self, this._then);

  final HourStat _self;
  final $Res Function(HourStat) _then;

/// Create a copy of HourStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hora = null,Object? total = null,}) {
  return _then(HourStat(
hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HourStat].
extension HourStatPatterns on HourStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourStat value)  $default,){
final _that = this;
switch (_that) {
case _HourStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourStat value)?  $default,){
final _that = this;
switch (_that) {
case _HourStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hora,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourStat() when $default != null:
return $default(_that.hora,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hora,  int total)  $default,) {final _that = this;
switch (_that) {
case _HourStat():
return $default(_that.hora,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hora,  int total)?  $default,) {final _that = this;
switch (_that) {
case _HourStat() when $default != null:
return $default(_that.hora,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourStat implements HourStat {
  const _HourStat({this.hora = 0, this.total = 0});
  factory _HourStat.fromJson(Map<String, dynamic> json) => _$HourStatFromJson(json);

@override@JsonKey() final  int hora;
@override@JsonKey() final  int total;

/// Create a copy of HourStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourStatCopyWith<_HourStat> get copyWith => __$HourStatCopyWithImpl<_HourStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourStat&&(identical(other.hora, hora) || other.hora == hora)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hora,total);
}

@override
String toString() {
    return 'HourStat(hora: $hora, total: $total)';
}


}

/// @nodoc
abstract mixin class _$HourStatCopyWith<$Res> implements $HourStatCopyWith<$Res> {
  factory _$HourStatCopyWith(_HourStat value, $Res Function(_HourStat) _then) = __$HourStatCopyWithImpl;
@override @useResult
$Res call({
 int hora, int total
});




}
/// @nodoc
class __$HourStatCopyWithImpl<$Res>
    implements _$HourStatCopyWith<$Res> {
  __$HourStatCopyWithImpl(this._self, this._then);

  final _HourStat _self;
  final $Res Function(_HourStat) _then;

/// Create a copy of HourStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hora = null,Object? total = null,}) {
  return _then(_HourStat(
hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HeatmapPoint {

 int get dia; int get hora; int get total;
/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeatmapPointCopyWith<HeatmapPoint> get copyWith => _$HeatmapPointCopyWithImpl<HeatmapPoint>(this as HeatmapPoint, _$identity);

  /// Serializes this HeatmapPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HeatmapPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeatmapPoint&&(identical(other.dia, _this.dia) || other.dia == _this.dia)&&(identical(other.hora, _this.hora) || other.hora == _this.hora)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HeatmapPoint;
  return Object.hash(runtimeType,_this.dia,_this.hora,_this.total);
}

@override
String toString() {
  final _this = this as HeatmapPoint;
  return 'HeatmapPoint(dia: ${_this.dia}, hora: ${_this.hora}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $HeatmapPointCopyWith<$Res>  {
  factory $HeatmapPointCopyWith(HeatmapPoint value, $Res Function(HeatmapPoint) _then) = _$HeatmapPointCopyWithImpl;
@useResult
$Res call({
 int dia, int hora, int total
});




}
/// @nodoc
class _$HeatmapPointCopyWithImpl<$Res>
    implements $HeatmapPointCopyWith<$Res> {
  _$HeatmapPointCopyWithImpl(this._self, this._then);

  final HeatmapPoint _self;
  final $Res Function(HeatmapPoint) _then;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dia = null,Object? hora = null,Object? total = null,}) {
  return _then(HeatmapPoint(
dia: null == dia ? _self.dia : dia // ignore: cast_nullable_to_non_nullable
as int,hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HeatmapPoint].
extension HeatmapPointPatterns on HeatmapPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeatmapPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeatmapPoint value)  $default,){
final _that = this;
switch (_that) {
case _HeatmapPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeatmapPoint value)?  $default,){
final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dia,  int hora,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
return $default(_that.dia,_that.hora,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dia,  int hora,  int total)  $default,) {final _that = this;
switch (_that) {
case _HeatmapPoint():
return $default(_that.dia,_that.hora,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dia,  int hora,  int total)?  $default,) {final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
return $default(_that.dia,_that.hora,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeatmapPoint implements HeatmapPoint {
  const _HeatmapPoint({this.dia = 0, this.hora = 0, this.total = 0});
  factory _HeatmapPoint.fromJson(Map<String, dynamic> json) => _$HeatmapPointFromJson(json);

@override@JsonKey() final  int dia;
@override@JsonKey() final  int hora;
@override@JsonKey() final  int total;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeatmapPointCopyWith<_HeatmapPoint> get copyWith => __$HeatmapPointCopyWithImpl<_HeatmapPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeatmapPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeatmapPoint&&(identical(other.dia, dia) || other.dia == dia)&&(identical(other.hora, hora) || other.hora == hora)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dia,hora,total);
}

@override
String toString() {
    return 'HeatmapPoint(dia: $dia, hora: $hora, total: $total)';
}


}

/// @nodoc
abstract mixin class _$HeatmapPointCopyWith<$Res> implements $HeatmapPointCopyWith<$Res> {
  factory _$HeatmapPointCopyWith(_HeatmapPoint value, $Res Function(_HeatmapPoint) _then) = __$HeatmapPointCopyWithImpl;
@override @useResult
$Res call({
 int dia, int hora, int total
});




}
/// @nodoc
class __$HeatmapPointCopyWithImpl<$Res>
    implements _$HeatmapPointCopyWith<$Res> {
  __$HeatmapPointCopyWithImpl(this._self, this._then);

  final _HeatmapPoint _self;
  final $Res Function(_HeatmapPoint) _then;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dia = null,Object? hora = null,Object? total = null,}) {
  return _then(_HeatmapPoint(
dia: null == dia ? _self.dia : dia // ignore: cast_nullable_to_non_nullable
as int,hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
