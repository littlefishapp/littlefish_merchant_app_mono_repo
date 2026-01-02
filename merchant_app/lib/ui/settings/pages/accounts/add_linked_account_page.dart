// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';

// Project imports:
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/widgets/provider_image_display.dart';
import '../../../../common/presentaion/components/cards/card_neutral.dart';

class AddLinkedAccountPage extends StatefulWidget {
  static const route = 'settings/add-account';

  final LinkedAccountVM? vm;

  const AddLinkedAccountPage({Key? key, this.vm}) : super(key: key);

  @override
  State<AddLinkedAccountPage> createState() => _AddLinkedAccountPageState();
}

class _AddLinkedAccountPageState extends State<AddLinkedAccountPage> {
  late LinkedAccountVM vm;

  @override
  void initState() {
    vm = widget.vm!
      ..onLoadingChanged = () {
        if (mounted) setState(() {});
      };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayAppBar: true,
      displayNavDrawer: false,
      displaySearchBar: false,
      displayBackNavigation: true,
      displayNavBar: false,
      enableProfileAction: false,
      title: 'Account Type',
      body: vm.linkableProviders.isEmpty
          ? Center(child: context.labelMedium('No Providers Available'))
          : _layout(context),
    );
  }

  GridView _layout(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: vm.linkableProviders.length,
      itemBuilder: (BuildContext context, int index) {
        var item = vm.linkableProviders[index];
        return CardNeutral(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: InkWell(
                child: Column(
                  children: [
                    if (widget.vm != null && item.providerName != null)
                      context.labelSmall(
                        LinkedAccountUtils.cleanUpProviderName(
                          item.providerName!,
                        ),
                      ),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ProviderImageDisplay(
                          imagePath: item.imageURI ?? '',
                          providerName: item.providerName ?? '',
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  await Navigator.of(context)
                      .push(
                        CustomRoute(
                          builder: (ctx) =>
                              LinkedAccountUtils.buildProviderPage(
                                context,
                                item.providerType!,
                                vm,
                                item,
                              ),
                        ),
                      )
                      .then((v) {
                        if (mounted) setState(() {});
                      });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
