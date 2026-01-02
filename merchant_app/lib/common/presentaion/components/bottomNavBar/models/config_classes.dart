import '../../../../../models/workspaces/workspace.dart';
import '../bottom_navbar.dart';

class NavBarConfig {
  late PageType pageType;
  late String description;

  NavBarConfig({required this.pageType, required this.description});

  NavBarConfig.fromJson(Map<String, dynamic> json) {
    pageType = PageTypeHelper.getPageType(json['pageType']);
    description = json['description'];
  }
}

class WorkSpaceData {
  late String name;
  late List<NavBarConfig> navbarConfig;
  late List<NavBarConfig>? allNavBarConfig;

  WorkSpaceData({required this.name, required this.navbarConfig});

  WorkSpaceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    navbarConfig = List<NavBarConfig>.from(
      (json['navbarConfig'] as List<dynamic>).map(
        (e) => NavBarConfig.fromJson(e),
      ),
    );
  }

  WorkSpaceData.fromWorkspace(Workspace workspace) {
    name = workspace.name;
    navbarConfig = workspace.navbarConfig
        .map(
          (e) => NavBarConfig(
            pageType: PageTypeHelper.getPageType(e.pageType),
            description: e.description ?? '',
          ),
        )
        .toList();
  }

  WorkSpaceData.fromWorkspaceList(List<Workspace> workspaces) {
    allNavBarConfig = [];
    for (var workspace in workspaces) {
      for (var navbar in workspace.navbarConfig) {
        allNavBarConfig?.add(
          NavBarConfig(
            pageType: PageTypeHelper.getPageType(navbar.pageType),
            description: navbar.description ?? '',
          ),
        );
      }
    }
  }
}

class PageTypeHelper {
  static PageType getPageType(String value) {
    switch (value) {
      case 'Home':
        return PageType.home;
      case 'Sell':
        return PageType.sell;
      case 'Sales':
        return PageType.sales;
      case 'Orders':
        return PageType.orderFulfillment;
      case 'Products':
        return PageType.products;
      case 'Stock':
        return PageType.stock;
      case 'EStore':
        return PageType.eStore;
      case 'More':
        return PageType.more;
      case 'GetPaid':
        return PageType.getPaid;
      default:
        throw Exception('Invalid pageType');
    }
  }
}
