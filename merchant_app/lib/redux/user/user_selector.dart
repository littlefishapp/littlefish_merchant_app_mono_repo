// Package imports:
import 'package:geocoding/geocoding.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';

Future<List<Placemark>?> userFriendlyLocation(Store<AppState> store) async {
  var userState = store.state.userState;

  if (userState.location == null) return null;

  var result = await placemarkFromCoordinates(
    userState.location!.latitude,
    userState.location!.longitude,
  );

  return result;
}
