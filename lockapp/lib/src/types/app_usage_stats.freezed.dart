// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_usage_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUsageStats _$AppUsageStatsFromJson(Map<String, dynamic> json) {
  return _AppUsageStats.fromJson(json);
}

/// @nodoc
mixin _$AppUsageStats {
  String get id => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  String get appIcon =>
      throw _privateConstructorUsedError; // Base64 encoded icon
  DateTime get date => throw _privateConstructorUsedError;
  int get totalTimeInForeground =>
      throw _privateConstructorUsedError; // milliseconds
  int get launchCount => throw _privateConstructorUsedError;
  DateTime get firstTimeStamp => throw _privateConstructorUsedError;
  DateTime get lastTimeStamp => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppUsageStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUsageStatsCopyWith<AppUsageStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUsageStatsCopyWith<$Res> {
  factory $AppUsageStatsCopyWith(
    AppUsageStats value,
    $Res Function(AppUsageStats) then,
  ) = _$AppUsageStatsCopyWithImpl<$Res, AppUsageStats>;
  @useResult
  $Res call({
    String id,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    DateTime date,
    int totalTimeInForeground,
    int launchCount,
    DateTime firstTimeStamp,
    DateTime lastTimeStamp,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$AppUsageStatsCopyWithImpl<$Res, $Val extends AppUsageStats>
    implements $AppUsageStatsCopyWith<$Res> {
  _$AppUsageStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? date = null,
    Object? totalTimeInForeground = null,
    Object? launchCount = null,
    Object? firstTimeStamp = null,
    Object? lastTimeStamp = null,
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
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalTimeInForeground: null == totalTimeInForeground
                ? _value.totalTimeInForeground
                : totalTimeInForeground // ignore: cast_nullable_to_non_nullable
                      as int,
            launchCount: null == launchCount
                ? _value.launchCount
                : launchCount // ignore: cast_nullable_to_non_nullable
                      as int,
            firstTimeStamp: null == firstTimeStamp
                ? _value.firstTimeStamp
                : firstTimeStamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastTimeStamp: null == lastTimeStamp
                ? _value.lastTimeStamp
                : lastTimeStamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$AppUsageStatsImplCopyWith<$Res>
    implements $AppUsageStatsCopyWith<$Res> {
  factory _$$AppUsageStatsImplCopyWith(
    _$AppUsageStatsImpl value,
    $Res Function(_$AppUsageStatsImpl) then,
  ) = __$$AppUsageStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childUserId,
    String packageName,
    String appName,
    String appIcon,
    DateTime date,
    int totalTimeInForeground,
    int launchCount,
    DateTime firstTimeStamp,
    DateTime lastTimeStamp,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$AppUsageStatsImplCopyWithImpl<$Res>
    extends _$AppUsageStatsCopyWithImpl<$Res, _$AppUsageStatsImpl>
    implements _$$AppUsageStatsImplCopyWith<$Res> {
  __$$AppUsageStatsImplCopyWithImpl(
    _$AppUsageStatsImpl _value,
    $Res Function(_$AppUsageStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? packageName = null,
    Object? appName = null,
    Object? appIcon = null,
    Object? date = null,
    Object? totalTimeInForeground = null,
    Object? launchCount = null,
    Object? firstTimeStamp = null,
    Object? lastTimeStamp = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AppUsageStatsImpl(
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
        appIcon: null == appIcon
            ? _value.appIcon
            : appIcon // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalTimeInForeground: null == totalTimeInForeground
            ? _value.totalTimeInForeground
            : totalTimeInForeground // ignore: cast_nullable_to_non_nullable
                  as int,
        launchCount: null == launchCount
            ? _value.launchCount
            : launchCount // ignore: cast_nullable_to_non_nullable
                  as int,
        firstTimeStamp: null == firstTimeStamp
            ? _value.firstTimeStamp
            : firstTimeStamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastTimeStamp: null == lastTimeStamp
            ? _value.lastTimeStamp
            : lastTimeStamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$AppUsageStatsImpl extends _AppUsageStats {
  const _$AppUsageStatsImpl({
    required this.id,
    required this.childUserId,
    required this.packageName,
    required this.appName,
    required this.appIcon,
    required this.date,
    required this.totalTimeInForeground,
    required this.launchCount,
    required this.firstTimeStamp,
    required this.lastTimeStamp,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$AppUsageStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUsageStatsImplFromJson(json);

  @override
  final String id;
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
  final DateTime date;
  @override
  final int totalTimeInForeground;
  // milliseconds
  @override
  final int launchCount;
  @override
  final DateTime firstTimeStamp;
  @override
  final DateTime lastTimeStamp;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AppUsageStats(id: $id, childUserId: $childUserId, packageName: $packageName, appName: $appName, appIcon: $appIcon, date: $date, totalTimeInForeground: $totalTimeInForeground, launchCount: $launchCount, firstTimeStamp: $firstTimeStamp, lastTimeStamp: $lastTimeStamp, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUsageStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.appIcon, appIcon) || other.appIcon == appIcon) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalTimeInForeground, totalTimeInForeground) ||
                other.totalTimeInForeground == totalTimeInForeground) &&
            (identical(other.launchCount, launchCount) ||
                other.launchCount == launchCount) &&
            (identical(other.firstTimeStamp, firstTimeStamp) ||
                other.firstTimeStamp == firstTimeStamp) &&
            (identical(other.lastTimeStamp, lastTimeStamp) ||
                other.lastTimeStamp == lastTimeStamp) &&
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
    packageName,
    appName,
    appIcon,
    date,
    totalTimeInForeground,
    launchCount,
    firstTimeStamp,
    lastTimeStamp,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AppUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUsageStatsImplCopyWith<_$AppUsageStatsImpl> get copyWith =>
      __$$AppUsageStatsImplCopyWithImpl<_$AppUsageStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUsageStatsImplToJson(this);
  }
}

abstract class _AppUsageStats extends AppUsageStats {
  const factory _AppUsageStats({
    required final String id,
    required final String childUserId,
    required final String packageName,
    required final String appName,
    required final String appIcon,
    required final DateTime date,
    required final int totalTimeInForeground,
    required final int launchCount,
    required final DateTime firstTimeStamp,
    required final DateTime lastTimeStamp,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AppUsageStatsImpl;
  const _AppUsageStats._() : super._();

  factory _AppUsageStats.fromJson(Map<String, dynamic> json) =
      _$AppUsageStatsImpl.fromJson;

  @override
  String get id;
  @override
  String get childUserId;
  @override
  String get packageName;
  @override
  String get appName;
  @override
  String get appIcon; // Base64 encoded icon
  @override
  DateTime get date;
  @override
  int get totalTimeInForeground; // milliseconds
  @override
  int get launchCount;
  @override
  DateTime get firstTimeStamp;
  @override
  DateTime get lastTimeStamp;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AppUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUsageStatsImplCopyWith<_$AppUsageStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyUsageSummary _$DailyUsageSummaryFromJson(Map<String, dynamic> json) {
  return _DailyUsageSummary.fromJson(json);
}

/// @nodoc
mixin _$DailyUsageSummary {
  String get id => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get totalScreenTime => throw _privateConstructorUsedError; // milliseconds
  int get totalAppLaunches => throw _privateConstructorUsedError;
  int get uniqueAppsUsed => throw _privateConstructorUsedError;
  String get mostUsedApp => throw _privateConstructorUsedError;
  int get mostUsedAppTime => throw _privateConstructorUsedError;
  List<AppUsageStats> get topApps => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DailyUsageSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyUsageSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyUsageSummaryCopyWith<DailyUsageSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyUsageSummaryCopyWith<$Res> {
  factory $DailyUsageSummaryCopyWith(
    DailyUsageSummary value,
    $Res Function(DailyUsageSummary) then,
  ) = _$DailyUsageSummaryCopyWithImpl<$Res, DailyUsageSummary>;
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime date,
    int totalScreenTime,
    int totalAppLaunches,
    int uniqueAppsUsed,
    String mostUsedApp,
    int mostUsedAppTime,
    List<AppUsageStats> topApps,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$DailyUsageSummaryCopyWithImpl<$Res, $Val extends DailyUsageSummary>
    implements $DailyUsageSummaryCopyWith<$Res> {
  _$DailyUsageSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyUsageSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? date = null,
    Object? totalScreenTime = null,
    Object? totalAppLaunches = null,
    Object? uniqueAppsUsed = null,
    Object? mostUsedApp = null,
    Object? mostUsedAppTime = null,
    Object? topApps = null,
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
            totalScreenTime: null == totalScreenTime
                ? _value.totalScreenTime
                : totalScreenTime // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAppLaunches: null == totalAppLaunches
                ? _value.totalAppLaunches
                : totalAppLaunches // ignore: cast_nullable_to_non_nullable
                      as int,
            uniqueAppsUsed: null == uniqueAppsUsed
                ? _value.uniqueAppsUsed
                : uniqueAppsUsed // ignore: cast_nullable_to_non_nullable
                      as int,
            mostUsedApp: null == mostUsedApp
                ? _value.mostUsedApp
                : mostUsedApp // ignore: cast_nullable_to_non_nullable
                      as String,
            mostUsedAppTime: null == mostUsedAppTime
                ? _value.mostUsedAppTime
                : mostUsedAppTime // ignore: cast_nullable_to_non_nullable
                      as int,
            topApps: null == topApps
                ? _value.topApps
                : topApps // ignore: cast_nullable_to_non_nullable
                      as List<AppUsageStats>,
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
abstract class _$$DailyUsageSummaryImplCopyWith<$Res>
    implements $DailyUsageSummaryCopyWith<$Res> {
  factory _$$DailyUsageSummaryImplCopyWith(
    _$DailyUsageSummaryImpl value,
    $Res Function(_$DailyUsageSummaryImpl) then,
  ) = __$$DailyUsageSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime date,
    int totalScreenTime,
    int totalAppLaunches,
    int uniqueAppsUsed,
    String mostUsedApp,
    int mostUsedAppTime,
    List<AppUsageStats> topApps,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$DailyUsageSummaryImplCopyWithImpl<$Res>
    extends _$DailyUsageSummaryCopyWithImpl<$Res, _$DailyUsageSummaryImpl>
    implements _$$DailyUsageSummaryImplCopyWith<$Res> {
  __$$DailyUsageSummaryImplCopyWithImpl(
    _$DailyUsageSummaryImpl _value,
    $Res Function(_$DailyUsageSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyUsageSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? date = null,
    Object? totalScreenTime = null,
    Object? totalAppLaunches = null,
    Object? uniqueAppsUsed = null,
    Object? mostUsedApp = null,
    Object? mostUsedAppTime = null,
    Object? topApps = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DailyUsageSummaryImpl(
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
        totalScreenTime: null == totalScreenTime
            ? _value.totalScreenTime
            : totalScreenTime // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAppLaunches: null == totalAppLaunches
            ? _value.totalAppLaunches
            : totalAppLaunches // ignore: cast_nullable_to_non_nullable
                  as int,
        uniqueAppsUsed: null == uniqueAppsUsed
            ? _value.uniqueAppsUsed
            : uniqueAppsUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        mostUsedApp: null == mostUsedApp
            ? _value.mostUsedApp
            : mostUsedApp // ignore: cast_nullable_to_non_nullable
                  as String,
        mostUsedAppTime: null == mostUsedAppTime
            ? _value.mostUsedAppTime
            : mostUsedAppTime // ignore: cast_nullable_to_non_nullable
                  as int,
        topApps: null == topApps
            ? _value._topApps
            : topApps // ignore: cast_nullable_to_non_nullable
                  as List<AppUsageStats>,
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
class _$DailyUsageSummaryImpl extends _DailyUsageSummary {
  const _$DailyUsageSummaryImpl({
    required this.id,
    required this.childUserId,
    required this.date,
    required this.totalScreenTime,
    required this.totalAppLaunches,
    required this.uniqueAppsUsed,
    required this.mostUsedApp,
    required this.mostUsedAppTime,
    required final List<AppUsageStats> topApps,
    required this.createdAt,
    required this.updatedAt,
  }) : _topApps = topApps,
       super._();

  factory _$DailyUsageSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyUsageSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String childUserId;
  @override
  final DateTime date;
  @override
  final int totalScreenTime;
  // milliseconds
  @override
  final int totalAppLaunches;
  @override
  final int uniqueAppsUsed;
  @override
  final String mostUsedApp;
  @override
  final int mostUsedAppTime;
  final List<AppUsageStats> _topApps;
  @override
  List<AppUsageStats> get topApps {
    if (_topApps is EqualUnmodifiableListView) return _topApps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topApps);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DailyUsageSummary(id: $id, childUserId: $childUserId, date: $date, totalScreenTime: $totalScreenTime, totalAppLaunches: $totalAppLaunches, uniqueAppsUsed: $uniqueAppsUsed, mostUsedApp: $mostUsedApp, mostUsedAppTime: $mostUsedAppTime, topApps: $topApps, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyUsageSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalScreenTime, totalScreenTime) ||
                other.totalScreenTime == totalScreenTime) &&
            (identical(other.totalAppLaunches, totalAppLaunches) ||
                other.totalAppLaunches == totalAppLaunches) &&
            (identical(other.uniqueAppsUsed, uniqueAppsUsed) ||
                other.uniqueAppsUsed == uniqueAppsUsed) &&
            (identical(other.mostUsedApp, mostUsedApp) ||
                other.mostUsedApp == mostUsedApp) &&
            (identical(other.mostUsedAppTime, mostUsedAppTime) ||
                other.mostUsedAppTime == mostUsedAppTime) &&
            const DeepCollectionEquality().equals(other._topApps, _topApps) &&
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
    totalScreenTime,
    totalAppLaunches,
    uniqueAppsUsed,
    mostUsedApp,
    mostUsedAppTime,
    const DeepCollectionEquality().hash(_topApps),
    createdAt,
    updatedAt,
  );

  /// Create a copy of DailyUsageSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyUsageSummaryImplCopyWith<_$DailyUsageSummaryImpl> get copyWith =>
      __$$DailyUsageSummaryImplCopyWithImpl<_$DailyUsageSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyUsageSummaryImplToJson(this);
  }
}

abstract class _DailyUsageSummary extends DailyUsageSummary {
  const factory _DailyUsageSummary({
    required final String id,
    required final String childUserId,
    required final DateTime date,
    required final int totalScreenTime,
    required final int totalAppLaunches,
    required final int uniqueAppsUsed,
    required final String mostUsedApp,
    required final int mostUsedAppTime,
    required final List<AppUsageStats> topApps,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$DailyUsageSummaryImpl;
  const _DailyUsageSummary._() : super._();

  factory _DailyUsageSummary.fromJson(Map<String, dynamic> json) =
      _$DailyUsageSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get childUserId;
  @override
  DateTime get date;
  @override
  int get totalScreenTime; // milliseconds
  @override
  int get totalAppLaunches;
  @override
  int get uniqueAppsUsed;
  @override
  String get mostUsedApp;
  @override
  int get mostUsedAppTime;
  @override
  List<AppUsageStats> get topApps;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of DailyUsageSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyUsageSummaryImplCopyWith<_$DailyUsageSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyUsageReport _$WeeklyUsageReportFromJson(Map<String, dynamic> json) {
  return _WeeklyUsageReport.fromJson(json);
}

/// @nodoc
mixin _$WeeklyUsageReport {
  String get id => throw _privateConstructorUsedError;
  String get childUserId => throw _privateConstructorUsedError;
  DateTime get weekStart => throw _privateConstructorUsedError;
  DateTime get weekEnd => throw _privateConstructorUsedError;
  int get totalScreenTime => throw _privateConstructorUsedError; // milliseconds
  int get averageDailyScreenTime => throw _privateConstructorUsedError;
  int get totalAppLaunches => throw _privateConstructorUsedError;
  int get averageDailyLaunches => throw _privateConstructorUsedError;
  List<DailyUsageSummary> get dailySummaries =>
      throw _privateConstructorUsedError;
  List<AppUsageStats> get topAppsWeekly => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WeeklyUsageReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyUsageReportCopyWith<WeeklyUsageReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyUsageReportCopyWith<$Res> {
  factory $WeeklyUsageReportCopyWith(
    WeeklyUsageReport value,
    $Res Function(WeeklyUsageReport) then,
  ) = _$WeeklyUsageReportCopyWithImpl<$Res, WeeklyUsageReport>;
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime weekStart,
    DateTime weekEnd,
    int totalScreenTime,
    int averageDailyScreenTime,
    int totalAppLaunches,
    int averageDailyLaunches,
    List<DailyUsageSummary> dailySummaries,
    List<AppUsageStats> topAppsWeekly,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$WeeklyUsageReportCopyWithImpl<$Res, $Val extends WeeklyUsageReport>
    implements $WeeklyUsageReportCopyWith<$Res> {
  _$WeeklyUsageReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? totalScreenTime = null,
    Object? averageDailyScreenTime = null,
    Object? totalAppLaunches = null,
    Object? averageDailyLaunches = null,
    Object? dailySummaries = null,
    Object? topAppsWeekly = null,
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
            weekStart: null == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weekEnd: null == weekEnd
                ? _value.weekEnd
                : weekEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalScreenTime: null == totalScreenTime
                ? _value.totalScreenTime
                : totalScreenTime // ignore: cast_nullable_to_non_nullable
                      as int,
            averageDailyScreenTime: null == averageDailyScreenTime
                ? _value.averageDailyScreenTime
                : averageDailyScreenTime // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAppLaunches: null == totalAppLaunches
                ? _value.totalAppLaunches
                : totalAppLaunches // ignore: cast_nullable_to_non_nullable
                      as int,
            averageDailyLaunches: null == averageDailyLaunches
                ? _value.averageDailyLaunches
                : averageDailyLaunches // ignore: cast_nullable_to_non_nullable
                      as int,
            dailySummaries: null == dailySummaries
                ? _value.dailySummaries
                : dailySummaries // ignore: cast_nullable_to_non_nullable
                      as List<DailyUsageSummary>,
            topAppsWeekly: null == topAppsWeekly
                ? _value.topAppsWeekly
                : topAppsWeekly // ignore: cast_nullable_to_non_nullable
                      as List<AppUsageStats>,
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
abstract class _$$WeeklyUsageReportImplCopyWith<$Res>
    implements $WeeklyUsageReportCopyWith<$Res> {
  factory _$$WeeklyUsageReportImplCopyWith(
    _$WeeklyUsageReportImpl value,
    $Res Function(_$WeeklyUsageReportImpl) then,
  ) = __$$WeeklyUsageReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childUserId,
    DateTime weekStart,
    DateTime weekEnd,
    int totalScreenTime,
    int averageDailyScreenTime,
    int totalAppLaunches,
    int averageDailyLaunches,
    List<DailyUsageSummary> dailySummaries,
    List<AppUsageStats> topAppsWeekly,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$WeeklyUsageReportImplCopyWithImpl<$Res>
    extends _$WeeklyUsageReportCopyWithImpl<$Res, _$WeeklyUsageReportImpl>
    implements _$$WeeklyUsageReportImplCopyWith<$Res> {
  __$$WeeklyUsageReportImplCopyWithImpl(
    _$WeeklyUsageReportImpl _value,
    $Res Function(_$WeeklyUsageReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childUserId = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? totalScreenTime = null,
    Object? averageDailyScreenTime = null,
    Object? totalAppLaunches = null,
    Object? averageDailyLaunches = null,
    Object? dailySummaries = null,
    Object? topAppsWeekly = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WeeklyUsageReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        childUserId: null == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        weekStart: null == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weekEnd: null == weekEnd
            ? _value.weekEnd
            : weekEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalScreenTime: null == totalScreenTime
            ? _value.totalScreenTime
            : totalScreenTime // ignore: cast_nullable_to_non_nullable
                  as int,
        averageDailyScreenTime: null == averageDailyScreenTime
            ? _value.averageDailyScreenTime
            : averageDailyScreenTime // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAppLaunches: null == totalAppLaunches
            ? _value.totalAppLaunches
            : totalAppLaunches // ignore: cast_nullable_to_non_nullable
                  as int,
        averageDailyLaunches: null == averageDailyLaunches
            ? _value.averageDailyLaunches
            : averageDailyLaunches // ignore: cast_nullable_to_non_nullable
                  as int,
        dailySummaries: null == dailySummaries
            ? _value._dailySummaries
            : dailySummaries // ignore: cast_nullable_to_non_nullable
                  as List<DailyUsageSummary>,
        topAppsWeekly: null == topAppsWeekly
            ? _value._topAppsWeekly
            : topAppsWeekly // ignore: cast_nullable_to_non_nullable
                  as List<AppUsageStats>,
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
class _$WeeklyUsageReportImpl extends _WeeklyUsageReport {
  const _$WeeklyUsageReportImpl({
    required this.id,
    required this.childUserId,
    required this.weekStart,
    required this.weekEnd,
    required this.totalScreenTime,
    required this.averageDailyScreenTime,
    required this.totalAppLaunches,
    required this.averageDailyLaunches,
    required final List<DailyUsageSummary> dailySummaries,
    required final List<AppUsageStats> topAppsWeekly,
    required this.createdAt,
    required this.updatedAt,
  }) : _dailySummaries = dailySummaries,
       _topAppsWeekly = topAppsWeekly,
       super._();

  factory _$WeeklyUsageReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyUsageReportImplFromJson(json);

  @override
  final String id;
  @override
  final String childUserId;
  @override
  final DateTime weekStart;
  @override
  final DateTime weekEnd;
  @override
  final int totalScreenTime;
  // milliseconds
  @override
  final int averageDailyScreenTime;
  @override
  final int totalAppLaunches;
  @override
  final int averageDailyLaunches;
  final List<DailyUsageSummary> _dailySummaries;
  @override
  List<DailyUsageSummary> get dailySummaries {
    if (_dailySummaries is EqualUnmodifiableListView) return _dailySummaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailySummaries);
  }

  final List<AppUsageStats> _topAppsWeekly;
  @override
  List<AppUsageStats> get topAppsWeekly {
    if (_topAppsWeekly is EqualUnmodifiableListView) return _topAppsWeekly;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topAppsWeekly);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WeeklyUsageReport(id: $id, childUserId: $childUserId, weekStart: $weekStart, weekEnd: $weekEnd, totalScreenTime: $totalScreenTime, averageDailyScreenTime: $averageDailyScreenTime, totalAppLaunches: $totalAppLaunches, averageDailyLaunches: $averageDailyLaunches, dailySummaries: $dailySummaries, topAppsWeekly: $topAppsWeekly, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyUsageReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd) &&
            (identical(other.totalScreenTime, totalScreenTime) ||
                other.totalScreenTime == totalScreenTime) &&
            (identical(other.averageDailyScreenTime, averageDailyScreenTime) ||
                other.averageDailyScreenTime == averageDailyScreenTime) &&
            (identical(other.totalAppLaunches, totalAppLaunches) ||
                other.totalAppLaunches == totalAppLaunches) &&
            (identical(other.averageDailyLaunches, averageDailyLaunches) ||
                other.averageDailyLaunches == averageDailyLaunches) &&
            const DeepCollectionEquality().equals(
              other._dailySummaries,
              _dailySummaries,
            ) &&
            const DeepCollectionEquality().equals(
              other._topAppsWeekly,
              _topAppsWeekly,
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
    weekStart,
    weekEnd,
    totalScreenTime,
    averageDailyScreenTime,
    totalAppLaunches,
    averageDailyLaunches,
    const DeepCollectionEquality().hash(_dailySummaries),
    const DeepCollectionEquality().hash(_topAppsWeekly),
    createdAt,
    updatedAt,
  );

  /// Create a copy of WeeklyUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyUsageReportImplCopyWith<_$WeeklyUsageReportImpl> get copyWith =>
      __$$WeeklyUsageReportImplCopyWithImpl<_$WeeklyUsageReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyUsageReportImplToJson(this);
  }
}

abstract class _WeeklyUsageReport extends WeeklyUsageReport {
  const factory _WeeklyUsageReport({
    required final String id,
    required final String childUserId,
    required final DateTime weekStart,
    required final DateTime weekEnd,
    required final int totalScreenTime,
    required final int averageDailyScreenTime,
    required final int totalAppLaunches,
    required final int averageDailyLaunches,
    required final List<DailyUsageSummary> dailySummaries,
    required final List<AppUsageStats> topAppsWeekly,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$WeeklyUsageReportImpl;
  const _WeeklyUsageReport._() : super._();

  factory _WeeklyUsageReport.fromJson(Map<String, dynamic> json) =
      _$WeeklyUsageReportImpl.fromJson;

  @override
  String get id;
  @override
  String get childUserId;
  @override
  DateTime get weekStart;
  @override
  DateTime get weekEnd;
  @override
  int get totalScreenTime; // milliseconds
  @override
  int get averageDailyScreenTime;
  @override
  int get totalAppLaunches;
  @override
  int get averageDailyLaunches;
  @override
  List<DailyUsageSummary> get dailySummaries;
  @override
  List<AppUsageStats> get topAppsWeekly;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of WeeklyUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyUsageReportImplCopyWith<_$WeeklyUsageReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
