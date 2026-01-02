import 'dart:io';
import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/dashed_border.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';

class MultiImageManager extends StatefulWidget {
  /// The list of image strings (can be network URLs or local file paths).
  final List<String> images;

  /// Callback function triggered when the user taps the "Add" button.
  /// The parent widget is responsible for handling the image selection/upload
  /// and then updating the `images` list.
  final VoidCallback onAddImage;

  /// Callback function triggered when the user taps an existing image to change it.
  /// It provides the `index` of the image to be replaced.
  final Function(int index) onUpdateImage;

  /// Callback function triggered when the user taps the remove icon on an image.
  /// It provides the `index` of the image to be deleted.
  final Function(int index) onDeleteImage;

  /// The height for the image tiles and the add button.
  final double imageHeight;

  /// The width for the image tiles and the add button.
  final double imageWidth;

  const MultiImageManager({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onUpdateImage,
    required this.onDeleteImage,
    this.imageHeight = 120.0,
    this.imageWidth = 120.0,
  });

  @override
  State<MultiImageManager> createState() => _MultiImageManagerState();
}

class _MultiImageManagerState extends State<MultiImageManager> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Add a listener to update the fade effect when the user scrolls.
    _scrollController.addListener(_updateScrollState);

    // Also check the scroll state after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
  }

  void _updateScrollState() {
    if (!mounted || !_scrollController.hasClients) return;

    final canScrollLeft = _scrollController.offset > 0;
    final canScrollRight =
        _scrollController.offset < _scrollController.position.maxScrollExtent;

    // Update the state only if the scrollability has changed.
    if (canScrollLeft != _canScrollLeft || canScrollRight != _canScrollRight) {
      setState(() {
        _canScrollLeft = canScrollLeft;
        _canScrollRight = canScrollRight;
      });
    }
  }

  @override
  void didUpdateWidget(covariant MultiImageManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the number of images changes, we need to re-check the scroll state.
    if (widget.images.length != oldWidget.images.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollState());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Create a linear gradient that defines the fade.
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // Dynamically set colors based on scroll position.
          colors: [
            _canScrollLeft ? Colors.transparent : Colors.black,
            Colors.black,
            Colors.black,
            _canScrollRight ? Colors.transparent : Colors.black,
          ],
          // Define the points where the fade starts and ends.
          // 0.0-0.05: Fade in on the left
          // 0.95-1.0: Fade out on the right
          stops: const [0.0, 0.05, 0.95, 1.0],
        ).createShader(bounds);
      },
      // This blend mode applies the gradient's transparency to the child.
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        height: widget.imageHeight,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          // Add one to the item count for the "Add" button
          itemCount: widget.images.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _AddImageButton(
                  onTap: widget.onAddImage,
                  width: widget.imageWidth,
                  height: widget.imageHeight,
                ),
              );
            }
            // These are the image tiles
            final imageIndex = index - 1;
            return _ImageTile(
              image: widget.images[imageIndex],
              onTap: () => widget.onUpdateImage(imageIndex),
              onRemove: () => widget.onDeleteImage(imageIndex),
              width: widget.imageWidth,
              height: widget.imageHeight,
            );
          },
        ),
      ),
    );
  }
}

/// A private widget to display a single image with a remove button.
class _ImageTile extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final double width;
  final double height;

  const _ImageTile({
    required this.image,
    required this.onTap,
    required this.onRemove,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // A helper to determine if the image is from the network or a local file
    bool isNetworkImage = image.startsWith('http');

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            // The main image container
            Positioned.fill(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isNetworkImage
                      ? getIt<FlutterNetworkImage>().asWidgetUri(
                          uri: image,
                          height: height,
                          width: width,
                        )
                      : Image.file(
                          File(image),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(LittleFishIcons.error),
                        ),
                ),
              ),
            ),
            // The remove button
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A private widget for the dashed "Add Image" button.
class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;

  const _AddImageButton({
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: DashedBorder(
        borderRadius: BorderRadius.circular(8),
        color:
            Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
            Colors.grey.shade300,
        strokeWidth: 1,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: Theme.of(context).extension<AppliedTextIcon>()?.positive,
              ),
              const SizedBox(height: 8),
              Text(
                'Add',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.positive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
