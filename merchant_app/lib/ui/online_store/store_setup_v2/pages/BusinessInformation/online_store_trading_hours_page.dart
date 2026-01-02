import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/trading_hour_tile.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class OnlineStoreTradingHoursPage extends StatefulWidget {
  static const route = 'online-store/business-details-trading-hours';

  final List<TradingDay>? tradingHours;

  final bool showPageNumber;
  final int pageNumber, totalNumPages;
  const OnlineStoreTradingHoursPage({
    Key? key,
    this.tradingHours,
    this.showPageNumber = true,
    this.pageNumber = 5,
    this.totalNumPages = 5,
  }) : super(key: key);

  @override
  State<OnlineStoreTradingHoursPage> createState() =>
      _OnlineStoreTradingHoursPageState();
}

class _OnlineStoreTradingHoursPageState
    extends State<OnlineStoreTradingHoursPage> {
  late List<TradingDay> _tradingHours;
  final double _pageHorizontalPadding = 16;

  @override
  void initState() {
    if (isNotNullOrEmpty(widget.tradingHours)) {
      _tradingHours = widget.tradingHours!;
    } else {
      _tradingHours = List.generate(
        8,
        (index) => TradingDay.defaultDate(index + 1),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'Operating Hours',
        centreTitle: false,
        body: vm.isLoading != true
            ? layout(context, vm)
            : const AppProgressIndicator(),
        enableProfileAction: false,
        actions: [
          Visibility(
            visible: widget.showPageNumber,
            child: PageNumberText(
              pageNumber: widget.pageNumber,
              totalNumPages: widget.totalNumPages,
            ),
          ),
        ],
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText:
                !(vm.store!.state.storeState.store?.isConfigured ?? false)
                ? 'Skip'
                : 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              !(vm.store!.state.storeState.store?.isConfigured ?? false)
                  ? navigateToSetupHomePage(context, vm)
                  : Navigator.of(context).pop();
            },
            primaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Save'
                : 'Next',
            onPrimaryButtonPressed: (ctx) async {
              if (vm.item == null) {
                vm.store?.dispatch(CreateDefaultStoreAction());
              }

              vm.store?.dispatch(UpdateTradingHoursAction(_tradingHours));
              vm.upsertStore(vm.item!);

              navigateToSetupHomePage(context, vm);
            },
          ),
        ],
      ),
    );
  }

  Widget layout(BuildContext context, ManageStoreVMv2 vm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _pageHorizontalPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelLarge(
              'Operating Hours',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isSemiBold: true,
            ),
            context.labelMedium(
              'Please add your opening and closing hours for the days you '
              'trade so your customers know when they can shop with you. '
              'This will be displayed on your "Contact Us" page',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
            ),
            ..._tradingHours.map(
              (TradingDay tradingDay) => TradingHourTile(
                key: UniqueKey(),
                dayName: dayOfWeek(tradingDay.dow ?? 0),
                onOpeningTimeChanged: (TimeOfDay? time) {
                  if (time == null) return;
                  final newOpeningTime =
                      tradingDay.openingTime ?? DateTime.now();
                  if (mounted) {
                    setState(() {
                      tradingDay.openingTime = DateTime(
                        newOpeningTime.year,
                        newOpeningTime.month,
                        newOpeningTime.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                onClosingTimeChanged: (TimeOfDay? time) {
                  if (time == null) return;
                  final newClosingTime =
                      tradingDay.closingTime ?? DateTime.now();
                  if (mounted) {
                    setState(() {
                      tradingDay.closingTime = DateTime(
                        newClosingTime.year,
                        newClosingTime.month,
                        newClosingTime.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                onDaySelectedChanged: (bool isSelected) {
                  if (mounted) {
                    setState(() {
                      tradingDay.isOpen = isSelected;
                    });
                  }
                },
                isInitiallySelected: tradingDay.isOpen,
                openingTime: timeOfDay(tradingDay.openingTime),
                closingTime: timeOfDay(tradingDay.closingTime),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSetupHomePage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        getOnlineStoreRoute(isTrue(vm.item?.isConfigured)),
        (_) => false,
      );
    }
  }

  String dayOfWeek(int dow) {
    switch (dow) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      case 8:
        return 'Public Holidays';
      default:
        return 'Other';
    }
  }

  TimeOfDay timeOfDay(DateTime? date) => TimeOfDay.fromDateTime(date!);
}
