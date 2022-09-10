import 'package:flutter/material.dart';

class ImagePickerUtils {
  ImagePickerUtils._();

  static void show({
    required BuildContext context,
    required VoidCallback onGalleryClicked,
    required VoidCallback onDocumentClicked,
  }) {


    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                // todo update icon
                leading: const Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: onGalleryClicked,
              ),
              ListTile(
                // todo update icon
                leading: const Icon(Icons.photo_camera),
                title: Text("Document"),
                onTap: onDocumentClicked,
              ),
            ],
          ),
        );
      },
    );
  }
}