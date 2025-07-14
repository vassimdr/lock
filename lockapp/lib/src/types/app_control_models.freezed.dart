// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_control_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppBlockRule _$AppBlockRuleFromJson(Map<String, dynamic> json) {
  return _AppBlockRule.fromJson(json);
}

/// @nodoc
mixin _$AppBlockRule {
  String get id => throw _privateConstructorUsedError;
  String get parentUserId => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  String get appIcon =>
      throw _privateConstructorUsedError; // Base64 encoded icon
  bool get isBlocked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get reason =>
      throw _privateConstructorUsedError; // Optional reason for blocking
  DateTime? get blockedUntil => throw _privateConstructorUsedError;

  /// Serializes this AppBlockRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppBlockRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppBlockRuleCopyWith<AppBlockRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppBlockRuleCopyWith<$Res> {
  factory $AppBlockRuleCopyWith(
    AppBlockRule value,
    $Res Function(AppBlockRule) then,
  ) = _$AppBlockRuleCopyWithImpl<$Res, AppBlockRule>;
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    bool isBlocked,
    DateTime createdAt,
    DateTime updatedAt,
    String? reason,
    DateTime? blockedUntil,
  });
}

/// @nodoc
class _$AppBlockRuleCopyWithImpl<$Res, $Val extends AppBlockRule>
    implements $AppBlockRuleCopyWith<$Res> {
  _$AppBlockRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppBlockRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? isBlocked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? reason = freezed,
    Object? blockedUntil = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            parentUserId: null == parentUserId
                ? _value.parentUserId
                : parentUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            childUserId: null == childUserId
                ? _value.childUserId
                : childUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            packageName: null == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String,
            appName: null == appName
                ? _value.appName
                : appName // ignore: cast_nullable_to_non_nullable
                      as String,
            appIcon: null == appIcon
                ? _value.appIcon
                : appIcon // ignore: cast_nullable_to_non_nullable
                      as String,
            isBlocked: null == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            blockedUntil: freezed == blockedUntil
                ? _value.blockedUntil
                : blockedUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppBlockRuleImplCopyWith<$Res>
    implements $AppBlockRuleCopyWith<$Res> {
  factory _$$AppBlockRuleImplCopyWith(
    _$AppBlockRuleImpl value,
    $Res Function(_$AppBlockRuleImpl) then,
  ) = __$$AppBlockRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    bool isBlocked,
    DateTime createdAt,
    DateTime updatedAt,
    String? reason,
    DateTime? blockedUntil,
  });
}

/// @nodoc
class __$$AppBlockRuleImplCopyWithImpl<$Res>
    extends _$AppBlockRuleCopyWithImpl<$Res, _$AppBlockRuleImpl>
    implements _$$AppBlockRuleImplCopyWith<$Res> {
  __$$AppBlockRuleImplCopyWithImpl(
    _$AppBlockRuleImpl _value,
    $Res Function(_$AppBlockRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppBlockRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? isBlocked = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? reason = freezed,
    Object? blockedUntil = freezed,
  }) {
    return _then(
      _$AppBlockRuleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentUserId: null == parentUserId
            ? _value.parentUserId
            : parentUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        childUserId: null == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        packageName: null == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String,
        appName: null == appName
            ? _value.appName
            : appName // ignore: cast_nullable_to_non_nullable
                  as String,
        appIcon: null == appIcon
            ? _value.appIcon
            : appIcon // ignore: cast_nullable_to_non_nullable
                  as String,
        isBlocked: null == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        blockedUntil: freezed == blockedUntil
            ? _value.blockedUntil
            : blockedUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppBlockRuleImpl extends _AppBlockRule {
  const _$AppBlockRuleImpl({
    required this.id,
    required this.parentUserId,
    required this.childUserId,
    required this.packageName,
    required this.appName,
    required this.appIcon,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
    this.reason,
    this.blockedUntil,
  }) : super._();

  factory _$AppBlockRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppBlockRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String parentUserId;
  @override
  final String childUserId;
  @override
  final String packageName;
  @override
  final String appName;
  @override
  final String appIcon;
  // Base64 encoded icon
  @override
  final bool isBlocked;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? reason;
  // Optional reason for blocking
  @override
  final DateTime? blockedUntil;

  @override
  String toString() {
    return 'AppBlockRule(id: $id, parentUserId: $parentUserId, childUserId: $childUserId, packageName: $packageName, appName: $appName, appIcon: $appIcon, isBlocked: $isBlocked, createdAt: $createdAt, updatedAt: $updatedAt, reason: $reason, blockedUntil: $blockedUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppBlockRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentUserId, parentUserId) ||
                other.parentUserId == parentUserId) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.appIcon, appIcon) || other.appIcon == appIcon) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.blockedUntil, blockedUntil) ||
                other.blockedUntil == blockedUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentUserId,
    childUserId,
    packageName,
    appName,
    appIcon,
    isBlocked,
    createdAt,
    updatedAt,
    reason,
    blockedUntil,
  );

  /// Create a copy of AppBlockRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppBlockRuleImplCopyWith<_$AppBlockRuleImpl> get copyWith =>
      __$$AppBlockRuleImplCopyWithImpl<_$AppBlockRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppBlockRuleImplToJson(this);
  }
}

abstract class _AppBlockRule extends AppBlockRule {
  const factory _AppBlockRule({
    required final String id,
    required final String parentUserId,
    required final String childUserId,
    required final String packageName,
    required final String appName,
    required final String appIcon,
    required final bool isBlocked,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? reason,
    final DateTime? blockedUntil,
  }) = _$AppBlockRuleImpl;
  const _AppBlockRule._() : super._();

  factory _AppBlockRule.fromJson(Map<String, dynamic> json) =
      _$AppBlockRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get parentUserId;
  @override
  String get childUserId;
  @override
  String get packageName;
  @override
  String get appName;
  @override
  String get appIcon; // Base64 encoded icon
  @override
  bool get isBlocked;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get reason; // Optional reason for blocking
  @override
  DateTime? get blockedUntil;

  /// Create a copy of AppBlockRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppBlockRuleImplCopyWith<_$AppBlockRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeRestriction _$TimeRestrictionFromJson(Map<String, dynamic> json) {
  return _TimeRestriction.fromJson(json);
}

/// @nodoc
mixin _$TimeRestriction {
  String get id => throw _privateConstructorUsedError;
  String get parentUserId => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  String get appIcon =>
      throw _privateConstructorUsedError; // Base64 encoded icon
  bool get isEnabled => throw _privateConstructorUsedError;
  int get dailyTimeLimit => throw _privateConstructorUsedError; // in minutes
  List<int> get allowedDays =>
      throw _privateConstructorUsedError; // 0-6 (Sunday-Saturday)
  String get startTime => throw _privateConstructorUsedError; // HH:mm format
  String get endTime => throw _privateConstructorUsedError; // HH:mm format
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TimeRestriction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeRestriction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeRestrictionCopyWith<TimeRestriction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeRestrictionCopyWith<$Res> {
  factory $TimeRestrictionCopyWith(
    TimeRestriction value,
    $Res Function(TimeRestriction) then,
  ) = _$TimeRestrictionCopyWithImpl<$Res, TimeRestriction>;
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    bool isEnabled,
    int dailyTimeLimit,
    List<int> allowedDays,
    String startTime,
    String endTime,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$TimeRestrictionCopyWithImpl<$Res, $Val extends TimeRestriction>
    implements $TimeRestrictionCopyWith<$Res> {
  _$TimeRestrictionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeRestriction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? isEnabled = null,
    Object? dailyTimeLimit = null,
    Object? allowedDays = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            parentUserId: null == parentUserId
                ? _value.parentUserId
                : parentUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            childUserId: null == childUserId
                ? _value.childUserId
                : childUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            packageName: null == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String,
            appName: null == appName
                ? _value.appName
                : appName // ignore: cast_nullable_to_non_nullable
                      as String,
            appIcon: null == appIcon
                ? _value.appIcon
                : appIcon // ignore: cast_nullable_to_non_nullable
                      as String,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            dailyTimeLimit: null == dailyTimeLimit
                ? _value.dailyTimeLimit
                : dailyTimeLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            allowedDays: null == allowedDays
                ? _value.allowedDays
                : allowedDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeRestrictionImplCopyWith<$Res>
    implements $TimeRestrictionCopyWith<$Res> {
  factory _$$TimeRestrictionImplCopyWith(
    _$TimeRestrictionImpl value,
    $Res Function(_$TimeRestrictionImpl) then,
  ) = __$$TimeRestrictionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    bool isEnabled,
    int dailyTimeLimit,
    List<int> allowedDays,
    String startTime,
    String endTime,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$TimeRestrictionImplCopyWithImpl<$Res>
    extends _$TimeRestrictionCopyWithImpl<$Res, _$TimeRestrictionImpl>
    implements _$$TimeRestrictionImplCopyWith<$Res> {
  __$$TimeRestrictionImplCopyWithImpl(
    _$TimeRestrictionImpl _value,
    $Res Function(_$TimeRestrictionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeRestriction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? isEnabled = null,
    Object? dailyTimeLimit = null,
    Object? allowedDays = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TimeRestrictionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentUserId: null == parentUserId
            ? _value.parentUserId
            : parentUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        childUserId: null == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        packageName: null == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String,
        appName: null == appName
            ? _value.appName
            : appName // ignore: cast_nullable_to_non_nullable
                  as String,
        appIcon: null == appIcon
            ? _value.appIcon
            : appIcon // ignore: cast_nullable_to_non_nullable
                  as String,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyTimeLimit: null == dailyTimeLimit
            ? _value.dailyTimeLimit
            : dailyTimeLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        allowedDays: null == allowedDays
            ? _value._allowedDays
            : allowedDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeRestrictionImpl extends _TimeRestriction {
  const _$TimeRestrictionImpl({
    required this.id,
    required this.parentUserId,
    required this.childUserId,
    required this.packageName,
    required this.appName,
    required this.appIcon,
    required this.isEnabled,
    required this.dailyTimeLimit,
    required final List<int> allowedDays,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  }) : _allowedDays = allowedDays,
       super._();

  factory _$TimeRestrictionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeRestrictionImplFromJson(json);

  @override
  final String id;
  @override
  final String parentUserId;
  @override
  final String childUserId;
  @override
  final String packageName;
  @override
  final String appName;
  @override
  final String appIcon;
  // Base64 encoded icon
  @override
  final bool isEnabled;
  @override
  final int dailyTimeLimit;
  // in minutes
  final List<int> _allowedDays;
  // in minutes
  @override
  List<int> get allowedDays {
    if (_allowedDays is EqualUnmodifiableListView) return _allowedDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedDays);
  }

  // 0-6 (Sunday-Saturday)
  @override
  final String startTime;
  // HH:mm format
  @override
  final String endTime;
  // HH:mm format
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TimeRestriction(id: $id, parentUserId: $parentUserId, childUserId: $childUserId, packageName: $packageName, appName: $appName, appIcon: $appIcon, isEnabled: $isEnabled, dailyTimeLimit: $dailyTimeLimit, allowedDays: $allowedDays, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeRestrictionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentUserId, parentUserId) ||
                other.parentUserId == parentUserId) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.appIcon, appIcon) || other.appIcon == appIcon) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.dailyTimeLimit, dailyTimeLimit) ||
                other.dailyTimeLimit == dailyTimeLimit) &&
            const DeepCollectionEquality().equals(
              other._allowedDays,
              _allowedDays,
            ) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentUserId,
    childUserId,
    packageName,
    appName,
    appIcon,
    isEnabled,
    dailyTimeLimit,
    const DeepCollectionEquality().hash(_allowedDays),
    startTime,
    endTime,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TimeRestriction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeRestrictionImplCopyWith<_$TimeRestrictionImpl> get copyWith =>
      __$$TimeRestrictionImplCopyWithImpl<_$TimeRestrictionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeRestrictionImplToJson(this);
  }
}

abstract class _TimeRestriction extends TimeRestriction {
  const factory _TimeRestriction({
    required final String id,
    required final String parentUserId,
    required final String childUserId,
    required final String packageName,
    required final String appName,
    required final String appIcon,
    required final bool isEnabled,
    required final int dailyTimeLimit,
    required final List<int> allowedDays,
    required final String startTime,
    required final String endTime,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TimeRestrictionImpl;
  const _TimeRestriction._() : super._();

  factory _TimeRestriction.fromJson(Map<String, dynamic> json) =
      _$TimeRestrictionImpl.fromJson;

  @override
  String get id;
  @override
  String get parentUserId;
  @override
  String get childUserId;
  @override
  String get packageName;
  @override
  String get appName;
  @override
  String get appIcon; // Base64 encoded icon
  @override
  bool get isEnabled;
  @override
  int get dailyTimeLimit; // in minutes
  @override
  List<int> get allowedDays; // 0-6 (Sunday-Saturday)
  @override
  String get startTime; // HH:mm format
  @override
  String get endTime; // HH:mm format
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TimeRestriction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeRestrictionImplCopyWith<_$TimeRestrictionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppControlSummary _$AppControlSummaryFromJson(Map<String, dynamic> json) {
  return _AppControlSummary.fromJson(json);
}

/// @nodoc
mixin _$AppControlSummary {
  String get id => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get totalBlockedApps => throw _privateConstructorUsedError;
  int get totalTimeRestrictedApps => throw _privateConstructorUsedError;
  int get totalBlockAttempts => throw _privateConstructorUsedError;
  List<String> get mostBlockedApps => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppControlSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppControlSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppControlSummaryCopyWith<AppControlSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppControlSummaryCopyWith<$Res> {
  factory $AppControlSummaryCopyWith(
    AppControlSummary value,
    $Res Function(AppControlSummary) then,
  ) = _$AppControlSummaryCopyWithImpl<$Res, AppControlSummary>;
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime date,
    int totalBlockedApps,
    int totalTimeRestrictedApps,
    int totalBlockAttempts,
    List<String> mostBlockedApps,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$AppControlSummaryCopyWithImpl<$Res, $Val extends AppControlSummary>
    implements $AppControlSummaryCopyWith<$Res> {
  _$AppControlSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppControlSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? date = null,
    Object? totalBlockedApps = null,
    Object? totalTimeRestrictedApps = null,
    Object? totalBlockAttempts = null,
    Object? mostBlockedApps = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            childUserId: null == childUserId
                ? _value.childUserId
                : childUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalBlockedApps: null == totalBlockedApps
                ? _value.totalBlockedApps
                : totalBlockedApps // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTimeRestrictedApps: null == totalTimeRestrictedApps
                ? _value.totalTimeRestrictedApps
                : totalTimeRestrictedApps // ignore: cast_nullable_to_non_nullable
                      as int,
            totalBlockAttempts: null == totalBlockAttempts
                ? _value.totalBlockAttempts
                : totalBlockAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            mostBlockedApps: null == mostBlockedApps
                ? _value.mostBlockedApps
                : mostBlockedApps // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppControlSummaryImplCopyWith<$Res>
    implements $AppControlSummaryCopyWith<$Res> {
  factory _$$AppControlSummaryImplCopyWith(
    _$AppControlSummaryImpl value,
    $Res Function(_$AppControlSummaryImpl) then,
  ) = __$$AppControlSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime date,
    int totalBlockedApps,
    int totalTimeRestrictedApps,
    int totalBlockAttempts,
    List<String> mostBlockedApps,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$AppControlSummaryImplCopyWithImpl<$Res>
    extends _$AppControlSummaryCopyWithImpl<$Res, _$AppControlSummaryImpl>
    implements _$$AppControlSummaryImplCopyWith<$Res> {
  __$$AppControlSummaryImplCopyWithImpl(
    _$AppControlSummaryImpl _value,
    $Res Function(_$AppControlSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppControlSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? date = null,
    Object? totalBlockedApps = null,
    Object? totalTimeRestrictedApps = null,
    Object? totalBlockAttempts = null,
    Object? mostBlockedApps = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AppControlSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        childUserId: null == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalBlockedApps: null == totalBlockedApps
            ? _value.totalBlockedApps
            : totalBlockedApps // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTimeRestrictedApps: null == totalTimeRestrictedApps
            ? _value.totalTimeRestrictedApps
            : totalTimeRestrictedApps // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBlockAttempts: null == totalBlockAttempts
            ? _value.totalBlockAttempts
            : totalBlockAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        mostBlockedApps: null == mostBlockedApps
            ? _value._mostBlockedApps
            : mostBlockedApps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppControlSummaryImpl extends _AppControlSummary {
  const _$AppControlSummaryImpl({
    required this.id,
    required this.childUserId,
    required this.date,
    required this.totalBlockedApps,
    required this.totalTimeRestrictedApps,
    required this.totalBlockAttempts,
    required final List<String> mostBlockedApps,
    required this.createdAt,
    required this.updatedAt,
  }) : _mostBlockedApps = mostBlockedApps,
       super._();

  factory _$AppControlSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppControlSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String childUserId;
  @override
  final DateTime date;
  @override
  final int totalBlockedApps;
  @override
  final int totalTimeRestrictedApps;
  @override
  final int totalBlockAttempts;
  final List<String> _mostBlockedApps;
  @override
  List<String> get mostBlockedApps {
    if (_mostBlockedApps is EqualUnmodifiableListView) return _mostBlockedApps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mostBlockedApps);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AppControlSummary(id: $id, childUserId: $childUserId, date: $date, totalBlockedApps: $totalBlockedApps, totalTimeRestrictedApps: $totalTimeRestrictedApps, totalBlockAttempts: $totalBlockAttempts, mostBlockedApps: $mostBlockedApps, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppControlSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalBlockedApps, totalBlockedApps) ||
                other.totalBlockedApps == totalBlockedApps) &&
            (identical(
                  other.totalTimeRestrictedApps,
                  totalTimeRestrictedApps,
                ) ||
                other.totalTimeRestrictedApps == totalTimeRestrictedApps) &&
            (identical(other.totalBlockAttempts, totalBlockAttempts) ||
                other.totalBlockAttempts == totalBlockAttempts) &&
            const DeepCollectionEquality().equals(
              other._mostBlockedApps,
              _mostBlockedApps,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    childUserId,
    date,
    totalBlockedApps,
    totalTimeRestrictedApps,
    totalBlockAttempts,
    const DeepCollectionEquality().hash(_mostBlockedApps),
    createdAt,
    updatedAt,
  );

  /// Create a copy of AppControlSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppControlSummaryImplCopyWith<_$AppControlSummaryImpl> get copyWith =>
      __$$AppControlSummaryImplCopyWithImpl<_$AppControlSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppControlSummaryImplToJson(this);
  }
}

abstract class _AppControlSummary extends AppControlSummary {
  const factory _AppControlSummary({
    required final String id,
    required final String childUserId,
    required final DateTime date,
    required final int totalBlockedApps,
    required final int totalTimeRestrictedApps,
    required final int totalBlockAttempts,
    required final List<String> mostBlockedApps,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AppControlSummaryImpl;
  const _AppControlSummary._() : super._();

  factory _AppControlSummary.fromJson(Map<String, dynamic> json) =
      _$AppControlSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get childUserId;
  @override
  DateTime get date;
  @override
  int get totalBlockedApps;
  @override
  int get totalTimeRestrictedApps;
  @override
  int get totalBlockAttempts;
  @override
  List<String> get mostBlockedApps;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AppControlSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppControlSummaryImplCopyWith<_$AppControlSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlockAttemptLog _$BlockAttemptLogFromJson(Map<String, dynamic> json) {
  return _BlockAttemptLog.fromJson(json);
}

/// @nodoc
mixin _$BlockAttemptLog {
  String get id => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  DateTime get attemptTime => throw _privateConstructorUsedError;
  String get blockReason => throw _privateConstructorUsedError;
  bool get wasBlocked => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BlockAttemptLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockAttemptLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockAttemptLogCopyWith<BlockAttemptLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockAttemptLogCopyWith<$Res> {
  factory $BlockAttemptLogCopyWith(
    BlockAttemptLog value,
    $Res Function(BlockAttemptLog) then,
  ) = _$BlockAttemptLogCopyWithImpl<$Res, BlockAttemptLog>;
  @useResult
  $Res call({
    String id,
    String childUserId,
    String packageName,
    String appName,
    DateTime attemptTime,
    String blockReason,
    bool wasBlocked,
    DateTime createdAt,
  });
}

/// @nodoc
class _$BlockAttemptLogCopyWithImpl<$Res, $Val extends BlockAttemptLog>
    implements $BlockAttemptLogCopyWith<$Res> {
  _$BlockAttemptLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockAttemptLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? attemptTime = null,
    Object? blockReason = null,
    Object? wasBlocked = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            childUserId: null == childUserId
                ? _value.childUserId
                : childUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            packageName: null == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String,
            appName: null == appName
                ? _value.appName
                : appName // ignore: cast_nullable_to_non_nullable
                      as String,
            attemptTime: null == attemptTime
                ? _value.attemptTime
                : attemptTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            blockReason: null == blockReason
                ? _value.blockReason
                : blockReason // ignore: cast_nullable_to_non_nullable
                      as String,
            wasBlocked: null == wasBlocked
                ? _value.wasBlocked
                : wasBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockAttemptLogImplCopyWith<$Res>
    implements $BlockAttemptLogCopyWith<$Res> {
  factory _$$BlockAttemptLogImplCopyWith(
    _$BlockAttemptLogImpl value,
    $Res Function(_$BlockAttemptLogImpl) then,
  ) = __$$BlockAttemptLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childUserId,
    String packageName,
    String appName,
    DateTime attemptTime,
    String blockReason,
    bool wasBlocked,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$BlockAttemptLogImplCopyWithImpl<$Res>
    extends _$BlockAttemptLogCopyWithImpl<$Res, _$BlockAttemptLogImpl>
    implements _$$BlockAttemptLogImplCopyWith<$Res> {
  __$$BlockAttemptLogImplCopyWithImpl(
    _$BlockAttemptLogImpl _value,
    $Res Function(_$BlockAttemptLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockAttemptLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? attemptTime = null,
    Object? blockReason = null,
    Object? wasBlocked = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BlockAttemptLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        childUserId: null == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        packageName: null == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String,
        appName: null == appName
            ? _value.appName
            : appName // ignore: cast_nullable_to_non_nullable
                  as String,
        attemptTime: null == attemptTime
            ? _value.attemptTime
            : attemptTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        blockReason: null == blockReason
            ? _value.blockReason
            : blockReason // ignore: cast_nullable_to_non_nullable
                  as String,
        wasBlocked: null == wasBlocked
            ? _value.wasBlocked
            : wasBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockAttemptLogImpl extends _BlockAttemptLog {
  const _$BlockAttemptLogImpl({
    required this.id,
    required this.childUserId,
    required this.packageName,
    required this.appName,
    required this.attemptTime,
    required this.blockReason,
    required this.wasBlocked,
    required this.createdAt,
  }) : super._();

  factory _$BlockAttemptLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockAttemptLogImplFromJson(json);

  @override
  final String id;
  @override
  final String childUserId;
  @override
  final String packageName;
  @override
  final String appName;
  @override
  final DateTime attemptTime;
  @override
  final String blockReason;
  @override
  final bool wasBlocked;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BlockAttemptLog(id: $id, childUserId: $childUserId, packageName: $packageName, appName: $appName, attemptTime: $attemptTime, blockReason: $blockReason, wasBlocked: $wasBlocked, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockAttemptLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.attemptTime, attemptTime) ||
                other.attemptTime == attemptTime) &&
            (identical(other.blockReason, blockReason) ||
                other.blockReason == blockReason) &&
            (identical(other.wasBlocked, wasBlocked) ||
                other.wasBlocked == wasBlocked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    childUserId,
    packageName,
    appName,
    attemptTime,
    blockReason,
    wasBlocked,
    createdAt,
  );

  /// Create a copy of BlockAttemptLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockAttemptLogImplCopyWith<_$BlockAttemptLogImpl> get copyWith =>
      __$$BlockAttemptLogImplCopyWithImpl<_$BlockAttemptLogImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockAttemptLogImplToJson(this);
  }
}

abstract class _BlockAttemptLog extends BlockAttemptLog {
  const factory _BlockAttemptLog({
    required final String id,
    required final String childUserId,
    required final String packageName,
    required final String appName,
    required final DateTime attemptTime,
    required final String blockReason,
    required final bool wasBlocked,
    required final DateTime createdAt,
  }) = _$BlockAttemptLogImpl;
  const _BlockAttemptLog._() : super._();

  factory _BlockAttemptLog.fromJson(Map<String, dynamic> json) =
      _$BlockAttemptLogImpl.fromJson;

  @override
  String get id;
  @override
  String get childUserId;
  @override
  String get packageName;
  @override
  String get appName;
  @override
  DateTime get attemptTime;
  @override
  String get blockReason;
  @override
  bool get wasBlocked;
  @override
  DateTime get createdAt;

  /// Create a copy of BlockAttemptLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockAttemptLogImplCopyWith<_$BlockAttemptLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
