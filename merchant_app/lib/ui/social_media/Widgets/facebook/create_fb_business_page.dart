// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class CreateFBBusinessPage extends StatelessWidget {
  String? businesssDomain = AppVariables.store!.state.uniqueSubdomin;
  String? baseurl = AppVariables.store!.state.onlineStoreUrl;

  late String link;

  CreateFBBusinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    link = 'https://$businesssDomain.$baseurl';
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
            'Creating the page through the Facebook Website',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                'This is step 1 of the LittleFish, Facebook and Instagram integration. If you already have a business page on Facebook, You can Proceed to Setting up a Shop for your Facebook Business Page',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '⚠️ Majority of the integration process needs to be done through a browser version Facebook and not on the app. Please complete all the steps on a computer as it is easier and more convenient ⚠️',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'From the main Facebook page, select the Pages option from the menu on the left. Click + Create new page and follow the system steps.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/CreateFBPage/CreateFBPage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const Text(
                'Name your business, choose the categories that best describe your business and add a description of what you offer your customers. Finish by clicking Create Page.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/CreateFBPage/SetUpFBPage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const Text('Add your Business Details and Click Next.'),
              const Text(
                "Add photos to make your business more attractive. Then Click the 'Add Action Button' Button to add a button to direct customers to your online store. Use the View Shop -> Link on Website option and add the url to your ecommerce site in the provided place. The link can be generated using the button below. Follow the rest of the steps to complete the set up of your page and click Done",
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/CreateFBPage/AddImagesToFBPage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/CreateFBPage/FBPageSetUp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => copyToClipboard(link),
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Copy Online Store Link to Clipboard'),
          ),
          CommonDivider(color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
