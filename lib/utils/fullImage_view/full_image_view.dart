import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenImageScreen extends StatelessWidget {
  final List<String>? attachment;

  const FullscreenImageScreen({Key? key, required this.attachment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
          itemCount: attachment!.length,
          controller:
          PageController(initialPage: 0, keepPage: true, viewportFraction: 1),
          itemBuilder: (BuildContext context, int itemIndex) {
            return Stack(
              children: [
                Center(
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered,
                    imageProvider:
                    CachedNetworkImageProvider(attachment![itemIndex]),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100))),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
