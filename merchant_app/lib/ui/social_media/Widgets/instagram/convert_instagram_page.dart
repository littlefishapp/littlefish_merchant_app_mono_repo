import 'package:flutter/material.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class ConvertInstagramPage extends StatelessWidget {
  const ConvertInstagramPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Convert Instagram Account to Business Account',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                'This is step 5 of the LittleFish, Facebook and Instagram integration. Please ensure that your facebook page is set up and approved by Facebook before continuing with the next guide. If you already have an Instagram business profile, just request approval for Instagram Shopping by proceeding to the next step and you will be set!',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '⚠️ Please ensure you have an Instagram Account set up. If not please create one before proceeding. Set Up Below is for App version of Instagram ⚠️',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Go to Instagram, login to your account and from the home screen of the app choose the Profile tab. Tap the hamburger icon in the upper right corner. Go to Settings, tap on Account and select Switch to Professional Account.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/SwitchAccount.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const Text(
                'You will see a summary of the benefits of this feature and will arrive at the business registration screen. Select a category for your store, preferably the same one you chose on Facebook.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/BusinessCategories.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'On the next screen choose Bussiness instead of Creator and enter the contact details for your shop, they will be availaable on the main screen of your Instagram page.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/SelectBusiness.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/ReviewAccount.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                "To integrate with your LittleFish products registered on Facebook, choose the page that was created in your business profile. Follow the suggested steps to enable the professional tools, with them you'll have access to your store's online presence statistics and be able to improve interactions between your customers and your brand. In order for your catalogue to show up you will need to have your corresponding facebook page approved",
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/ConnectCatalogInstagram.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ConvertBusinessAccount/ConfirmWebsite.png',
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
