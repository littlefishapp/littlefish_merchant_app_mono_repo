// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../../common/presentaion/components/common_divider.dart';

class SetupFBShop extends StatelessWidget {
  const SetupFBShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Set up a shop in Facebook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          CommonDivider(color: Colors.grey.shade300),
          Wrap(
            runSpacing: 15,
            children: [
              const Text(
                'This is step 2 of the LittleFish, Facebook and Instaram integration. If you already have a shop created in Facebook, go ahead and integrate your catalog in the next step',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '⚠️ These steps need to be completed in a web browser version of Facebook, the mobile app version does not have the same functions. ⚠️',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Before creating a shop, it is important to add all the necessary business information to your page so no discrepancies are found by Instagram when verifying your data.',
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'On the same menu, select Page Info and add details such as contact information, delivery options, business hours and price range.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/UpdatePageInfo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                '💡 With your security in mind Facebook only allows administrators to manage business related tools so go to Commerce Manager and follow the steps suggested.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/GetStarted.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Create your shop by choosing Checkout on Another Website so your customers are redirected to the online store',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/CreateNewShop.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/CheckoutWebsite.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Select the page you created to be the place where you will sell your products and create a business account in case you still don’t have one or select the business account you have already created.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/ChooseSalesChannel.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/CreateBusinessAccount.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Create your Catalog where you would like your items to be stored. Dont worry about adding items yet we will guide you on that in the next section.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/CreateCatalog.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'Add your shipping information and then Check that all the data is correct and send your shop for review.',
              ),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/AddShipping.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/facebook/SetUpFBShop/FinishSetUp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              CommonDivider(color: Colors.grey.shade300),
              const Text(
                'You will be notified on the email you registered with once your request is reviewed.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
