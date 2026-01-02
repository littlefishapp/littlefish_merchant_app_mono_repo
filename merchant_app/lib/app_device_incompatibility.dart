import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/tools/security/app_security_validation.dart';

class AppDeviceIncompatibility extends StatefulWidget {
  const AppDeviceIncompatibility({super.key});

  @override
  State<AppDeviceIncompatibility> createState() =>
      _AppDeviceIncompatibilityState();
}

class _AppDeviceIncompatibilityState extends State<AppDeviceIncompatibility> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const SafeArea(
          minimum: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Security Check Failed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'For your protection, this app will not run on devices that are rooted, jailbroken or installed on insecure environments.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        extendBody: true,
        persistentFooterButtons: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black.withOpacity(0.9),
                backgroundColor: Colors.grey.withOpacity(0.01),
              ),
              onPressed: () async {
                //Added this here for incase firebase hasnt loaded properly yet
                await AppSecurityValidation().checkDeviceIntegrity();
                SystemNavigator.pop();
                exit(0);
              },
              child: const Text('EXIT'),
            ),
          ),
        ],
      ),
    );
  }
}
