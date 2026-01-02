import 'package:littlefish_core/auth/models/auth_user.dart';

import 'store/store.dart';
import 'user/user.dart';

class LogonResult {
  User? profile;

  AuthUser? authenticationResult;

  List<UserStoreLink>? followedStores;

  List<Store>? managedStores;

  LogonResult({
    this.authenticationResult,
    this.profile,
    this.followedStores,
    this.managedStores,
  });
}

class CachedLogonResult {
  User? profile;

  AuthTokenResult? tokenResult;

  dynamic user;

  List<UserStoreLink>? followedStores;

  List<Store>? managedStores;

  CachedLogonResult({
    this.tokenResult,
    this.profile,
    this.user,
    this.followedStores,
    this.managedStores,
  });
}
