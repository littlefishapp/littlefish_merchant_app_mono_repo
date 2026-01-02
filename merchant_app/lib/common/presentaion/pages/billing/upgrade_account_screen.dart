// // Flutter imports:
// // remove ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';

// // Package imports:
// // import 'package:purchases_flutter/purchases_flutter.dart';

// // Project imports:
// import 'package:littlefish_merchant/app/app.dart';
// import 'package:littlefish_merchant/redux/billing/billing_actions.dart';
// import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
// import 'package:littlefish_merchant/common/presentaion/pages/billing/wave_clipper.dart';

// import '../../components/cards/card_neutral.dart';
// import '../../components/custom_app_bar.dart';

// class UpgradeAccountScreen extends StatefulWidget {
//   final bool isModal;
//   final bool showSkip;
//   final String? targetRoute;
//   final bool skipNavigatesToRoute;

//   const UpgradeAccountScreen({
//     Key? key,
//     this.showSkip = false,
//     this.isModal = false,
//     this.skipNavigatesToRoute = false,
//     this.targetRoute,
//   }) : super(key: key);

//   @override
//   State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
// }

// class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
//   int? currentLicense;
//   double circleSize = 8;
//   // StoreProduct? _selectedProduct;
//   double waveHeight = 44;
//   String saving = '';
//   // List<Package> get availablePackages =>
//   //     AppVariables.store!.state.billingState.availablePackages!;

//   @override
//   void initState() {
//     // _selectedProduct = availablePackages
//     //     .firstWhere((element) => element.packageType == PackageType.annual)
//     //     .storeProduct;

//     // var otherProduct = availablePackages
//     //     .firstWhere((element) => element.packageType == PackageType.monthly)
//     //     .storeProduct;

//     // saving = ((((otherProduct.price * 12) - _selectedProduct!.price) /
//     //             (otherProduct.price * 12)) *
//     //         100)
//     //     .toStringAsFixed(0);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       persistentFooterButtons:
//           AppVariables.store!.state.billingState.isLoading == false
//               ? [button(context)]
//               : null,
//       appBar: CustomAppBar(
//         leading: AppVariables.store!.state.billingState.isLoading == false
//             ? Container(
//                 margin: const EdgeInsets.only(right: 20),
//                 child: GestureDetector(
//                   onTap: () {
//                     if (widget.skipNavigatesToRoute) {
//                       AppVariables.store!
//                           .dispatch(SetShowBillingPageAction(false));
//                       Navigator.of(context).pushNamed(
//                         widget.targetRoute!,
//                         arguments: 'from_upgrade',
//                       );
//                     } else {
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: const Icon(Icons.close),
//                 ),
//               )
//             : const SizedBox.shrink(),
//         // centerTitle: false,
//         title: const Text(
//           'Choose your plan',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (AppVariables.store!.state.billingState.isLoading == true)
//                 const LinearProgressIndicator(),
//               widget.isModal
//                   ? SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       physics: const BouncingScrollPhysics(),
//                       child: products(context),
//                     )
//                   : products(context),
//               const SizedBox(height: 12),
//               freeTrial(context),
//               // SizedBox(height: 4),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: subscriptionDescription(context),
//               ),
//               // Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget freeTrial(BuildContext ctx) => Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text('All subscriptions have a '),
//             Text(
//               'INCLUDES 3 DAY FREE TRIAL',
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       );

//   Widget button(BuildContext context) => SizedBox(
//         // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         height: 48,
//         child: ButtonPrimary(
//           text: 'Subscribe',
//           onTap: _selectedProduct == null
//               ? null
//               : (ctx) async {
//                   AppVariables.store!.dispatch(SetBillingLoadingAction(true));
//                   if (mounted) setState(() {});
//                   // AppVariables.store!.dispatch(
//                   //   purchaseLicense(
//                   //     _selectedProduct!,
//                   //     context,
//                   //     completer: actionCompleter(context, () {
//                   //       Navigator.of(context).pop();
//                   //       if (widget.isModal == false)
//                   //         Navigator.of(context).pushNamed(widget.targetRoute!);
//                   //     }),
//                   //   ),
//                   // );
//                   await purchaseProductSubscription(_selectedProduct!, context);

//                   Navigator.of(context).pop();
//                   if (mounted) {
//                     setState(() {
//                       if (widget.isModal == false) {
//                         Navigator.of(context).pushNamed(widget.targetRoute!);
//                       }
//                     });
//                   }
//                 },
//         ),
//       );

//   Row products(BuildContext context) {
//     var productCards = availablePackages
//         .map((e) => productItem(context, product: e.storeProduct))
//         .toList();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: productCards,
//     );
//   }

//   Widget productItem(BuildContext context, {required StoreProduct product}) =>
//       SizedBox(
//         width: MediaQuery.of(context).size.width / 2.1,
//         child: CardNeutral(
//           elevation: _selectedProduct?.identifier == product.identifier ? 8 : 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: InkWell(
//             onTap: () {
//               if (mounted) {
//                 setState(() {
//                   _selectedProduct = product;
//                 });
//               }
//             },
//             child: Stack(
//               children: [
//                 if (product.identifier.contains('year')) //&& saving > 0)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           'Save $saving %',
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 Column(
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.symmetric(
//                         vertical: 8,
//                         horizontal: 8,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             child: Text(
//                               product.identifier.contains('month')
//                                   ? 'Monthly'
//                                   : 'Yearly',
//                               style: TextStyle(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 product.priceString,
//                                 style: _selectedProduct?.identifier ==
//                                         product.identifier
//                                     ? TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .secondary,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       )
//                                     : const TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 20,
//                                       ),
//                               ),
//                               Text(
//                                 product.identifier.contains('month')
//                                     ? '/mo'
//                                     : '/yr',
//                                 style: const TextStyle(
//                                   color: Colors.black26,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Billed ${product.identifier.contains('month') ? 'Monthly' : 'Yearly'}',
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: RotatedBox(
//                         quarterTurns: 2,
//                         child: Stack(
//                           children: [
//                             Opacity(
//                               //semi red clippath with more height and with 0.5 opacity
//                               opacity: 0.4,
//                               child: ClipPath(
//                                 clipper:
//                                     WaveClipper(), //set our custom wave clipper
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(8),
//                                       topRight: Radius.circular(8),
//                                     ),
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                   ),
//                                   // width: 100,
//                                   height: _selectedProduct?.identifier ==
//                                           product.identifier
//                                       ? waveHeight + 12
//                                       : waveHeight,
//                                 ),
//                               ),
//                             ),
//                             ClipPath(
//                               clipper:
//                                   WaveClipper(), //set our custom wave clipper
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(8),
//                                     topRight: Radius.circular(8),
//                                   ),
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ), // width: 100,
//                                 height: _selectedProduct?.identifier ==
//                                         product.identifier
//                                     ? waveHeight + 2
//                                     : waveHeight - 4,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//   Column subscriptionDescription(BuildContext context) {
//     List<Widget> items = [];
//     items.addAll([
//       const SizedBox(height: 16),
//       const Text(
//         'With any Subsciption you get',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     ]);

//     items.addAll(
//       AppVariables.store!.state.environmentSettings!.paidFeaturesList!
//           .map(
//             (e) => subscriptionOption(e),
//           )
//           .toList(),
//     );

//     items.addAll([
//       const SizedBox(height: 16),
//       const Text(
//         'Please note that the purchase will be applied to your Google Play Account',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     ]);

//     items.addAll([
//       const SizedBox(height: 16),
//       Text(
//         'This means that your subscription will automatically renew, depending on the option you have chosen. It is also possible to cancel your subscription, but only within the first 24 hours since making the purchase, and then the transaction cannot be refunded.',
//         style: TextStyle(color: Colors.grey.shade400),
//       ),
//     ]);

//     items.addAll([
//       const SizedBox(height: 16),
//       Row(
//         children: [
//           Text(
//             'By Continuing you accept our ',
//             style: TextStyle(color: Colors.grey.shade400),
//           ),
//           Text(
//             "T's and C's",
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.secondary,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ],
//       ),
//     ]);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: items,
//     );
//   }

//   Widget subscriptionOption(String option) => Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         child: Text(
//           '- $option',
//           style: TextStyle(color: Colors.grey.shade400),
//         ),
//       );
// }
