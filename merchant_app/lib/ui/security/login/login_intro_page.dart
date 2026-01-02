import 'package:flutter/material.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import '../../../app/app.dart';
import '../../../common/presentaion/components/custom_app_bar.dart';

class LoginIntroPage extends StatefulWidget {
  static const String route = 'login/loginintro';

  const LoginIntroPage({Key? key}) : super(key: key);

  @override
  State<LoginIntroPage> createState() => _LoginIntroPageState();
}

class _LoginIntroPageState extends State<LoginIntroPage> {
  bool _enablePage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.center,
                height: 40,
                child: Image.asset(
                  UIStateData().appLogo,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: informationLayout(context),
      ),
      persistentFooterButtons: [
        _dontShowAgainCheckbox(),
        Container(
          height: 104,
          padding: const EdgeInsets.only(bottom: 56, left: 8, right: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ButtonPrimary(
            text: 'Get Started',
            textColor: Colors.white,
            buttonColor: Theme.of(context).colorScheme.secondary,
            onTap: (value) {
              var route =
                  AppVariables.store!.state.permissions!.makeSale == true ||
                      AppVariables.store!.state.permissions!.isAdmin == true
                  ? SellPage.route
                  : HomePage.route;
              Navigator.pushReplacementNamed(
                globalNavigatorKey.currentContext!,
                route,
                arguments: null,
              );
            },
          ),
        ),
      ],
    );
  }

  Column informationLayout(BuildContext context) =>
      Column(children: <Widget>[...content(), const SizedBox(height: 20)]);

  Container _dontShowAgainCheckbox() => Container(
    height: 40,
    padding: const EdgeInsets.only(left: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: _enablePage ? false : true,
          onChanged: (valid) {
            setState(() {
              _enablePage = valid! ? false : true;
              saveKeyToPrefsBool('enableWelcomePage', _enablePage);
            });
          },
        ),
        const Text("Don't show again"),
      ],
    ),
  );

  List content() {
    final appName = AppVariables.store?.state.appName ?? '';
    return [
      const SizedBox(height: 24),
      Text(
        'Welcome to $appName!',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
      const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          "You've joined 3000+ businesses that have taken their enterprises to the next level.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
        ),
      ),
      const SizedBox(height: 18),
      _itemTile(
        'Home',
        'Get an overview of all the parts of your business and take action',
        Icons.home,
      ),
      _defaultTileSpacing(),
      _itemTile(
        'Stock',
        'Effortlessly track products and stock levels to meet customer demands.',
        Icons.inventory,
      ),
      _defaultTileSpacing(),
      _itemTile(
        'Shop',
        "Customise and manage your shop's details to create a unique storefront.",
        Icons.store,
      ),
      _defaultTileSpacing(),
      _itemTile(
        'Manage',
        'Manage your account in every way that counts to you and your business.',
        Icons.manage_accounts,
      ),

      // ]),),
    ];
  }

  SizedBox _defaultTileSpacing() => const SizedBox(height: 20);

  ListTile _itemTile(String title, String description, IconData icon) =>
      ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
}
