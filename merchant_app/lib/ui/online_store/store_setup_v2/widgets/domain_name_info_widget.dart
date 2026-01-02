// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// package imports
import 'package:quiver/strings.dart';

// project imports
import 'package:littlefish_merchant/app/app.dart';

class DomainNameInfoWidget extends StatelessWidget {
  final String? domainExampleText;
  const DomainNameInfoWidget({Key? key, this.domainExampleText})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [_mainDescription(context), _exampleText(context)]);
  }

  _mainDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            //fontFamily: UIStateData.primaryFontFamily,
          ),
          children: <TextSpan>[
            const TextSpan(
              text:
                  'Your domain name is the unique identifier that will '
                  'make it easier for people to find you online. ',
            ),
            TextSpan(
              text:
                  'Please note that you cannot change your domain name '
                  'once you have added it to your account.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).extension<AppliedInformational>()?.warningText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _exampleText(BuildContext context) {
    String hostSite =
        AppVariables
            .store
            ?.state
            .environmentSettings
            ?.onlineStoreSettings
            ?.baseUrl ??
        'littlefish.mobi';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
              //fontFamily: UIStateData.primaryFontFamily,
            ),
            children: <TextSpan>[
              const TextSpan(text: 'https://'),
              TextSpan(
                text: isNotBlank(domainExampleText)
                    ? domainExampleText
                    : 'domain-name',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.deEmphasized,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  //fontFamily: UIStateData.primaryFontFamily,
                ),
              ),
              TextSpan(text: '.$hostSite'),
            ],
          ),
        ),
      ),
    );
  }
}
