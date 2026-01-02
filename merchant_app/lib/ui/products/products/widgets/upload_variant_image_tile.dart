import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:littlefish_merchant/injector.dart';

class UploadVariantImageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUri;
  final String? productId;
  final void Function(String? imageUri) onUploaded;

  const UploadVariantImageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onUploaded,
    this.imageUri,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: _buildLeadingIcon(context, productId, imageUri),
      title: context.labelMediumBold(title),
      subtitle: context.labelSmall(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildLeadingIcon(
    BuildContext context,
    String? productId,
    String? imageUri,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            image: isNotBlank(imageUri)
                ? DecorationImage(
                    image: getIt<FlutterNetworkImage>().asImageProviderById(
                      id: productId ?? '',
                      category: 'products',
                      legacyUrl: imageUri!,
                      height: 56.0,
                      width: 56.0,
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: isBlank(imageUri) ? const Icon(Icons.image_outlined) : null,
        ),
        Positioned(
          right: -6,
          bottom: -6,
          child: GestureDetector(
            onTap: () async {
              String? imageUrl = await uploadImage(
                context,
                productId,
                imageUri,
              );

              if (imageUrl != null) {
                onUploaded(imageUrl);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppliedSurface>()?.brand,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Icon(
                Icons.file_upload_outlined,
                color: Theme.of(
                  context,
                ).extension<AppliedSurface>()?.primaryHeader,
                size: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> uploadImage(
    BuildContext context,
    String? productId,
    String? imageUri,
  ) async {
    String? imageUri;
    var imageType = await FileManager().selectFileSource(context);
    var selectedImage = await imagePicker.pickImage(
      source: imageType ?? ImageSource.gallery,
    );

    if (selectedImage == null) return null;

    if (!await FileManager().isFileTypeAllowed(
      selectedImage,
      context.mounted ? context : globalNavigatorKey.currentContext!,
    )) {
      return null;
    }

    showProgress(
      context: context.mounted ? context : globalNavigatorKey.currentContext!,
    );

    try {
      var state = AppVariables.store!.state;
      var file = File(selectedImage.path);
      var downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'products',
        id: productId ?? const Uuid().v4(),
        businessName: '',
      );

      imageUri = downloadUrl.downloadUrl;

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      showMessageDialog(
        context.mounted ? context : globalNavigatorKey.currentContext!,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      showMessageDialog(
        context.mounted ? context : globalNavigatorKey.currentContext!,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }

    return imageUri;
  }
}
