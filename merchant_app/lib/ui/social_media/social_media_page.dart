import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/services/cloud_functions/third_party_sync_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/facebook/facebook_shopping_store.dart';
import 'package:littlefish_merchant/ui/social_media/Widgets/instagram/instagram_shopping_store_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../app/theme/applied_system/applied_text_icon.dart';
import '../../common/presentaion/components/common_divider.dart';

// Flutter imports:

// Project imports:

class SocialMediaPage extends StatefulWidget {
  final bool showBackButton;

  const SocialMediaPage({Key? key, this.showBackButton = false})
    : super(key: key);

  @override
  State<SocialMediaPage> createState() => _SocialMediaPagePageState();
}

class _SocialMediaPagePageState extends State<SocialMediaPage> {
  late ThirdPartySyncService _service;
  late Future<bool> checkFlag;
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    _service = ThirdPartySyncService.fromStore(AppVariables.store!);
    _service.shortenUrl(AppVariables.store!.state.businessId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldMobile(context, false);
  }
  // => FutureBuilder(
  //     future: checkFlag =
  //         _service.checkSyncStatus(AppVariables.store!.state.businessId!),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return scaffoldMobile(context, snapshot.data);
  //       } else {
  //         return AppProgressIndicator(
  //           hasScaffold: true,
  //         );
  //       }
  //     });

  AppScaffold scaffoldMobile(context, checkStatus) => AppScaffold(
    title: 'Social Media',
    hasDrawer: !widget.showBackButton,
    body: Column(
      children: [
        if (_isLoading == true) const LinearProgressIndicator(),
        if (AppVariables.store!.state.googleEnabled == true)
          ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            trailing: _isLoading == true
                ? const SizedBox.shrink()
                : Switch(
                    activeColor: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.brand,
                    value: checkStatus,
                    onChanged: (value) async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _service.googleMerchSync(
                        AppVariables.store!.state.businessId!,
                        value,
                      );
                      if (value == true) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('Sync Enabled')),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Please allow up to 3 days for Products to be reviewed by Google',
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          alignment: Alignment.center,
                                        ),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('Sync Disabled')),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Products will be removed from Google Merchant',
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          alignment: Alignment.center,
                                        ),
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
            title: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(FontAwesomeIcons.google, size: 18.0),
                Text(' '),
                Text('Sync with Google Merchant'),
              ],
            ),
            subtitle: Text(ThirdPartySyncService.subTitle),
          ),
        CommonDivider(color: Colors.grey.shade300),
        if (AppVariables.store!.state.facebookEnabled == true)
          quickAction(
            const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(FontAwesomeIcons.facebook, size: 18.0),
                Text(' '),
                Text('Facebook Shopping Set Up'),
              ],
            ),
            Icon(
              MdiIcons.tagMultiple,
              color: Theme.of(context).colorScheme.secondary,
              // size: 54,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const FacebookShoppingStorePage(showBackButton: true),
              ),
            ),
            subtitle: 'Connect your Online Store to Facebook',
          ),
        CommonDivider(color: Colors.grey.shade300),
        if (AppVariables.store!.state.instagramEnabled == true)
          quickAction(
            const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(FontAwesomeIcons.instagram, size: 18.0),
                Text(' '),
                Text('Instagram Shopping Set Up'),
              ],
            ),
            Icon(
              MdiIcons.tagMultiple,
              color: Theme.of(context).colorScheme.secondary,
              // size: 54,
            ),
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const InstagramShoppingStorePage(showBackButton: true),
              ),
            ),
            subtitle: 'Connect your Online Store to Instagram',
          ),
        CommonDivider(color: Colors.grey.shade300),
      ],
    ),
  );

  ListTile quickAction(
    Wrap title,
    Widget child,
    Function onTap, {
    String? subtitle,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    trailing: const Icon(Icons.chevron_right),
    subtitle: subtitle != null ? Text(subtitle) : null,
    onTap: () {
      onTap();
    },
    title: title,
  );
}
