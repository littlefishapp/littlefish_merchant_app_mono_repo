import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BrandInformation/online_store_brand_info_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_manage_business_information.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DeliveryandCollection/online_store_manage_delivery_collection.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/ProductCatalogue/online_store_publish_products_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class StoreHelper {
  static List<StoreSection> createSectionList(
    BuildContext context,
    ManageStoreVMv2 vm,
  ) {
    return List.generate(OnlineStoreSectionType.values.length, (index) {
      OnlineStoreSectionType enumType = OnlineStoreSectionType.values[index];
      return StoreSection(
        title: getSectionTitle(enumType),
        icon: getSectionIconData(enumType),
        onTap: getSectionOnTap(enumType, context, vm),
        description: getSectionDescription(enumType),
      );
    });
  }

  static String getSectionTitle(OnlineStoreSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSectionType.businessInformation:
        return 'Business Information';
      case OnlineStoreSectionType.productCatalogue:
        return 'Products';
      case OnlineStoreSectionType.featuredCategories:
        return 'Featured Categories';
      case OnlineStoreSectionType.customiseOnlineStore:
        return 'Customise Online Store';
      case OnlineStoreSectionType.deliveryAndCollection:
        return 'Delivery and Collection';
      default:
        return 'Other';
    }
  }

  static String getSectionDescription(OnlineStoreSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSectionType.businessInformation:
        return 'View & manage business information';
      case OnlineStoreSectionType.productCatalogue:
        return 'Add, edit & organise online store';
      case OnlineStoreSectionType.featuredCategories:
        return 'Select which Categories to feature on your online store home page.';
      case OnlineStoreSectionType.customiseOnlineStore:
        return 'Edit store layout, colours and design';
      case OnlineStoreSectionType.deliveryAndCollection:
        return 'View and manage orders';
      default:
        return 'Setup additional aspects of your online store.';
    }
  }

  static IconData getSectionIconData(OnlineStoreSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSectionType.businessInformation:
        return LittleFishIcons.info;
      case OnlineStoreSectionType.productCatalogue:
        return Icons.inventory_2_outlined;
      case OnlineStoreSectionType.featuredCategories:
        return Icons.category_outlined;
      case OnlineStoreSectionType.customiseOnlineStore:
        return Icons.color_lens_outlined;
      case OnlineStoreSectionType.deliveryAndCollection:
        return Icons.local_shipping_outlined;
      default:
        return Icons.settings;
    }
  }

  static VoidCallback getSectionOnTap(
    OnlineStoreSectionType sectionName,
    BuildContext context,
    ManageStoreVMv2 vm,
  ) {
    switch (sectionName) {
      case OnlineStoreSectionType.businessInformation:
        return () => Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) => OnlineStoreManageBusinessInformation(vm: vm),
          ),
        );
      case OnlineStoreSectionType.customiseOnlineStore:
        return () => Navigator.of(
          context,
        ).push(CustomRoute(builder: (ctx) => const OnlineStoreBrandInfoPage()));
      case OnlineStoreSectionType.productCatalogue:
        if (vm.inStoreProducts.isNotEmpty || vm.onlineProducts.isNotEmpty) {
          return () => Navigator.of(context).push(
            CustomRoute(
              builder: (ctx) => const OnlineStorePublishProductsPage(),
            ),
          );
        }
        return () => Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) =>
                const ProductPage(pageContext: ProductPageContext.onlineStore),
            // const OnlineStoreAddProductPage(),
          ),
        );
      case OnlineStoreSectionType.featuredCategories:
        if (vm.inStoreCategories.isNotEmpty || vm.onlineCategories.isNotEmpty) {
          return () => Navigator.of(context).push(
            CustomRoute(
              builder: (ctx) => const OnlineStorePublishCategoriesPage(),
            ),
          );
        }
        return () => Navigator.of(context).push(
          CustomRoute(builder: (ctx) => const OnlineStoreAddCategoryPage()),
        );

      case OnlineStoreSectionType.deliveryAndCollection:
        return () => Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) => OnlineStoreManageDeliveryAndCollection(vm: vm),
          ),
        );
      default:
        return () {}; // do nothing
    }
  }
}

class StoreSection {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  StoreSection({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.description,
  });
}
