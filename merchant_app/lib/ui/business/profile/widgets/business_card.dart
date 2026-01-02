// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> vm) => Material(
        color: Colors.white,
        child: InkWell(
          onTap: () =>
              StoreProvider.of(context).dispatch(editBusinessProfile(context)),
          child: Container(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: OutlineGradientAvatar(
                    radius: 48.0,
                    child: DecoratedText(
                      vm.state.businessState.profile!.name!.substring(0, 2),
                      alignment: Alignment.center,
                      textColor: Theme.of(context).colorScheme.secondary,
                      fontSize: 36.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DecoratedText(
                  vm.state.businessState.profile?.name ?? 'no name',
                  alignment: Alignment.center,
                  fontSize: null,
                ),
                const SizedBox(height: 8),
                LongText(vm.state.businessState.profile!.type!.name),
                const SizedBox(height: 8),
                LongText(vm.state.businessState.profile!.category?.name ?? ''),
                const SizedBox(height: 8),
                const CommonDivider(width: 0.25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
