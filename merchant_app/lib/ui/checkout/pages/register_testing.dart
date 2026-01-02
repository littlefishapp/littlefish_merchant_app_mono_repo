import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/pos_pay_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_payments/models/terminal/terminal_enrol_data.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// This page is used for testing the registration of the device.
// It contains buttons to check the device registration status,
// register the device, and deregister the device.
// It is not intended for production use and should be removed in the final version.
// This page is only for testing purposes and should not be used in production.
// The below button commented code can be placed in the app bar or anywhere else in the app to navigate to this page.

// IconButton(
//   onPressed: () {
//     Navigator.of(context).push(
//       CustomRoute(
//         builder: (BuildContext context) {
//           return RegisterTestingPage();
//         },
//       ),
//     );
//   },
//   icon: const Icon(LittleFishIcons.info),
// ),

class RegisterTestingPage extends StatelessWidget {
  RegisterTestingPage({Key? key}) : super(key: key);
  PosPayVM? _vm;

  @override
  Widget build(BuildContext context) {
    _vm ??= PosPayVM.fromStore(
      StoreProvider.of<AppState>(context),
      context: context,
    )..onLoadingChanged = () {};
    return Scaffold(
      appBar: AppBar(title: const Text('Register Testing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonPrimary(
              text: 'Check Device Registration',
              onTap: (ctx) async {
                bool? data;
                try {
                  data = await _vm?.isDeviceEnrolled();
                  showMessageDialog(
                    ctx,
                    'Device registration status: ${data == true ? "Registered" : "Not Registered"}',
                    LittleFishIcons.info,
                  );
                } catch (e) {
                  showMessageDialog(
                    ctx,
                    'Unable to determine the device registration status. Please try again later.',
                    LittleFishIcons.info,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ButtonPrimary(
              text: 'Register Device',
              onTap: (ctx) async {
                TerminalEnrolData? data;
                try {
                  data = await _vm?.enrollDevice();
                  showMessageDialog(
                    ctx,
                    'Successfully registered device\nTerminal ID: ${data?.terminalId}\nMerchant ID: ${data?.merchantId}',
                    LittleFishIcons.info,
                  );
                } catch (e) {
                  showMessageDialog(
                    ctx,
                    'Device registration failed. Please check your network connection and try again.',
                    LittleFishIcons.info,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            ButtonPrimary(
              text: 'Deregister Device',
              onTap: (ctx) async {
                bool? data;
                try {
                  data = await _vm?.unEnrollDevice();

                  showMessageDialog(
                    ctx,
                    'Device successfully deregistered: $data',
                    LittleFishIcons.info,
                  );
                } catch (e) {
                  showMessageDialog(
                    ctx,
                    'Failed to deregister the device. Please try again.',
                    LittleFishIcons.info,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
