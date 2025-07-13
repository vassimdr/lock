// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PairingRequest _$PairingRequestFromJson(Map<String, dynamic> json) {
  return _PairingRequest.fromJson(json);
}

/// @nodoc
mixin _$PairingRequest {
  String get id => throw _privateConstructorUsedError;
  String get parentUserId => throw _privateConstructorUsedError;
  String get parentDeviceId => throw _privateConstructorUsedError;
  String get parentName => throw _privateConstructorUsedError;
  String get qrCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  bool get isUsed => throw _privateConstructorUsedError;
  String? get childUserId => throw _privateConstructorUsedError;
  String? get childDeviceId => throw _privateConstructorUsedError;
  String? get childName => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;

  /// Serializes this PairingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairingRequestCopyWith<PairingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingRequestCopyWith<$Res> {
  factory $PairingRequestCopyWith(
    PairingRequest value,
    $Res Function(PairingRequest) then,
  ) = _$PairingRequestCopyWithImpl<$Res, PairingRequest>;
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String parentDeviceId,
    String parentName,
    String qrCode,
    DateTime createdAt,
    DateTime expiresAt,
    bool isUsed,
    String? childUserId,
    String? childDeviceId,
    String? childName,
    DateTime? acceptedAt,
  });
}

/// @nodoc
class _$PairingRequestCopyWithImpl<$Res, $Val extends PairingRequest>
    implements $PairingRequestCopyWith<$Res> {
  _$PairingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? parentDeviceId = null,
    Object? parentName = null,
    Object? qrCode = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isUsed = null,
    Object? childUserId = freezed,
    Object? childDeviceId = freezed,
    Object? childName = freezed,
    Object? acceptedAt = freezed,
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
            parentDeviceId: null == parentDeviceId
                ? _value.parentDeviceId
                : parentDeviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            parentName: null == parentName
                ? _value.parentName
                : parentName // ignore: cast_nullable_to_non_nullable
                      as String,
            qrCode: null == qrCode
                ? _value.qrCode
                : qrCode // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isUsed: null == isUsed
                ? _value.isUsed
                : isUsed // ignore: cast_nullable_to_non_nullable
                      as bool,
            childUserId: freezed == childUserId
                ? _value.childUserId
                : childUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childDeviceId: freezed == childDeviceId
                ? _value.childDeviceId
                : childDeviceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childName: freezed == childName
                ? _value.childName
                : childName // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairingRequestImplCopyWith<$Res>
    implements $PairingRequestCopyWith<$Res> {
  factory _$$PairingRequestImplCopyWith(
    _$PairingRequestImpl value,
    $Res Function(_$PairingRequestImpl) then,
  ) = __$$PairingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String parentUserId,
    String parentDeviceId,
    String parentName,
    String qrCode,
    DateTime createdAt,
    DateTime expiresAt,
    bool isUsed,
    String? childUserId,
    String? childDeviceId,
    String? childName,
    DateTime? acceptedAt,
  });
}

/// @nodoc
class __$$PairingRequestImplCopyWithImpl<$Res>
    extends _$PairingRequestCopyWithImpl<$Res, _$PairingRequestImpl>
    implements _$$PairingRequestImplCopyWith<$Res> {
  __$$PairingRequestImplCopyWithImpl(
    _$PairingRequestImpl _value,
    $Res Function(_$PairingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentUserId = null,
    Object? parentDeviceId = null,
    Object? parentName = null,
    Object? qrCode = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isUsed = null,
    Object? childUserId = freezed,
    Object? childDeviceId = freezed,
    Object? childName = freezed,
    Object? acceptedAt = freezed,
  }) {
    return _then(
      _$PairingRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentUserId: null == parentUserId
            ? _value.parentUserId
            : parentUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentDeviceId: null == parentDeviceId
            ? _value.parentDeviceId
            : parentDeviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentName: null == parentName
            ? _value.parentName
            : parentName // ignore: cast_nullable_to_non_nullable
                  as String,
        qrCode: null == qrCode
            ? _value.qrCode
            : qrCode // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isUsed: null == isUsed
            ? _value.isUsed
            : isUsed // ignore: cast_nullable_to_non_nullable
                  as bool,
        childUserId: freezed == childUserId
            ? _value.childUserId
            : childUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childDeviceId: freezed == childDeviceId
            ? _value.childDeviceId
            : childDeviceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childName: freezed == childName
            ? _value.childName
            : childName // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PairingRequestImpl extends _PairingRequest {
  const _$PairingRequestImpl({
    required this.id,
    required this.parentUserId,
    required this.parentDeviceId,
    required this.parentName,
    required this.qrCode,
    required this.createdAt,
    required this.expiresAt,
    this.isUsed = false,
    this.childUserId,
    this.childDeviceId,
    this.childName,
    this.acceptedAt,
  }) : super._();

  factory _$PairingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairingRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String parentUserId;
  @override
  final String parentDeviceId;
  @override
  final String parentName;
  @override
  final String qrCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  @JsonKey()
  final bool isUsed;
  @override
  final String? childUserId;
  @override
  final String? childDeviceId;
  @override
  final String? childName;
  @override
  final DateTime? acceptedAt;

  @override
  String toString() {
    return 'PairingRequest(id: $id, parentUserId: $parentUserId, parentDeviceId: $parentDeviceId, parentName: $parentName, qrCode: $qrCode, createdAt: $createdAt, expiresAt: $expiresAt, isUsed: $isUsed, childUserId: $childUserId, childDeviceId: $childDeviceId, childName: $childName, acceptedAt: $acceptedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairingRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentUserId, parentUserId) ||
                other.parentUserId == parentUserId) &&
            (identical(other.parentDeviceId, parentDeviceId) ||
                other.parentDeviceId == parentDeviceId) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isUsed, isUsed) || other.isUsed == isUsed) &&
            (identical(other.childUserId, childUserId) ||
                other.childUserId == childUserId) &&
            (identical(other.childDeviceId, childDeviceId) ||
                other.childDeviceId == childDeviceId) &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentUserId,
    parentDeviceId,
    parentName,
    qrCode,
    createdAt,
    expiresAt,
    isUsed,
    childUserId,
    childDeviceId,
    childName,
    acceptedAt,
  );

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairingRequestImplCopyWith<_$PairingRequestImpl> get copyWith =>
      __$$PairingRequestImplCopyWithImpl<_$PairingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PairingRequestImplToJson(this);
  }
}

abstract class _PairingRequest extends PairingRequest {
  const factory _PairingRequest({
    required final String id,
    required final String parentUserId,
    required final String parentDeviceId,
    required final String parentName,
    required final String qrCode,
    required final DateTime createdAt,
    required final DateTime expiresAt,
    final bool isUsed,
    final String? childUserId,
    final String? childDeviceId,
    final String? childName,
    final DateTime? acceptedAt,
  }) = _$PairingRequestImpl;
  const _PairingRequest._() : super._();

  factory _PairingRequest.fromJson(Map<String, dynamic> json) =
      _$PairingRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get parentUserId;
  @override
  String get parentDeviceId;
  @override
  String get parentName;
  @override
  String get qrCode;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  bool get isUsed;
  @override
  String? get childUserId;
  @override
  String? get childDeviceId;
  @override
  String? get childName;
  @override
  DateTime? get acceptedAt;

  /// Create a copy of PairingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairingRequestImplCopyWith<_$PairingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
