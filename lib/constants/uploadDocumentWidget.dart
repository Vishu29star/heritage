import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import '../global/global.dart';
import '../utils/extension.dart';
import '../utils/onHover.dart';
import '../utils/responsive/responsive.dart';
import 'image_picker_utils.dart';


class HeritageDoumentUpload extends StatefulWidget {
  String? imageError = null;
  Map<String,dynamic>? image = null;
  final String labelText;
  Function? onImageSelection;

  HeritageDoumentUpload({Key? key,this.imageError = null, required this.labelText, required this.image , required this.onImageSelection}) : super(key: key);

  @override
  State<HeritageDoumentUpload> createState() => _HeritageDoumentUploadState();
}

class _HeritageDoumentUploadState extends State<HeritageDoumentUpload> {
  bool showLoading  = false;

  var multiply = 1.0;

  var textmultiply = 1.0;

  var width_multiply = 1.0;

  double width = 0;

  double height = 0;

  String whichPLatform = "";

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width < 600.0) {
      whichPLatform = "mobile";
      multiply = 1.0;
      textmultiply = 1.0;
      width_multiply = 1.0;
    }
    else if (width < 1000.0) {
      whichPLatform = "tablet";
      multiply = 1.3;
      textmultiply = 1.2;
      width_multiply = 0.9;
    }
    else {
      whichPLatform = "web";
      width_multiply = 0.6;
      multiply = 1.6;
      textmultiply = 1.4;
    }
   return Container(
     padding: EdgeInsets.symmetric(vertical: 16),
     child: Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(widget.labelText,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
             SizedBox(width: 16,),
             Expanded(
               child: InkWell(
                 onTap: (){
                   ImagePickerUtils2.show(
                     context: context,
                     onGalleryClicked: () async {
                       XFile? files = await imgFromGallery();
                       Navigator.of(context).pop();
                       if(files!=null){
                         widget.image = {"type":"xfile","data":files};
                         widget.imageError == null;
                         widget.onImageSelection!(widget.image);
                         setState(() {

                         });
                       }
                     },
                     onDocumentClicked: () async {
                       FilePickerResult? result  = await documnetFormFile();
                       Navigator.of(context).pop();
                       if(result!=null){
                         widget.image = {"type":"filPicker","data":result};
                         widget.onImageSelection!(widget.image);
                         widget.imageError == null;
                         setState(() {

                         });
                       }
                     },
                     onCamerTaped: () async {
                       XFile? file =  await imageFromCamera();
                       Navigator.of(context).pop();
                       if(file !=null){
                         widget.image = {"type":"xfile","data":file};
                         widget.onImageSelection!(widget.image);
                         widget.imageError == null;
                         setState(() {

                         });
                       }
                     },
                   );
                 },
                 child: widget.image == null ? Neumorphic(
                     style: NeumorphicStyle(
                         shape: NeumorphicShape.concave,
                         boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                         depth: 8,
                         lightSource: LightSource.topLeft,
                         color: Colors.white
                     ),
                     padding: EdgeInsets.all(12),
                     child: Center(child:Text( "Select Image",style: TextStyle(color: Colors.black))
                     ))
                     :   ConstrainedBox(constraints: BoxConstraints(
                   maxWidth: MediaQuery.of(context).size.width * 0.30,
                   maxHeight: MediaQuery.of(context).size.height * 0.30,
                 ),child: getFileWidget(widget.image!),),

               ),
             )
           ],
         ),
         widget.imageError != null
             ? Container(
           padding: EdgeInsets.symmetric(vertical: 8),
           alignment: Alignment.centerRight,
           child:Text(widget.imageError!),
         )
             : Container(),
       ],
     ),
   );
  }
  Future<XFile?> imgFromGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? images = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (images != null) {

      return images;
    }
  }

  Future<FilePickerResult?> documnetFormFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      return result;
    }
  }

  Future<XFile?> imageFromCamera() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (image != null) {
      File file = File(image.path);
      return image;
    }

  }
  Widget getFileWidget(Map<String , dynamic > fileData){
    print(fileData);
    if(fileData["type"].toString().toLowerCase()=="xfile"){
      return kIsWeb
          ? Image.network(fileData["data"].path)
          : Image.file(File(fileData["data"].path));
    }
    if(fileData["type"].toString().toLowerCase()=="filepicker" || fileData["type"].toString().toLowerCase()=="filpicker" ){
      return Center(child: Icon(Icons.picture_as_pdf,size: 30,),);
    }
    if(fileData["type"].toString().toLowerCase()=="document"){
      return Center(child: Icon(Icons.picture_as_pdf,size: 30,),);
    }
    if(fileData["type"].toString().toLowerCase()=="image"){
      return Image.network(fileData["data"]);
    }
    return Container();
  }
}

