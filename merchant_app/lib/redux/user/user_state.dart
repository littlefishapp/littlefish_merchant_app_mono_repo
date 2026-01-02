import 'package:built_value/built_value.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';

import '../../models/permissions/business_user_role.dart';

part 'user_state.g.dart';

abstract class UserState implements Built<UserState, UserStateBuilder> {
  UserState._();

  factory UserState() => _$UserState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    canChangeViewMode: true,
  );

  // static Serializer<UserState> get serializer => _$userStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isGuestUser;

  UserProfile? get profile;

  Map<String, bool>? get permissions;

  List<BusinessUserRole>? get userBusinessRoles;

  Position? get location;

  UserViewingMode? get viewMode;

  bool? get canChangeViewMode;

  bool isCompleted() {
    return profile?.validate() ?? false;
  }
}

enum UserViewingMode { full, pointOfSale, all }
