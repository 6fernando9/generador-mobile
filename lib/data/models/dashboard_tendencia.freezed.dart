// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_tendencia.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardTendencia {

 int get total; String get granularidad; String get desde; String get hasta; List<TimeSeriesPoint> get serie;
/// Create a copy of DashboardTendencia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTendenciaCopyWith<DashboardTendencia> get copyWith => _$DashboardTendenciaCopyWithImpl<DashboardTendencia>(this as DashboardTendencia, _$identity);

  /// Serializes this DashboardTendencia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardTendencia;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTendencia&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.granularidad, _this.granularidad) || other.granularidad == _this.granularidad)&&(identical(other.desde, _this.desde) || other.desde == _this.desde)&&(identical(other.hasta, _this.hasta) || other.hasta == _this.hasta)&&const DeepCollectionEquality().equals(other.serie, _this.serie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardTendencia;
  return Object.hash(runtimeType,_this.total,_this.granularidad,_this.desde,_this.hasta,const DeepCollectionEquality().hash(_this.serie));
}

@override
String toString() {
  final _this = this as DashboardTendencia;
  return 'DashboardTendencia(total: ${_this.total}, granularidad: ${_this.granularidad}, desde: ${_this.desde}, hasta: ${_this.hasta}, serie: ${_this.serie})';
}


}

/// @nodoc
abstract mixin class $DashboardTendenciaCopyWith<$Res>  {
  factory $DashboardTendenciaCopyWith(DashboardTendencia value, $Res Function(DashboardTendencia) _then) = _$DashboardTendenciaCopyWithImpl;
@useResult
$Res call({
 int total, String granularidad, String desde, String hasta, List<TimeSeriesPoint> serie
});




}
/// @nodoc
class _$DashboardTendenciaCopyWithImpl<$Res>
    implements $DashboardTendenciaCopyWith<$Res> {
  _$DashboardTendenciaCopyWithImpl(this._self, this._then);

  final DashboardTendencia _self;
  final $Res Function(DashboardTendencia) _then;

/// Create a copy of DashboardTendencia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? granularidad = null,Object? desde = null,Object? hasta = null,Object? serie = null,}) {
  return _then(DashboardTendencia(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,granularidad: null == granularidad ? _self.granularidad : granularidad // ignore: cast_nullable_to_non_nullable
as String,desde: null == desde ? _self.desde : desde // ignore: cast_nullable_to_non_nullable
as String,hasta: null == hasta ? _self.hasta : hasta // ignore: cast_nullable_to_non_nullable
as String,serie: null == serie ? _self.serie : serie // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTendencia].
extension DashboardTendenciaPatterns on DashboardTendencia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTendencia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTendencia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTendencia value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTendencia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTendencia value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTendencia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  String granularidad,  String desde,  String hasta,  List<TimeSeriesPoint> serie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTendencia() when $default != null:
return $default(_that.total,_that.granularidad,_that.desde,_that.hasta,_that.serie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  String granularidad,  String desde,  String hasta,  List<TimeSeriesPoint> serie)  $default,) {final _that = this;
switch (_that) {
case _DashboardTendencia():
return $default(_that.total,_that.granularidad,_that.desde,_that.hasta,_that.serie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  String granularidad,  String desde,  String hasta,  List<TimeSeriesPoint> serie)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTendencia() when $default != null:
return $default(_that.total,_that.granularidad,_that.desde,_that.hasta,_that.serie);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTendencia implements DashboardTendencia {
  const _DashboardTendencia({this.total = 0, this.granularidad = '', this.desde = '', this.hasta = '',  List<TimeSeriesPoint> serie = const []}): _serie = serie;
  factory _DashboardTendencia.fromJson(Map<String, dynamic> json) => _$DashboardTendenciaFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  String granularidad;
@override@JsonKey() final  String desde;
@override@JsonKey() final  String hasta;
 final  List<TimeSeriesPoint> _serie;
@override@JsonKey() List<TimeSeriesPoint> get serie {
  if (_serie is EqualUnmodifiableListView) return _serie;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serie);
}


/// Create a copy of DashboardTendencia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTendenciaCopyWith<_DashboardTendencia> get copyWith => __$DashboardTendenciaCopyWithImpl<_DashboardTendencia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTendenciaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTendencia&&(identical(other.total, total) || other.total == total)&&(identical(other.granularidad, granularidad) || other.granularidad == granularidad)&&(identical(other.desde, desde) || other.desde == desde)&&(identical(other.hasta, hasta) || other.hasta == hasta)&&const DeepCollectionEquality().equals(other.serie, _serie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,granularidad,desde,hasta,const DeepCollectionEquality().hash(_serie));
}

@override
String toString() {
    return 'DashboardTendencia(total: $total, granularidad: $granularidad, desde: $desde, hasta: $hasta, serie: $serie)';
}


}

/// @nodoc
abstract mixin class _$DashboardTendenciaCopyWith<$Res> implements $DashboardTendenciaCopyWith<$Res> {
  factory _$DashboardTendenciaCopyWith(_DashboardTendencia value, $Res Function(_DashboardTendencia) _then) = __$DashboardTendenciaCopyWithImpl;
@override @useResult
$Res call({
 int total, String granularidad, String desde, String hasta, List<TimeSeriesPoint> serie
});




}
/// @nodoc
class __$DashboardTendenciaCopyWithImpl<$Res>
    implements _$DashboardTendenciaCopyWith<$Res> {
  __$DashboardTendenciaCopyWithImpl(this._self, this._then);

  final _DashboardTendencia _self;
  final $Res Function(_DashboardTendencia) _then;

/// Create a copy of DashboardTendencia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? granularidad = null,Object? desde = null,Object? hasta = null,Object? serie = null,}) {
  return _then(_DashboardTendencia(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,granularidad: null == granularidad ? _self.granularidad : granularidad // ignore: cast_nullable_to_non_nullable
as String,desde: null == desde ? _self.desde : desde // ignore: cast_nullable_to_non_nullable
as String,hasta: null == hasta ? _self.hasta : hasta // ignore: cast_nullable_to_non_nullable
as String,serie: null == serie ? _self._serie : serie // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesPoint>,
  ));
}


}


/// @nodoc
mixin _$TimeSeriesPoint {

 String get periodo; int get total; int get backend; int get frontend; int get mobile;
/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesPointCopyWith<TimeSeriesPoint> get copyWith => _$TimeSeriesPointCopyWithImpl<TimeSeriesPoint>(this as TimeSeriesPoint, _$identity);

  /// Serializes this TimeSeriesPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimeSeriesPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeriesPoint&&(identical(other.periodo, _this.periodo) || other.periodo == _this.periodo)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.backend, _this.backend) || other.backend == _this.backend)&&(identical(other.frontend, _this.frontend) || other.frontend == _this.frontend)&&(identical(other.mobile, _this.mobile) || other.mobile == _this.mobile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimeSeriesPoint;
  return Object.hash(runtimeType,_this.periodo,_this.total,_this.backend,_this.frontend,_this.mobile);
}

@override
String toString() {
  final _this = this as TimeSeriesPoint;
  return 'TimeSeriesPoint(periodo: ${_this.periodo}, total: ${_this.total}, backend: ${_this.backend}, frontend: ${_this.frontend}, mobile: ${_this.mobile})';
}


}

/// @nodoc
abstract mixin class $TimeSeriesPointCopyWith<$Res>  {
  factory $TimeSeriesPointCopyWith(TimeSeriesPoint value, $Res Function(TimeSeriesPoint) _then) = _$TimeSeriesPointCopyWithImpl;
@useResult
$Res call({
 String periodo, int total, int backend, int frontend, int mobile
});




}
/// @nodoc
class _$TimeSeriesPointCopyWithImpl<$Res>
    implements $TimeSeriesPointCopyWith<$Res> {
  _$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final TimeSeriesPoint _self;
  final $Res Function(TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periodo = null,Object? total = null,Object? backend = null,Object? frontend = null,Object? mobile = null,}) {
  return _then(TimeSeriesPoint(
periodo: null == periodo ? _self.periodo : periodo // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as int,frontend: null == frontend ? _self.frontend : frontend // ignore: cast_nullable_to_non_nullable
as int,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeriesPoint].
extension TimeSeriesPointPatterns on TimeSeriesPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeriesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String periodo,  int total,  int backend,  int frontend,  int mobile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.periodo,_that.total,_that.backend,_that.frontend,_that.mobile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String periodo,  int total,  int backend,  int frontend,  int mobile)  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint():
return $default(_that.periodo,_that.total,_that.backend,_that.frontend,_that.mobile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String periodo,  int total,  int backend,  int frontend,  int mobile)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.periodo,_that.total,_that.backend,_that.frontend,_that.mobile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSeriesPoint implements TimeSeriesPoint {
  const _TimeSeriesPoint({this.periodo = '', this.total = 0, this.backend = 0, this.frontend = 0, this.mobile = 0});
  factory _TimeSeriesPoint.fromJson(Map<String, dynamic> json) => _$TimeSeriesPointFromJson(json);

@override@JsonKey() final  String periodo;
@override@JsonKey() final  int total;
@override@JsonKey() final  int backend;
@override@JsonKey() final  int frontend;
@override@JsonKey() final  int mobile;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesPointCopyWith<_TimeSeriesPoint> get copyWith => __$TimeSeriesPointCopyWithImpl<_TimeSeriesPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSeriesPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeriesPoint&&(identical(other.periodo, periodo) || other.periodo == periodo)&&(identical(other.total, total) || other.total == total)&&(identical(other.backend, backend) || other.backend == backend)&&(identical(other.frontend, frontend) || other.frontend == frontend)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,periodo,total,backend,frontend,mobile);
}

@override
String toString() {
    return 'TimeSeriesPoint(periodo: $periodo, total: $total, backend: $backend, frontend: $frontend, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesPointCopyWith<$Res> implements $TimeSeriesPointCopyWith<$Res> {
  factory _$TimeSeriesPointCopyWith(_TimeSeriesPoint value, $Res Function(_TimeSeriesPoint) _then) = __$TimeSeriesPointCopyWithImpl;
@override @useResult
$Res call({
 String periodo, int total, int backend, int frontend, int mobile
});




}
/// @nodoc
class __$TimeSeriesPointCopyWithImpl<$Res>
    implements _$TimeSeriesPointCopyWith<$Res> {
  __$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final _TimeSeriesPoint _self;
  final $Res Function(_TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periodo = null,Object? total = null,Object? backend = null,Object? frontend = null,Object? mobile = null,}) {
  return _then(_TimeSeriesPoint(
periodo: null == periodo ? _self.periodo : periodo // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,backend: null == backend ? _self.backend : backend // ignore: cast_nullable_to_non_nullable
as int,frontend: null == frontend ? _self.frontend : frontend // ignore: cast_nullable_to_non_nullable
as int,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
