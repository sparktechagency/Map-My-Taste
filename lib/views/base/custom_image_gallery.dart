import 'package:flutter/material.dart';
import 'custom_network_image.dart'; // your existing custom image

class CustomImageGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const CustomImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  static void show(BuildContext context, List<String> images, {int initialIndex = 0}) {
    showDialog(
      context: context,
      builder: (_) => CustomImageGallery(images: images, initialIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = initialIndex;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: images.length,
                  controller: PageController(initialPage: initialIndex),
                  onPageChanged: (index) => setState(() => currentIndex = index),
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      child: Center(
                        child: CustomNetworkImage(
                          imageUrl: images[index],
                          height: double.infinity,
                          width: double.infinity,
                          boxShape: BoxShape.rectangle,
                          backgroundColor: Colors.black,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${currentIndex + 1}/${images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
