// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class InstagramShoppingApprovalPage extends StatelessWidget {
  const InstagramShoppingApprovalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Request Approval for Instagram Shopping',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                "This is the last step of the LittleFish, Facebook and Instagram integration. Even after completing all the steps above, you'll still need to wait for Instagram to review your request, which may not be approved if your account isn't in comply with Instagram's Eligibility Rules.",
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'In the Instagram app, login to your account and from the home screen choose the Profile tab. Tap the hamburger icon in the upper right corner. Go to Settings, tap Bussines and select Set Up Instagram Shopping. Follow the steps requested and wait for the analysis result.',
              ),
              const Text(
                'Please note in order for your shop to be activated on Instagram it needs to be approved first. Facebook will notify via mail once your shop is approved',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ReviewAccount/SetUpShopping.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ReviewAccount/OpenInstagramShop.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/instagram/ReviewAccount/CompleteSetUp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                "If your application is rejected, please follow the steps below. Alternatively If you are still unable to request a new analysis on Instagram or if you did and it was rejected again, we recommend that you contact Facebook's support team for further clarification.",
              ),
              const Text(
                "Step 1: Disconnect your Instagram profile from your Facebook page and from the Facebook's Business Manager",
              ),
              const Text(
                'Step 2: Return your Instagram profile to a Personal Profile',
              ),
              const Text(
                "Step 3: Select the 'Shop' template for your Facebook page",
              ),
              const Text(
                'Step 4: Revert your Instagram profile to a Professional Profile',
              ),
              const Text(
                "Step 5: Remove the integration between your LittleFish Products catalog and Facebook's Catalog Manager",
              ),
              const Text(
                'Step 6: Redo the integration between your Kyte catalog and your Facebook Shop',
              ),
              const Text(
                'Step 7: Add the Shop Now button to the Facebook Page, redirecting to the Kyte Catalog',
              ),
              const Text(
                'Step 8: Reconnect your Instagram profile with your Facebook page',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
