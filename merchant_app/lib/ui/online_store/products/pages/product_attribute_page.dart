// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';

class ProductAttributePage extends StatefulWidget {
  final StoreProductAttribute? attribute;

  final StoreProduct product;

  const ProductAttributePage({
    Key? key,
    required this.attribute,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductAttributePage> createState() => _ProductAttributePageState();
}

class _ProductAttributePageState extends State<ProductAttributePage> {
  bool _isLoading = false;

  setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    } else {
      _isLoading = value;
    }
  }

  StoreProductAttribute? item;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    item = widget.attribute;
    super.initState();

    item ??= StoreProductAttribute.create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.attribute == null ? 'New Attribute' : 'Edit Attribute',
        ),
        centerTitle: true,
        actions: widget.attribute != null
            ? <Widget>[
                IconButton(
                  icon: const DeleteIcon(),
                  onPressed: () async {
                    setLoading(true);

                    try {
                      await getIt<ModalService>()
                          .showActionModal(
                            context: context,
                            title: 'Delete item?',
                            description:
                                'Are you sure you want to delete this item?',
                            acceptText: 'Delete',
                            cancelText: 'Cancel',
                          )
                          .then((value) async {
                            if (!value!) return;

                            await widget.product.deleteAttribute(
                              widget.attribute!,
                            );
                          });
                      //close this window, nothing more to do here..
                      Navigator.of(context).pop();
                    } catch (error) {
                      reportCheckedError(error, trace: StackTrace.current);
                    } finally {
                      setLoading(false);
                    }
                  },
                ),
              ]
            : null,
      ),
      persistentFooterButtons: _isLoading
          ? null
          : [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: Text('Save'.toUpperCase()),
                  onPressed: () async {
                    setLoading(true);

                    try {
                      if (!_formKey.currentState!.validate()) return;

                      //force the save....
                      _formKey.currentState!.save();

                      await widget.product.saveAttribute(item!);

                      await showMessageDialog(
                        context,
                        'Saved Successfully',
                        Icons.check,
                      );

                      Navigator.of(context).pop();
                    } catch (e) {
                      reportCheckedError(e);

                      showMessageDialog(
                        context,
                        'Error',
                        LittleFishIcons.error,
                      );
                    } finally {
                      setLoading(false);
                    }
                  },
                ),
              ),
            ],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                if (_isLoading) const LinearProgressIndicator(),
                StringFormField(
                  hintText: 'Department',
                  key: const Key('name'),
                  labelText: 'Name',
                  initialValue: item!.name,
                  focusNode: _nodes[0],
                  nextFocusNode: _nodes[1],
                  maxLength: 50,
                  inputAction: TextInputAction.next,
                  onSaveValue: (value) {
                    item!.name = value;
                  },
                  onFieldSubmitted: (value) {
                    item!.name = value;
                  },
                ),
                StringFormField(
                  hintText: 'Men',
                  key: const Key('option'),
                  initialValue: item!.option,
                  labelText: 'Option',
                  maxLength: 50,
                  focusNode: _nodes[1],
                  onSaveValue: (value) {
                    item!.option = value;
                  },
                  onFieldSubmitted: (value) {
                    item!.option = value;
                  },
                  inputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
