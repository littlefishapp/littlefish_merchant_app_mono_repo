import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_icons/core/icon_provider.dart';
import 'package:littlefish_icons/providers/sbsa_icon_provider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

//SBSA ICON INJECTOR
class IconInjector {
  static Future<void> inject() async {
    LittleFishCore core = LittleFishCore.instance;

    var provider = SbsaIconProvider();

    core.registerLazyService<IconProvider>(() => provider);

    LittleFishIcons.setIconProvider(provider);
  }
}
