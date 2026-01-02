// import 'package:littlefish_ecommerce_shared/models/products/category.dart';
// import 'package:littlefish_ecommerce_shared/models/products/product.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';
// import 'package:littlefish_seller/shared/service_base.dart';
// import 'package:redux/src/store.dart';
// import 'package:uuid/uuid.dart';

// class ProductService extends ServiceBase {
//   ProductService.fromStore(Store<AppState> store) : super.fromStore(store);

//   Future<List<Product>> getProductsByCategory(String categoryId) async {
//     //ToDo: look for all local products that we have for this category - they should not be returned from the server

//     //run a count of local products for category vs products on server, if different pull products

//     //if all products 'pull date' are in line with what is expected do not pull from server / else pull prices in the background for said items in the background

//     //pull and perform logic above based on paging sequences (i.e. get the max from the server vs local and run the pagination as expected)

//     return [
//       Product(
//           sellingPrice: 25,
//           costPrice: 17.5,
//           hasStock: true,
//           id: 'product1',
//           name: 'Product One',
//           description: 'Amazing Product',
//           compareAtPrice: 22.5,
//           imageUri:
//               'https://lh3.googleusercontent.com/LeaFnEyHbRwQMbGJo8X56tlRXlJuZBFCD4bswA8plYFbFu3-M1UD7HS9vyFvX_B_OxHhO9a667LyQpH_I5nfhA=s750',
//           variants: [
//             Variant(
//               name: 'Size',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Small'),
//                 VariantOption(value: 'Medium'),
//                 VariantOption(value: 'Large'),
//               ],
//             ),
//             Variant(
//               name: 'Color',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Red'),
//                 VariantOption(value: 'Blue'),
//                 VariantOption(value: 'Orange'),
//                 VariantOption(value: 'Green'),
//               ],
//             )
//           ]),
//       Product(
//           sellingPrice: 25,
//           costPrice: 17.5,
//           hasStock: true,
//           id: 'product2',
//           name: 'Product 2',
//           imageUri:
//               'https://lh3.googleusercontent.com/LeaFnEyHbRwQMbGJo8X56tlRXlJuZBFCD4bswA8plYFbFu3-M1UD7HS9vyFvX_B_OxHhO9a667LyQpH_I5nfhA=s750',
//           description: 'Amazing Product',
//           compareAtPrice: 22.5,
//           variants: [
//             Variant(
//               name: 'Size',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Small'),
//                 VariantOption(value: 'Medium'),
//                 VariantOption(value: 'Large'),
//               ],
//             ),
//             Variant(
//               name: 'Color',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Red'),
//                 VariantOption(value: 'Blue'),
//                 VariantOption(value: 'Orange'),
//                 VariantOption(value: 'Green'),
//               ],
//             )
//           ]),
//       Product(
//           sellingPrice: 25,
//           costPrice: 17.5,
//           hasStock: true,
//           id: 'product3',
//           name: 'Product 3',
//           imageUri:
//               'https://lh3.googleusercontent.com/LeaFnEyHbRwQMbGJo8X56tlRXlJuZBFCD4bswA8plYFbFu3-M1UD7HS9vyFvX_B_OxHhO9a667LyQpH_I5nfhA=s750',
//           description: 'Amazing Product',
//           compareAtPrice: 22.5,
//           variants: [
//             Variant(
//               name: 'Size',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Small'),
//                 VariantOption(value: 'Medium'),
//                 VariantOption(value: 'Large'),
//               ],
//             ),
//             Variant(
//               name: 'Color',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Red'),
//                 VariantOption(value: 'Blue'),
//                 VariantOption(value: 'Orange'),
//                 VariantOption(value: 'Green'),
//               ],
//             )
//           ]),
//       Product(
//           sellingPrice: 25,
//           costPrice: 17.5,
//           hasStock: true,
//           id: 'product4',
//           name: 'Product 4',
//           imageUri:
//               'https://lh3.googleusercontent.com/LeaFnEyHbRwQMbGJo8X56tlRXlJuZBFCD4bswA8plYFbFu3-M1UD7HS9vyFvX_B_OxHhO9a667LyQpH_I5nfhA=s750',
//           description: 'Amazing Product',
//           compareAtPrice: 22.5,
//           variants: [
//             Variant(
//               name: 'Size',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Small'),
//                 VariantOption(value: 'Medium'),
//                 VariantOption(value: 'Large'),
//               ],
//             ),
//             Variant(
//               name: 'Color',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Red'),
//                 VariantOption(value: 'Blue'),
//                 VariantOption(value: 'Orange'),
//                 VariantOption(value: 'Green'),
//               ],
//             )
//           ]),
//       Product(
//           sellingPrice: 25,
//           costPrice: 17.5,
//           hasStock: true,
//           id: 'product5',
//           name: 'Product Five',
//           imageUri:
//               'https://lh3.googleusercontent.com/LeaFnEyHbRwQMbGJo8X56tlRXlJuZBFCD4bswA8plYFbFu3-M1UD7HS9vyFvX_B_OxHhO9a667LyQpH_I5nfhA=s750',
//           description: 'Amazing Product',
//           compareAtPrice: 22.5,
//           variants: [
//             Variant(
//               name: 'Size',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Small'),
//                 VariantOption(value: 'Medium'),
//                 VariantOption(value: 'Large'),
//               ],
//             ),
//             Variant(
//               name: 'Color',
//               type: VariantType.size,
//               options: [
//                 VariantOption(value: 'Red'),
//                 VariantOption(value: 'Blue'),
//                 VariantOption(value: 'Orange'),
//                 VariantOption(value: 'Green'),
//               ],
//             )
//           ]),
//     ];
//   }

//   Future<List<Category>> getCategories() async {
//     return [
//       Category(
//         id: Uuid().v4(),
//         name: 'category 1',
//         description: 'category 1',
//         subCategories: [
//           Category(name: 'sub category 1', description: 'sub category 1'),
//           Category(name: 'sub category 2', description: 'sub category 2')
//         ],
//         products: [],
//       ),
//       Category(
//         id: Uuid().v4(),
//         name: 'category 2',
//         description: 'category 2',
//         subCategories: [
//           Category(name: 'sub category 1', description: 'sub category 1'),
//           Category(name: 'sub category 2', description: 'sub category 2')
//         ],
//         products: [],
//       ),
//       Category(
//         id: Uuid().v4(),
//         name: 'category 3',
//         description: 'category 3',
//         subCategories: [
//           Category(name: 'sub category 1', description: 'sub category 1'),
//           Category(name: 'sub category 2', description: 'sub category 2')
//         ],
//         products: [],
//       ),
//       Category(
//         id: Uuid().v4(),
//         name: 'category 4',
//         description: 'category 4',
//         subCategories: [
//           Category(name: 'sub category 1', description: 'sub category 1'),
//           Category(name: 'sub category 2', description: 'sub category 2')
//         ],
//         products: [],
//       ),
//       Category(
//         id: Uuid().v4(),
//         name: 'category 5',
//         description: 'category 5',
//         subCategories: [
//           Category(name: 'sub category 1', description: 'sub category 1'),
//           Category(name: 'sub category 2', description: 'sub category 2')
//         ],
//         products: [],
//       ),
//     ];
//   }
// }
