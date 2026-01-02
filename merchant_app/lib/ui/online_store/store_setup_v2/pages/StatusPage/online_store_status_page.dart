// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, implementation_imports
//Flutter imports
import 'package:flutter/material.dart';
//package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
//project imports
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/online/publish_store_validator.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

class OnlineStoreStatusPage extends StatefulWidget {
  static const route = 'online-store/landing-page';

  const OnlineStoreStatusPage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreStatusPage> createState() => _OnlineStoreStatusPageState();
}

class _OnlineStoreStatusPageState extends State<OnlineStoreStatusPage> {
  bool? _isPublished;

  @override
  void initState() {
    _isPublished = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) async {
        var onlineStore = store.state.storeState.store;
        _isPublished = onlineStore?.isPublic ?? false;
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        _isPublished = vm.item?.isPublic ?? false;
        return scaffold(vm, context);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm, BuildContext context) {
    return AppScaffold(
      title: 'Online Store Status',
      centreTitle: false,
      body: vm.isLoading != true
          ? layout(vm, context)
          : const AppProgressIndicator(),
      persistentFooterButtons: [_previewOnlineStoreButton(vm, context)],
      enableProfileAction: false,
    );
  }

  layout(ManageStoreVMv2 vm, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: _isPublished == true ? Colors.green : Colors.red,
            child: Center(
              child: Text(
                'Your store is currently ${_isPublished == true ? 'Live' : 'unpublished'}',
              ),
            ),
          ),
          _publishField(vm, context),
        ],
      ),
    );
  }

  Widget _publishField(ManageStoreVMv2 vm, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      child: YesNoFormField(
        key: const Key('isPublished'),
        padding: const EdgeInsets.all(0),
        labelText: 'Publish Online Store',
        initialValue: _isPublished ?? false,
        onSaved: (value) async {
          if (value == false) {
            getIt<ModalService>()
                .showActionModal(
                  context: context,
                  title: 'Unpublish Online Store?',
                  description: _textUnpublishContent(),
                  acceptText: 'Yes, Unpublish Store',
                  cancelText: 'No, Cancel',
                )
                .then((confirm) async {
                  if (confirm == true && mounted) {
                    var store = vm.item;
                    store!.isPublic = value;
                    await vm.upsertStore(store);
                    setState(() {
                      _isPublished = value;
                    });
                  }
                });
          } else {
            getIt<ModalService>()
                .showActionModal(
                  context: context,
                  title: 'Publish Online Store?',
                  description: _textPublishContent(),
                  acceptText: 'Yes, Publish Store',
                  cancelText: 'No, Cancel',
                )
                .then((confirm) async {
                  if (confirm == true) {
                    PublishStoreValidatorResponse validationResponse =
                        PublishStoreValidator.validateStore(vm);
                    if (validationResponse !=
                        PublishStoreValidatorResponse.success) {
                      showMessageDialog(
                        context,
                        PublishStoreValidator.getValidationMessage(
                          validationResponse,
                        ),
                        LittleFishIcons.error,
                      );
                      return;
                    }
                    vm.publishStore(context);
                  }
                });
          }
        },
      ),
    );
  }

  _textUnpublishContent() =>
      'Are you sure you want to unpublish your online store? Your customers will not be able to view your catalogue or make purchase while your store is unpublished.';
  _textPublishContent() =>
      'Are you sure you want to publish your online store? Your online store will be reviewed by the bank and upon approval customers will be able to view your catalogue and make purchases. ';

  _previewOnlineStoreButton(ManageStoreVMv2 vm, BuildContext context) {
    return ButtonPrimary(
      text: 'Preview Online Store',
      upperCase: false,
      buttonColor: Theme.of(context).colorScheme.secondary,
      onTap: (_) async {
        try {
          Uri url = Uri.parse(vm.item!.storeUrl!);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        } catch (e) {
          showMessageDialog(
            context,
            'Could not find store url',
            LittleFishIcons.error,
          );
        }
      },
    );
  }
}
