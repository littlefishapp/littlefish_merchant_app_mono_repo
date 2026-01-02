// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/app.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class VerifyDomainPage extends StatelessWidget {
  String businessDomain = AppVariables.store!.state.uniqueSubdomin!;
  String? baseURL = AppVariables.store!.state.onlineStoreUrl;
  late String link;

  VerifyDomainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    link = '$businessDomain.$baseURL';
    Future<void> copyToClipboard(String link) async {
      await Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Verify Your Domain',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                "This is step 4 of the LittleFish, Facebook and Instagram integration. If you already verified your catalog's domain, there is nothing left to do in Facebook. Now you need to set up a business account in Instagram and submit a request for Instagram Shopping.",
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '⚠️ These steps need to be completed in a web version of Facebook, the app does not have the same functions. ⚠️',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                "Go into the Facebook's Business Manager and in Brand Safety select Domains. Tap on Add. Paste your catalog’s URL by copying it with button below and tap on Add.",
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/VerifyDomain/AddDomain.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => copyToClipboard(link),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Copy Domain Link'),
                  ),
                ),
              ),
              const Text(
                'Select the Upload an HTML file to your root directory, click the link in the 3rd step and tap on Verify Domain, the process is done automatically by the system. If the button does not appear, zoom out the screen using the three dots at the top right of the screen.',
              ),
              const Text(
                'Click the link in the 3rd step in order for the file to be created on the Domain.',
              ),
              const Text(
                'Then Tap on Verify Domain, the process is done automatically by the system. If the button does not appear, zoom out the screen using the three dots at the top right of the screen.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/VerifyDomain/VerifyDomain.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'It is important to note that in order to use your shop on facebook and complete the Instagram Set Up your facebook shop should be approved by Facebook',
              ),
              const Text(
                'Congratulations! Your LittleFish Product Catalog should now be eligible for Instagram Shopping. 🚀',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/VerifyDomain/VerifySuccess.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
            ],
          ),
        ],
      ),
    );
  }
}
