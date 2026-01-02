// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/pages/create_payment_link_page.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/pages/payment_links_landing_page.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/view_models/payment_links/viewmodels/payment_links_vm.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';

import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../models/store/business_profile.dart';
import '../../../../providers/environment_provider.dart';
import '../../../invoicing/presentation/pages/invoice_create_page.dart';
import '../../../invoicing/presentation/pages/invoice_landing_page.dart';

class GetPaidAction {
  late String route;
  late String title;
  late IconData icon;
  late String? description;
  final Function({required BuildContext context})? onTap;

  GetPaidAction({
    required this.title,
    required this.icon,
    required this.route,
    this.description,
    this.onTap,
  });
}

class GetPaidPage extends StatefulWidget {
  static const String route = 'get-paid';
  const GetPaidPage({Key? key}) : super(key: key);

  @override
  State<GetPaidPage> createState() => _GetPaidPageState();
}

class _GetPaidPageState extends State<GetPaidPage> {
  List<GetPaidAction> _actions = List.empty();
  List<GetPaidAction> _manageActions = List.empty();
  late BusinessProfile _businessProfile;

  void buildActions() {
    List<GetPaidAction> actions = List.empty(growable: true);
    if (userHasPermission(allowPaymentLink)) {
      actions.add(
        GetPaidAction(
          title: 'Create \n Payment Link',
          icon: Icons.link,
          route: CreatePaymentLinksPage.route,
        ),
      );
    }
    if (userHasPermission(allowInvoice)) {
      actions.add(
        GetPaidAction(
          title: 'Create \n Invoice',
          icon: Icons.bookmark_outline,
          route: InvoiceCreatePage.route,
        ),
      );
    }

    setState(() {
      _actions = actions;
    });
  }

  void buildManageActions() {
    List<GetPaidAction> actions = List.empty(growable: true);
    if (userHasPermission(allowPaymentLink)) {
      actions.add(
        GetPaidAction(
          title: 'Payment Links',
          icon: Icons.attach_money,
          route: PaymentLinksLandingPage.route,
          description: 'View and manage your payment links',
        ),
      );
    }

    if (userHasPermission(allowInvoice)) {
      actions.add(
        GetPaidAction(
          title: 'Invoices',
          icon: Icons.bookmark_outline,
          route: InvoiceLandingPage.route,
          description: 'View and manage your invoices',
        ),
      );
    }

    setState(() {
      _manageActions = actions;
    });
  }

  @override
  void initState() {
    super.initState();
    _businessProfile = AppVariables.store!.state.businessState.profile!;
    buildActions();
    buildManageActions();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentLinksViewModel>(
      converter: (store) => PaymentLinksViewModel.fromStore(store),
      builder: (ctx, vm) {
        //return scaffoldMobile(context, vm);
        if (EnvironmentProvider.instance.isLargeDisplay!) {
          return appScaffoldTablet(context, vm);
        } else {
          return appScaffoldMobile(context, vm);
        }
      },
    );
  }

  AppScaffold appScaffoldMobile(
    BuildContext context,
    PaymentLinksViewModel vm,
  ) => AppScaffold(
    navBar: const BottomNavBar(page: PageType.getPaid),
    displayNavBar: vm.store!.state.enableBottomNavBar!,
    displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
    title: 'Get Paid',
    actions: const <Widget>[],
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 4),
                  context.headingXSmall(
                    'Actions',
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.emphasized,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _actions.map((action) {
                    return ButtonQuickAction(
                      icon: action.icon,
                      title: action.title,
                      onTap: () {
                        if (action.onTap != null) {
                          action.onTap!(context: context);
                        } else {
                          if (action.route == CreatePaymentLinksPage.route &&
                              !isOnlinePaymentsEnabled()) {
                            showMessageDialog(
                              context,
                              'You cannot create a payment link '
                              'because your account is not enabled '
                              'for online payments.',
                              LittleFishIcons.error,
                            );
                            return;
                          }
                          if (action.route == InvoiceCreatePage.route &&
                              !isOnlinePaymentsEnabled()) {
                            showMessageDialog(
                              context,
                              'You cannot create an invoice '
                              'because your account is not enabled '
                              'for online payments.',
                              LittleFishIcons.error,
                            );
                            return;
                          }
                          Navigator.of(context).pushNamed(action.route);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 4),
                  context.headingXSmall(
                    'Manage',
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.emphasized,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: _manageActions.map((action) {
                return ItemListTile(
                  title: action.title,
                  subtitle: action.description,
                  leading: Icon(action.icon),
                  onTap: () => Navigator.of(context).pushNamed(action.route),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ),
  );

  AppScaffold appScaffoldTablet(
    BuildContext context,
    PaymentLinksViewModel vm,
  ) => AppScaffold(
    navBar: const BottomNavBar(page: PageType.getPaid),
    displayNavBar: vm.store!.state.enableBottomNavBar!,
    displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
    title: 'Get Paid',
    actions: const <Widget>[],
    body: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: ListView(
              children: _manageActions.map((action) {
                return ItemListTile(
                  title: action.title,
                  subtitle: action.description,
                  leading: Icon(action.icon),
                  onTap: () => Navigator.of(context).pushNamed(action.route),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 4),
                        context.headingXSmall(
                          'Actions',
                          color: Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.emphasized,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: _actions.map((action) {
                          return ButtonQuickAction(
                            icon: action.icon,
                            title: action.title,
                            onTap: () {
                              if (action.onTap != null) {
                                action.onTap!(context: context);
                              } else {
                                Navigator.of(context).pushNamed(action.route);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  bool isOnlinePaymentsEnabled() {
    final match = _businessProfile.linkedAccounts?.where(
      (a) => a.providerName?.toLowerCase() == 'onlinepayments',
    );

    if (match != null && match.isNotEmpty) {
      return match.first.enabled == true;
    }

    return false;
  }
}
