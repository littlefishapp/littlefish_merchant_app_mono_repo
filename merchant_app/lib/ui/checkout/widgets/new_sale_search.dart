// import 'package:flutter/material.dart';
// import 'package:littlefish_merchant/app/theme/typography.dart';

// // TODO(lampian): make more configurable and a shared component called something like SearchTextField
// class NewSaleSearch extends StatelessWidget {
//   final void Function(String) onChanged;
//   const NewSaleSearch({
//     Key? key,
//     required this.searchController,
//     required this.onChanged,
//   }) : super(key: key);

//   final TextEditingController searchController;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: searchController,
//       onChanged: onChanged,
//       cursorColor: Colors.grey,
//       style: context.styleParagraphSmallRegular,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         filled: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: BorderSide.none,
//         ),
//         hintText: 'Search',
//         hintStyle: context.styleParagraphSmallRegular,
//         prefixIcon: Icon(
//           Icons.search,
//           size: 24.0,
//           color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 12),
//       ),
//     );
//   }
// }
