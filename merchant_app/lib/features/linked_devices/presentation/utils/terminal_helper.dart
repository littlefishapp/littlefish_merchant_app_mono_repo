import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';

LittleFishCore core = LittleFishCore.instance;

class TerminalHelper {
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String maintenance = 'Maintenance';
  static const String decommissioned = 'Decommissioned';

  static List<String> _terminalStatusOptions() => [
    active,
    inactive,
    maintenance,
    decommissioned,
  ];

  static List<DropDownValue> statusDropDownValues() {
    return _terminalStatusOptions()
        .map(
          (status) => DropDownValue(
            value: status,
            displayValue: status,
            index: _terminalStatusOptions().indexOf(status),
          ),
        )
        .toList();
  }

  static bool isPosTerminal(String terminalFamily) {
    ConfigService configService = core.get<ConfigService>();
    List<String> knownFamilies = ['pax', 'ingenico', 'verifone', 'newland'];
    dynamic terminalFamiliesMap = configService.getObjectValue(
      key: 'config_pos_family_names',
      defaultValue: {'key': 'value'},
    );
    if (!(terminalFamiliesMap == null)) {
      if (terminalFamiliesMap is Map<String, dynamic> &&
          terminalFamiliesMap.containsKey('family')) {
        final families = terminalFamiliesMap['family'];
        if (families is List) {
          knownFamilies = List<String>.from(families);
        }
      }
    }
    final family = terminalFamily.toLowerCase();
    return knownFamilies.any(family.contains);
  }

  // ! Commenting getFirebaseMobileAppId out for now as it is not used and unclear if it ever worked based on the authService contract

  /// Returns the Firebase mobile application ID (App ID) for this app instance.
  /// This is the static app identifier, not the installation ID.
  /// Uses the `firebase_core` package.
  /// Returns null if not available.
  // Future<String> getFirebaseMobileAppId() async {
  //   try {
  //     var authService = LittleFishCore.instance.get<AuthService>();
  //     return await authService.app.options.appId;
  //   } catch (e) {
  //     return '';
  //   }
  // }
}
