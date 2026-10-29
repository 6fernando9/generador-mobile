// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_resumen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardResumen {

 int get hoy; int get ayer; int get semana; int get semanaPasada; int get mes; int get mesPasado; int get total; Deltas get deltas;
/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardResumenCopyWith<DashboardResumen> get copyWith => _$DashboardResumenCopyWithImpl<DashboardResumen>(this as DashboardResumen, _$identity);

  /// Serializes this DashboardResumen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardResumen;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardResumen&&(identical(other.hoy, _this.hoy) || other.hoy == _this.hoy)&&(identical(other.ayer, _this.ayer) || other.ayer == _this.ayer)&&(identical(other.semana, _this.semana) || other.semana == _this.semana)&&(identical(other.semanaPasada, _this.semanaPasada) || other.semanaPasada == _this.semanaPasada)&&(identical(other.mes, _this.mes) || other.mes == _this.mes)&&(identical(other.mesPasado, _this.mesPasado) || other.mesPasado == _this.mesPasado)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.deltas, _this.deltas) || other.deltas == _this.deltas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardResumen;
  return Object.hash(runtimeType,_this.hoy,_this.ayer,_this.semana,_this.semanaPasada,_this.mes,_this.mesPasado,_this.total,_this.deltas);
}

@override
String toString() {
  final _this = this as DashboardResumen;
  return 'DashboardResumen(hoy: ${_this.hoy}, ayer: ${_this.ayer}, semana: ${_this.semana}, semanaPasada: ${_this.semanaPasada}, mes: ${_this.mes}, mesPasado: ${_this.mesPasado}, total: ${_this.total}, deltas: ${_this.deltas})';
}


}

/// @nodoc
abstract mixin class $DashboardResumenCopyWith<$Res>  {
  factory $DashboardResumenCopyWith(DashboardResumen value, $Res Function(DashboardResumen) _then) = _$DashboardResumenCopyWithImpl;
@useResult
$Res call({
 int hoy, int ayer, int semana, int semanaPasada, int mes, int mesPasado, int total, Deltas deltas
});


$DeltasCopyWith<$Res> get deltas;

}
/// @nodoc
class _$DashboardResumenCopyWithImpl<$Res>
    implements $DashboardResumenCopyWith<$Res> {
  _$DashboardResumenCopyWithImpl(this._self, this._then);

  final DashboardResumen _self;
  final $Res Function(DashboardResumen) _then;

/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hoy = null,Object? ayer = null,Object? semana = null,Object? semanaPasada = null,Object? mes = null,Object? mesPasado = null,Object? total = null,Object? deltas = null,}) {
  return _then(DashboardResumen(
hoy: null == hoy ? _self.hoy : hoy // ignore: cast_nullable_to_non_nullable
as int,ayer: null == ayer ? _self.ayer : ayer // ignore: cast_nullable_to_non_nullable
as int,semana: null == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as int,semanaPasada: null == semanaPasada ? _self.semanaPasada : semanaPasada // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as int,mesPasado: null == mesPasado ? _self.mesPasado : mesPasado // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,deltas: null == deltas ? _self.deltas : deltas // ignore: cast_nullable_to_non_nullable
as Deltas,
  ));
}
/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeltasCopyWith<$Res> get deltas {
  
  return $DeltasCopyWith<$Res>(_self.deltas, (value) {
    return _then(_self.copyWith(deltas: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardResumen].
extension DashboardResumenPatterns on DashboardResumen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardResumen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardResumen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardResumen value)  $default,){
final _that = this;
switch (_that) {
case _DashboardResumen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardResumen value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardResumen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hoy,  int ayer,  int semana,  int semanaPasada,  int mes,  int mesPasado,  int total,  Deltas deltas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardResumen() when $default != null:
return $default(_that.hoy,_that.ayer,_that.semana,_that.semanaPasada,_that.mes,_that.mesPasado,_that.total,_that.deltas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hoy,  int ayer,  int semana,  int semanaPasada,  int mes,  int mesPasado,  int total,  Deltas deltas)  $default,) {final _that = this;
switch (_that) {
case _DashboardResumen():
return $default(_that.hoy,_that.ayer,_that.semana,_that.semanaPasada,_that.mes,_that.mesPasado,_that.total,_that.deltas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hoy,  int ayer,  int semana,  int semanaPasada,  int mes,  int mesPasado,  int total,  Deltas deltas)?  $default,) {final _that = this;
switch (_that) {
case _DashboardResumen() when $default != null:
return $default(_that.hoy,_that.ayer,_that.semana,_that.semanaPasada,_that.mes,_that.mesPasado,_that.total,_that.deltas);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardResumen implements DashboardResumen {
  const _DashboardResumen({this.hoy = 0, this.ayer = 0, this.semana = 0, this.semanaPasada = 0, this.mes = 0, this.mesPasado = 0, this.total = 0, this.deltas = const Deltas()});
  factory _DashboardResumen.fromJson(Map<String, dynamic> json) => _$DashboardResumenFromJson(json);

@override@JsonKey() final  int hoy;
@override@JsonKey() final  int ayer;
@override@JsonKey() final  int semana;
@override@JsonKey() final  int semanaPasada;
@override@JsonKey() final  int mes;
@override@JsonKey() final  int mesPasado;
@override@JsonKey() final  int total;
@override@JsonKey() final  Deltas deltas;

/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardResumenCopyWith<_DashboardResumen> get copyWith => __$DashboardResumenCopyWithImpl<_DashboardResumen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardResumenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardResumen&&(identical(other.hoy, hoy) || other.hoy == hoy)&&(identical(other.ayer, ayer) || other.ayer == ayer)&&(identical(other.semana, semana) || other.semana == semana)&&(identical(other.semanaPasada, semanaPasada) || other.semanaPasada == semanaPasada)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.mesPasado, mesPasado) || other.mesPasado == mesPasado)&&(identical(other.total, total) || other.total == total)&&(identical(other.deltas, deltas) || other.deltas == deltas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hoy,ayer,semana,semanaPasada,mes,mesPasado,total,deltas);
}

@override
String toString() {
    return 'DashboardResumen(hoy: $hoy, ayer: $ayer, semana: $semana, semanaPasada: $semanaPasada, mes: $mes, mesPasado: $mesPasado, total: $total, deltas: $deltas)';
}


}

/// @nodoc
abstract mixin class _$DashboardResumenCopyWith<$Res> implements $DashboardResumenCopyWith<$Res> {
  factory _$DashboardResumenCopyWith(_DashboardResumen value, $Res Function(_DashboardResumen) _then) = __$DashboardResumenCopyWithImpl;
@override @useResult
$Res call({
 int hoy, int ayer, int semana, int semanaPasada, int mes, int mesPasado, int total, Deltas deltas
});


@override $DeltasCopyWith<$Res> get deltas;

}
/// @nodoc
class __$DashboardResumenCopyWithImpl<$Res>
    implements _$DashboardResumenCopyWith<$Res> {
  __$DashboardResumenCopyWithImpl(this._self, this._then);

  final _DashboardResumen _self;
  final $Res Function(_DashboardResumen) _then;

/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hoy = null,Object? ayer = null,Object? semana = null,Object? semanaPasada = null,Object? mes = null,Object? mesPasado = null,Object? total = null,Object? deltas = null,}) {
  return _then(_DashboardResumen(
hoy: null == hoy ? _self.hoy : hoy // ignore: cast_nullable_to_non_nullable
as int,ayer: null == ayer ? _self.ayer : ayer // ignore: cast_nullable_to_non_nullable
as int,semana: null == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as int,semanaPasada: null == semanaPasada ? _self.semanaPasada : semanaPasada // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as int,mesPasado: null == mesPasado ? _self.mesPasado : mesPasado // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,deltas: null == deltas ? _self.deltas : deltas // ignore: cast_nullable_to_non_nullable
as Deltas,
  ));
}

/// Create a copy of DashboardResumen
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeltasCopyWith<$Res> get deltas {
  
  return $DeltasCopyWith<$Res>(_self.deltas, (value) {
    return _then(_self.copyWith(deltas: value));
  });
}
}


/// @nodoc
mixin _$Deltas {

 double get hoy; double get semana; double get mes;
/// Create a copy of Deltas
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeltasCopyWith<Deltas> get copyWith => _$DeltasCopyWithImpl<Deltas>(this as Deltas, _$identity);

  /// Serializes this Deltas to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Deltas;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deltas&&(identical(other.hoy, _this.hoy) || other.hoy == _this.hoy)&&(identical(other.semana, _this.semana) || other.semana == _this.semana)&&(identical(other.mes, _this.mes) || other.mes == _this.mes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Deltas;
  return Object.hash(runtimeType,_this.hoy,_this.semana,_this.mes);
}

@override
String toString() {
  final _this = this as Deltas;
  return 'Deltas(hoy: ${_this.hoy}, semana: ${_this.semana}, mes: ${_this.mes})';
}


}

/// @nodoc
abstract mixin class $DeltasCopyWith<$Res>  {
  factory $DeltasCopyWith(Deltas value, $Res Function(Deltas) _then) = _$DeltasCopyWithImpl;
@useResult
$Res call({
 double hoy, double semana, double mes
});




}
/// @nodoc
class _$DeltasCopyWithImpl<$Res>
    implements $DeltasCopyWith<$Res> {
  _$DeltasCopyWithImpl(this._self, this._then);

  final Deltas _self;
  final $Res Function(Deltas) _then;

/// Create a copy of Deltas
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hoy = null,Object? semana = null,Object? mes = null,}) {
  return _then(Deltas(
hoy: null == hoy ? _self.hoy : hoy // ignore: cast_nullable_to_non_nullable
as double,semana: null == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as double,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Deltas].
extension DeltasPatterns on Deltas {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Deltas value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Deltas() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Deltas value)  $default,){
final _that = this;
switch (_that) {
case _Deltas():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Deltas value)?  $default,){
final _that = this;
switch (_that) {
case _Deltas() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double hoy,  double semana,  double mes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Deltas() when $default != null:
return $default(_that.hoy,_that.semana,_that.mes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double hoy,  double semana,  double mes)  $default,) {final _that = this;
switch (_that) {
case _Deltas():
return $default(_that.hoy,_that.semana,_that.mes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double hoy,  double semana,  double mes)?  $default,) {final _that = this;
switch (_that) {
case _Deltas() when $default != null:
return $default(_that.hoy,_that.semana,_that.mes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Deltas implements Deltas {
  const _Deltas({this.hoy = 0.0, this.semana = 0.0, this.mes = 0.0});
  factory _Deltas.fromJson(Map<String, dynamic> json) => _$DeltasFromJson(json);

@override@JsonKey() final  double hoy;
@override@JsonKey() final  double semana;
@override@JsonKey() final  double mes;

/// Create a copy of Deltas
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeltasCopyWith<_Deltas> get copyWith => __$DeltasCopyWithImpl<_Deltas>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeltasToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deltas&&(identical(other.hoy, hoy) || other.hoy == hoy)&&(identical(other.semana, semana) || other.semana == semana)&&(identical(other.mes, mes) || other.mes == mes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hoy,semana,mes);
}

@override
String toString() {
    return 'Deltas(hoy: $hoy, semana: $semana, mes: $mes)';
}


}

/// @nodoc
abstract mixin class _$DeltasCopyWith<$Res> implements $DeltasCopyWith<$Res> {
  factory _$DeltasCopyWith(_Deltas value, $Res Function(_Deltas) _then) = __$DeltasCopyWithImpl;
@override @useResult
$Res call({
 double hoy, double semana, double mes
});




}
/// @nodoc
class __$DeltasCopyWithImpl<$Res>
    implements _$DeltasCopyWith<$Res> {
  __$DeltasCopyWithImpl(this._self, this._then);

  final _Deltas _self;
  final $Res Function(_Deltas) _then;

/// Create a copy of Deltas
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hoy = null,Object? semana = null,Object? mes = null,}) {
  return _then(_Deltas(
hoy: null == hoy ? _self.hoy : hoy // ignore: cast_nullable_to_non_nullable
as double,semana: null == semana ? _self.semana : semana // ignore: cast_nullable_to_non_nullable
as double,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
