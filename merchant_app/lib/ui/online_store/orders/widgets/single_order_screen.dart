import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/orders/charge/order_charge_screen.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';

import '../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../tools/textformatter.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/form_fields/email_form_field.dart';
import '../../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import '../../../../common/presentaion/components/decorated_text.dart';
import '../../../../common/presentaion/components/long_text.dart';

class SingleOrderScreen extends StatefulWidget {
  final ManageStoreVM? vm;
  final CheckoutOrder? item;
  final Function(CheckoutOrder? item)? onTap;
  final bool actionable;
  final bool pending;
  const SingleOrderScreen({
    Key? key,
    this.vm,
    required this.item,
    this.pending = false,
    this.actionable = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _summaryAreaKey = GlobalKey();
  // GlobalKey _categoriesKey = GlobalKey();
  // GlobalKey _onlineOrdersKey = GlobalKey();
  // GlobalKey _socialMediaKey = GlobalKey();
  final GlobalKey _orderNumberKey = GlobalKey();
  final GlobalKey _itemsTabKey = GlobalKey();
  final GlobalKey _timelineTabKey = GlobalKey();
  final GlobalKey _customerInfoTabKey = GlobalKey();
  final GlobalKey _orderNotesTabKey = GlobalKey();

  late ManageStoreVM _vm;
  late OrderStatus currentStatus;
  OrderStatus? nextStatus;
  TabController? _tabController;
  bool makePayment = false;
  // late ChatroomService chatroomService;
  TextEditingController? messageEditingController;
  // ScrollController? _chatScrollController;
  @override
  void dispose() {
    _tabController?.dispose();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  CheckoutOrder? item;

  @override
  void initState() {
    item = widget.item;
    _tabController = TabController(length: 4, vsync: this);
    var index = OrderStatusConstants.orderStatusFlow.indexWhere(
      (element) => element.id == item!.status,
    );

    currentStatus = OrderStatusConstants.orderStatusFlow[index];

    if (item!.isForDelivery == true &&
        item!.status == OrderStatusConstants.preparing.name) {
      index = index + 1;
    }

    if (item!.isForCollection == true &&
        item!.status == OrderStatusConstants.ready.name) {
      index = index + 1;
    }

    if (index == OrderStatusConstants.orderStatusFlow.length - 1) {
      nextStatus = OrderStatus(displayName: 'N/A');
    } else {
      nextStatus = OrderStatusConstants.orderStatusFlow[++index];
    }

    if (item!.paymentStatus!.toLowerCase() == 'unpaid' &&
        nextStatus!.name == OrderStatusConstants.complete.name) {
      makePayment = true;
    }

    messageEditingController = TextEditingController();
    // _chatScrollController = ScrollController();
    // chatroomService = ChatroomService();

    super.initState();
  }

  _rebuild(bool val) {
    if (mounted) {
      setState(() {
        _vm.isLoading = val;
      });
    } else {
      setState(() {
        _vm.isLoading = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> tabHeaders = [
      Tab(text: 'Items', key: _itemsTabKey),
      Tab(text: 'Timeline', key: _timelineTabKey),
      Tab(text: 'Customer Info', key: _customerInfoTabKey),
      Tab(text: 'Order Notes', key: _orderNotesTabKey),
      // Tab(text: S.of(context)!.chatLabel.toUpperCase()),
    ];

    final List<Widget> tabBodyContent = [
      Container(child: orderItems(context)),
      Container(child: details(context)),
      Container(child: customerInfoTab(context)),
      Material(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(item!.notes ?? 'No Notes', textAlign: TextAlign.center),
        ),
      ),
      // Container(
      //   child: chatTab(),
      // ),
    ];

    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (BuildContext context, ManageStoreVM vm) {
        _vm = vm;
        item = widget.item;

        return Scaffold(
          appBar: CustomAppBar(
            elevation: 0,
            title: Text(
              "#${item!.trackingNumber ?? '0'}",
              key: _orderNumberKey,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          persistentFooterButtons: <Widget>[
            if (item!.status != OrderStatusConstants.cancelled.name &&
                item!.status != OrderStatusConstants.complete.name &&
                !vm.isLoading! &&
                widget.actionable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ButtonBar(
                  buttonHeight: 44,
                  buttonMinWidth: (MediaQuery.of(context).size.width / 2) * 0.9,
                  children: <Widget>[
                    makePayment == false
                        ? ElevatedButton(
                            child: Text(nextStatus!.action!),
                            onPressed: () async {
                              // if (nextStatus!.name ==
                              //     OrderStatusConstants.complete.name) {
                              //   var res = await showPopupDialog(
                              //     defaultPadding: false,
                              //     context: context,
                              //     content: InputModal(
                              //       title: "Verify OTP",
                              //       description:
                              //           "Ask the customer for their order OTP",
                              //       inputTitle: "One Time Pin",
                              //     ),
                              //   );

                              //   if (res != null) {
                              //     if (res != item!.events!.last.details) {
                              //       showMessageDialog(context,
                              //           "OTP's don't Match", LittleFishIcons.error);
                              //     } else {
                              //       try {
                              //         _rebuild(true);

                              //         _vm.updateOrder(
                              //           context,
                              //           item,
                              //           nextStatus,
                              //         );
                              //       } catch (e) {
                              //         showErrorDialog(context, e);
                              //         _rebuild(false);
                              //       }
                              //     }
                              //   }
                              // } else {
                              try {
                                _rebuild(true);

                                _vm.updateOrder(context, item, nextStatus);
                              } catch (e) {
                                showErrorDialog(context, e);
                                _rebuild(false);
                              }
                              //}
                            },
                          )
                        : ElevatedButton(
                            child: const Text('Make Payment'),
                            onPressed: () async {
                              try {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return OrderChargeScreen(item: item);
                                    },
                                  ),
                                );
                              } catch (e) {
                                showErrorDialog(context, e);
                                if (mounted) {
                                  setState(() {
                                    _vm.isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    _vm.isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                    // SizedBox(width: 12),
                    ElevatedButton(
                      // TODO(lampian): fix color
                      // color: Colors.red,
                      child: const Text('Cancel Order'),
                      onPressed: () async {
                        if (mounted) {
                          setState(() {
                            _vm.isLoading = true;
                          });
                        } else {
                          setState(() {
                            _vm.isLoading = true;
                          });
                        }

                        _vm.cancelOrder(context, item);
                      },
                    ),
                  ],
                ),
              ),
          ],
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_vm.isLoading!) const LinearProgressIndicator(),
                Container(
                  // flex: 2,
                  child: orderSummary(context),
                ),
                Expanded(
                  flex: 1,
                  child: TabBar(
                    onTap: (value) {
                      if (mounted) setState(() {});
                    },
                    controller: _tabController,
                    isScrollable: true,
                    tabs: tabHeaders,
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: tabBodyContent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView details(context) => ListView.separated(
    separatorBuilder: (ctx, index) => const CommonDivider(),
    physics: const BouncingScrollPhysics(),
    itemCount: item?.events?.length ?? 0,
    itemBuilder: (ctx, index) {
      var event = item!.events![index];
      var eventStatus = OrderStatusConstants.orderStatusFlow.firstWhereOrNull(
        (element) => element.displayName == event.title,
      );
      return ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        trailing: Icon(
          Icons.timer,
          color: HexColor(
            eventStatus?.color ?? Colors.grey.value.toRadixString(16),
          ),
        ),
        title: Text(event.title!),
        subtitle: LongText(
          '${TextFormatter.toShortDate(dateTime: event.eventDate)} at ${event.eventDate!.hour}:${event.eventDate!.minute}',
        ),
      );
    },
  );

  ListView customerInfoTab(context) => ListView(
    physics: const BouncingScrollPhysics(),
    children: <Widget>[
      Material(
        child: SizedBox(
          height: 62,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: <Widget>[
                const Icon(FontAwesomeIcons.user, size: 20),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 4),
                      DecoratedText(
                        item!.billing?.firstName ?? 'John',
                        fontSize: 24,
                      ),
                      const SizedBox(width: 4),
                      DecoratedText(
                        item!.billing?.lastName ?? 'Doe',
                        fontSize: 24,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: EmailFormField(
          textColor: Theme.of(context).colorScheme.onBackground,
          iconColor: Theme.of(context).colorScheme.onBackground,
          hintColor: Theme.of(context).colorScheme.onBackground,
          enabled: false,
          enforceMaxLength: false,
          maxLength: 255,
          hintText: 'bob@gmail.com',
          key: const Key('email'),
          initialValue: item!.billing?.email ?? 'john@gmail.com',
          labelText: 'Email Address',
          inputAction: TextInputAction.done,
          onSaveValue: (String? value) {},
          onFieldSubmitted: (value) {},
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: MobileNumberFormField(
          enabled: false,
          hintText: '27823743844',
          key: const Key('mobile'),
          labelText: 'Mobile Number',
          initialValue: item!.billing?.phone ?? '27 79 496 8222',
          inputAction: TextInputAction.done,
          onSaveValue: (value) {
            // customer.mobileNumber = value;
          },
          onFieldSubmitted: (value) {
            // customer.mobileNumber = value;
          },
        ),
      ),
      if (item!.hasBillingAddress)
        Material(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(item!.billing!.toStringAddress()),
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Tooltip(
            message: item!.billing!.phone ?? '27 79 496 8222',
            child: ClipOval(
              child: InkWell(
                onTap: () => launchTel(
                  context,
                  item!.billing!.phone ?? '27 79 496 8222',
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.phone, size: 48),
                ),
              ),
            ),
          ),
          Tooltip(
            message: item!.billing!.email ?? 'john@gmail.com',
            child: ClipOval(
              child: InkWell(
                onTap: () => launchEmail(
                  context,
                  item!.billing!.email ?? 'john@gmail.com',
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(Icons.email, size: 48),
                ),
              ),
            ),
          ),
          Tooltip(
            message: item!.billing!.phone ?? '27 79 496 8222',
            child: ClipOval(
              child: InkWell(
                onTap: () => launchWhatsapp(
                  context,
                  mobile: item!.billing!.phone ?? '27 79 496 8222',
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          if (item!.isForDelivery!)
            Tooltip(
              message: 'Directions',
              child: ClipOval(
                child: InkWell(
                  onTap: () => launchMaps(
                    item!.userLocation!.location?.latitude,
                    item!.userLocation!.location?.longitude,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.directions, size: 48),
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );

  ListView orderItems(context) => ListView.separated(
    separatorBuilder: (ctx, index) => const CommonDivider(),
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: item!.items?.length ?? 0,
    itemBuilder: (ctx, index) {
      var current = item!.items![index];

      return ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        leading: Material(
          elevation: 2.0,
          color: HexColor(
            currentStatus.color ?? Colors.grey.value.toRadixString(16),
          ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            height: 44,
            width: 44,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text(
              current.quantity!.toInt().toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
        title: Text('${current.name}'),
        subtitle: isNotBlank(current.varianceName)
            ? Text(current.varianceName!.replaceAll('#', ' '))
            : Text(
                "Unit Price: ${TextFormatter.toStringCurrency(current.unitSellingPrice, currencyCode: '')}",
              ),
        trailing: Text(
          TextFormatter.toStringCurrency(
            current.totalAmount,
            displayCurrency: false,
            currencyCode: '',
          ),
          style: const TextStyle(fontSize: 18),
        ),
      );
    },
  );

  Material orderSummary(context) => Material(
    child: Container(
      key: _summaryAreaKey,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DecoratedText(
                TextFormatter.toStringCurrency(
                  item!.totalDueByCustomer,
                  displayCurrency: false,
                  currencyCode: '',
                ),
                fontSize: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: DecoratedText(
                  'Placed: ${timeago.format(item!.orderDate!)}',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(currentStatus.displayName!),
              const SizedBox(width: 4),
              Icon(
                Icons.timer,
                color: HexColor(
                  currentStatus.color ?? Colors.grey.value.toRadixString(16),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Form form(context) {
    final BasicFormModel formModel = BasicFormModel(formKey);

    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text('Selected Order', style: TextStyle(fontSize: 24)),
          ),
          if (widget.onTap != null)
            ElevatedButton(
              child: Text('Go to Payment'.toUpperCase()),
              onPressed: () async {
                if (mounted) {
                  setState(() {
                    _vm.isLoading = true;
                  });
                } else {
                  setState(() {
                    _vm.isLoading = true;
                  });
                }
                widget.onTap!(item);
              },
            ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Name',
                    key: const Key('name'),
                    enabled: false,
                    labelText: 'Customer Name',
                    focusNode: formModel.setFocusNode('name'),
                    initialValue: item!.customerName,
                    onFieldSubmitted: (value) {
                      // item.customerName = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: true,
                    onSaveValue: (value) {
                      // item.customerName = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Designed to use electricity',
                    key: const Key('description'),
                    labelText: 'Date Placed',
                    enabled: false,
                    focusNode: formModel.setFocusNode('description'),
                    initialValue: item!.orderDate!.toIso8601String(),
                    onFieldSubmitted: (value) {
                      // item.description = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: false,
                    onSaveValue: (value) {
                      // item.description = value;
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    ];

    return Form(
      key: formModel.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }

  // chats() {
  //   return StreamBuilder(
  //       stream: chatroomService.getOrderChat(item!.orderId),
  //       builder: (ctx, snapshot) {
  //         if (snapshot.hasData == false)
  //           return Container(
  //             child: LinearProgressIndicator(),
  //           );

  //         var chats = snapshot.data as List<Chat>?;

  //         return snapshot.hasData
  //             ? Container(
  //                 margin: const EdgeInsets.only(top: 12),
  //                 child: ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: BouncingScrollPhysics(),
  //                     itemCount: chats!.length + 1,
  //                     controller: _chatScrollController,
  //                     itemBuilder: (context, index) {
  //                       if (index == chats.length)
  //                         return SizedBox(
  //                           height: 200,
  //                         );

  //                       var chat = chats[index];

  //                       return MessageTile(
  //                         message: chat.message,
  //                         sendbyMe: (item!.businessId ?? item!.storeId) ==
  //                             chat.sentBy,
  //                         time: chat.time,
  //                       );
  //                     }),
  //               )
  //             : Container();
  //       });
  // }

  // chatTab() {
  // return chats();
  // }

  // sendMessage() {
  //   if (messageEditingController!.text.isNotEmpty) {
  //     var message = Chat(
  //       chatId: Uuid().v4(),
  //       sentBy: item!.businessId ?? item!.storeId,
  //       message: messageEditingController!.text,
  //       time: DateTime.now().millisecondsSinceEpoch,
  //       businessId: item!.businessId ?? item!.storeId,
  //       businessName: item!.storeName,
  //       username: item!.customerName,
  //       userId: item!.customerId,
  //     );

  //     chatroomService.sendMessageFromOrder(
  //       item!.orderId,
  //       message,
  //     );
  //     messageEditingController!.text = "";

  //     setState(() {});

  //     Timer(
  //       Duration(milliseconds: 100),
  //       () => _chatScrollController!
  //           .jumpTo(_chatScrollController!.position.maxScrollExtent),
  //     );
  //   }
  // }
}
