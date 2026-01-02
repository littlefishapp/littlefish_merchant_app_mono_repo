import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BrandInformation/online_store_brand_info_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_details_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DomainName/online_store_domain_name_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/FeaturedCategories/online_store_add_category_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/FeaturedCategories/online_store_publish_categories_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DeliveryandCollection/delivery_preferences_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/ProductCatalogue/online_store_publish_products_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';

class StoreSetupHelper {
  List<StoreSetupSection> createSetupSectionList(
    BuildContext context,
    ManageStoreVMv2 vm,
  ) {
    debugPrint('#### OnlineStoreSetupHelper createSetupSectionList entry');
    final sections = List.generate(OnlineStoreSetupSectionType.values.length, (
      index,
    ) {
      OnlineStoreSetupSectionType enumType =
          OnlineStoreSetupSectionType.values[index];
      return StoreSetupSection(
        title: getSectionTitle(enumType),
        icon: getSectionIconData(enumType),
        isCompleted: isSectionComplete(enumType, vm),
        onTap: getSectionOnTap(enumType, context, vm),
        description: getSectionDescription(enumType),
      );
    });

    debugPrint(
      '#### OnlineStoreSetupHelper createSetupSectionList exit '
      'with ${sections.length} sections ',
    );
    return sections;
  }

  String getSectionTitle(OnlineStoreSetupSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSetupSectionType.businessInformation:
        return 'Business Information';
      case OnlineStoreSetupSectionType.productCatalogue:
        return 'Product Catalogue';
      case OnlineStoreSetupSectionType.featuredCategories:
        return 'Featured Categories';
      case OnlineStoreSetupSectionType.customiseOnlineStore:
        return 'Customise Online Store';
      case OnlineStoreSetupSectionType.deliveryAndCollection:
        return 'Delivery & Collection';
      case OnlineStoreSetupSectionType.domainName:
        return 'Domain Name';
    }
  }

  String getSectionDescription(OnlineStoreSetupSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSetupSectionType.businessInformation:
        return 'Save general information about your business, such as the name, business category, type of goods/services sold and business hours. ';
      case OnlineStoreSetupSectionType.productCatalogue:
        return 'Add your first product to your catalogue.';
      case OnlineStoreSetupSectionType.featuredCategories:
        return 'Select which Categories to feature on your online store home page.';
      case OnlineStoreSetupSectionType.customiseOnlineStore:
        return 'Upload your logo, set up your brand colours and visual styling for your online store.';
      case OnlineStoreSetupSectionType.deliveryAndCollection:
        return 'Provide information to help your customers know how you manage deliveries and collections.';
      case OnlineStoreSetupSectionType.domainName:
        return 'Claim your unique domain name that will be used in your website link.';
    }
  }

  IconData getSectionIconData(OnlineStoreSetupSectionType sectionName) {
    switch (sectionName) {
      case OnlineStoreSetupSectionType.businessInformation:
        return Icons.storefront;
      case OnlineStoreSetupSectionType.productCatalogue:
        return Icons.inventory_2_outlined;
      case OnlineStoreSetupSectionType.featuredCategories:
        return Icons.category_outlined;
      case OnlineStoreSetupSectionType.customiseOnlineStore:
        return Icons.color_lens_outlined;
      case OnlineStoreSetupSectionType.deliveryAndCollection:
        return Icons.local_shipping_outlined;
      case OnlineStoreSetupSectionType.domainName:
        return Icons.language_outlined;
    }
  }

  VoidCallback getSectionOnTap(
    OnlineStoreSetupSectionType sectionName,
    BuildContext context,
    ManageStoreVMv2 vm,
  ) {
    switch (sectionName) {
      case OnlineStoreSetupSectionType.businessInformation:
        return () => Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) => OnlineStoreDetailsPage(
              storeName: vm.item?.displayName,
              description: vm.item?.description,
              slogan: vm.item?.slogan,
            ),
          ),
        );
      case OnlineStoreSetupSectionType.customiseOnlineStore:
        return () => Navigator.of(
          context,
        ).push(CustomRoute(builder: (ctx) => const OnlineStoreBrandInfoPage()));
      case OnlineStoreSetupSectionType.productCatalogue:
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
          ),
        );
      case OnlineStoreSetupSectionType.featuredCategories:
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
      case OnlineStoreSetupSectionType.deliveryAndCollection:
        return () => Navigator.of(
          context,
        ).push(CustomRoute(builder: (ctx) => const DeliveryPreferencePage()));
      case OnlineStoreSetupSectionType.domainName:
        return () => Navigator.of(context).push(
          CustomRoute(builder: (ctx) => const OnlineStoreDomainNamePage()),
        );
    }
  }

  bool isSectionComplete(
    OnlineStoreSetupSectionType sectionName,
    ManageStoreVMv2 vm,
  ) {
    switch (sectionName) {
      case OnlineStoreSetupSectionType.businessInformation:
        return vm.isBusinessInfoSetupComplete();
      case OnlineStoreSetupSectionType.customiseOnlineStore:
        return vm.isBrandInfoComplete();
      case OnlineStoreSetupSectionType.productCatalogue:
        return vm.isProductCatalogueComplete();
      case OnlineStoreSetupSectionType.featuredCategories:
        return vm.isFeaturedCategoriesComplete();
      case OnlineStoreSetupSectionType.deliveryAndCollection:
        return vm.isDeliveryandCollectionComplete();
      case OnlineStoreSetupSectionType.domainName:
        return vm.isDomainNameComplete;
    }
  }

  bool isSectionEnabled(OnlineStoreSetupSectionType sectionName) {
    return true;
  }
}

class StoreSetupSection {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback onTap;

  StoreSetupSection({
    required this.title,
    required this.icon,
    required this.isCompleted,
    required this.onTap,
    required this.description,
  });
}
