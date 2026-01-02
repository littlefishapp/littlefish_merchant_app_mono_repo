// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class BusinessProfileCreateVM
    extends StoreItemViewModel<BusinessProfile?, BusinessState> {
  BusinessProfileCreateVM.fromStore(Store<AppState> store)
    : super.fromStore(store);

  late FormManager form;

  BusinessType? selectedType;

  Function? reset;

  // Function(String code, BuildContext ctx) onJoin;

  String? inviteCode;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.businessState;
    onAdd = (item, ctx) => store.dispatch(
      registerBusiness(
        item,
        completer: snackBarCompleter(
          ctx!,
          'Your profile has been saved successfully!',
        ),
      ),
    );

    // this.onJoin = (String code, ctx) {
    //   store.dispatch(
    //     joinBusiness(
    //       code,
    //       completer: snackBarCompleter(
    //         ctx,
    //         "Welcome, let's get to it!",
    //       ),
    //     ),
    //   );
    // };

    reset = () => store.dispatch(
      loadBusinessProfile(
        refresh: true,
        completer: snackBarCompleter(context!, 'profile reset'),
      ),
    );

    item = state!.profile;
    hasError = state!.hasError;
    isLoading = state!.isLoading ?? false;
  }
}

class BusinessProfileVM
    extends StoreItemViewModel<BusinessProfile, BusinessState> {
  BusinessProfileVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late Function reset;

  GlobalKey<FormState>? receiptKey;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.businessState;
    item = state!.profile;
    this.store = store;
    isLoading = state!.isLoading;
    isNew = false;

    reset = (ctx) => store.dispatch(
      loadBusinessProfile(
        refresh: true,
        completer: snackBarCompleter(context ?? ctx, 'profile reset'),
      ),
    );

    onAdd = (item, ctx) {
      if (key != null && (key!.currentState?.validate() ?? false)) {
        key!.currentState!.save();

        store.dispatch(
          updateBusinessProfile(
            item,
            completer: snackBarCompleter(
              ctx!,
              'Your business has been saved successfully!',
              shouldPop: false,
            ),
          ),
        );
      }
    };
  }

  onSave(
    BusinessProfile? item,
    BuildContext ctx, {
    bool navigateToHome = false,
  }) {
    if (key != null && (key!.currentState?.validate() ?? false)) {
      key!.currentState!.save();

      store!.dispatch(
        updateBusinessProfile(
          item,
          completer: snackBarCompleter(
            ctx,
            'Your business has been saved successfully!',
            shouldPop: false,
          ),
          navigateToHome: navigateToHome,
        ),
      );
    }
  }
}
