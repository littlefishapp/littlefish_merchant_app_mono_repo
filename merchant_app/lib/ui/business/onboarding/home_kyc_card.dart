import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/ui/business/onboarding/onboarding_prompt_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class HomeKYCCard extends StatelessWidget {
  const HomeKYCCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listItem(
      AppAssets.verificationPng,
      'Start KYC/KYV',
      context,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) =>
                const OnboardingPromptpage(routeName: HomePage.route),
          ),
        );
      },
    );
    // CardNeutral(
    //   color: Theme.of(context).colorScheme.primary.withOpacity(1),
    //   child: InkWell(
    //     onTap: () {
    //       Navigator.push(context, CustomRoute(builder: (BuildContext context) {
    //         return OnboardingPromptpage(
    //           routeName: HomePage.route,
    //         );
    //       }));
    //     },
    //     child: Container(
    //       padding: EdgeInsets.all(3.0),
    //       width: MediaQuery.of(context).size.width - 20,
    //       height: 120,
    //       child: Stack(
    //         alignment: AlignmentDirectional.center,
    //         children: [
    //           Image.asset('assets/images/graphics/verification.png'),
    //           CardNeutral(
    //             child: Padding(
    //               padding: EdgeInsets.all(5),
    //               child: Text(
    //                 "Start Onboarding",
    //                 style: TextStyle(
    //                     fontSize: 20,
    //                     color: Theme.of(context).colorScheme.secondary,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget listItem(
    String assetPath,
    String title,
    BuildContext context, {
    Function? onTap,
  }) => CardNeutral(
    elevation: 1,
    child: SizedBox(
      height: 160,
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 80,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          SizedBox(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width - 50,
            child: ButtonPrimary(
              buttonColor: Theme.of(context).colorScheme.secondary,
              text: title,
              onTap: (ctx) {
                if (onTap != null) {
                  onTap();
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}
