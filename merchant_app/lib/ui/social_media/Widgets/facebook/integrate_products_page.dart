// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class IntegrateProductsPage extends StatelessWidget {
  String businessDomain = AppVariables.store!.state.uniqueSubdomin!;

  IntegrateProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> copyToClipboard(String businessId) async {
      String link = AppVariables.store!.state.shortenCatalogueUrl!;
      await Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
    }

    final appName = AppVariables.store?.state.appName ?? '';
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Integrate Products with Facebook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                'This is step 3 of the LittleFish, Facebook and Instagram integration.',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '⚠️ These steps need to be completed in a web version of Facebook, the app does not have the same functions. ⚠️',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                "If you Have not created a catalog yet, the catalog can be added and managed through Facebook's Commerce Manager. Click + Add Catalog to start the process. Select E-commerce as your business type, use the Upload Product Information option and name your catalog as you prefer. To carry on, click on Create.",
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Click Add Items on the right hand side of the page to access the data entry process',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/AddItems.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'From the left menu choose Data Sources and choose the Data Feed option on the next page.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/SelectDataFeed.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              Text(
                '$appName will provide the correctly formatted file for you so just choose the Yes option with regards to having a Spreadsheet or File Ready',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/SpreadsheetSetup.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Select the Use a URL tab and in the URL field enter your link by clicking the button below to copy the url',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/UseUrlFile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        copyToClipboard(AppVariables.store!.state.businessId!),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      alignment: Alignment.center,
                    ),
                    child: const Text('Copy Online Store Link to Clipboard'),
                  ),
                ),
              ),
              CommonDivider(color: Colors.grey.shade300),
              Text(
                'Set how often Facebook will access your $appName data, choose'
                ' the period according to the fluctuation in your inventory so '
                'that Instagram Shopping always has access to the most up to date '
                'information and doesn${"'"}t cause any frustration for your customers '
                'when ordering. To improve this interaction, enable the Add '
                'automatic updates option. Name the data source and select the '
                'currency used in the online store to complete the feed setup.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/SetSchedule.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Confirm the Settings and if you are happy select Save Feed and Upload',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/ConfirmSettings.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Data loading may take a while if your online store has a large amount of products. If problems are found with your products, they will be listed in the Result. Click View Report to access the details, items with the red attention icon need to be fixed before being made available on Facebook and Instagram. The yellow attention icons are suggestions for improvement to increase the view of your products.',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Download the report to see all data in csv format. If the file upload is successful you should see a page similar to the below depending on how you set up your system',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/IntegrateProducts/SuccessUpload.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
