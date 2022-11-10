import 'dart:async';
import 'dart:io';

import 'package:Heritage/models/user_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../data/remote/mainService.dart';
import '../global/global.dart';
import '../utils/colors/appColors.dart';

class MainViewMoel extends ChangeNotifier {
  //Singleton
  static final MainViewMoel _mainVM = MainViewMoel._internal();
  NumberFormat formatter = new NumberFormat("0000");

  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late MainService mainService;
  bool isNetworkPresent = true;

  //var servertype = appServerType;
  factory MainViewMoel() {
    return _mainVM;
  }

  MainViewMoel._internal() {
    try {
      print("setting NotificationHandler...");
      mainService = MainService();

      connectivitySubscription =
          Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
      //notificationHandler = NotificationHandler(MainVM: this);
      // setUserTokenFromMemoryIfLggedIn();
    } catch (e) {
      print("Yazeed: Excetion While setting NotificationHandler!...");
      print(e);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    Future.delayed(Duration(seconds: 2), () {
      switch (result) {
        case ConnectivityResult.bluetooth:
          showInterNetMessage("Bluetooth Connection");
          isNetworkPresent = false;
          // TODO: Handle this case.
          break;
        case ConnectivityResult.wifi:
          showInterNetMessage("Wifi Connection");
          // TODO: Handle this case.
          break;
        case ConnectivityResult.ethernet:
          showInterNetMessage("Ethernet Connection");
          // TODO: Handle this case.
          break;
        case ConnectivityResult.mobile:
          showInterNetMessage("Mobile Connection");
          // TODO: Handle this case.
          break;
        /*5tJAMJW3yhFlcaDXF6z93w==
        * */
        case ConnectivityResult.none:
          showInterNetMessage("No Connection");
          isNetworkPresent = false;
          // TODO: Handle this case.
          break;
      }
      notifyListeners();
    });
  }

  showInterNetMessage(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  showTopSuccessMessage(BuildContext context, String? message) {
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: message!,
      ),
    );
  }

  showTopInfoMessage(BuildContext context, String? message) {
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: message!,
      ),
    );
  }

  showTopErrorMessage(BuildContext context, String? message) {
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: message!,
      ),
    );
  }

  showTopPersistentMessage(BuildContext context, String? message) {
    AnimationController? localAnimationController;
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: message!,
      ),
      persistent: true,
      onAnimationControllerInit: (controller) =>
          localAnimationController = controller,
      onTap: () => localAnimationController?.reverse(),
    );
  }

  showhideprogress(bool isShow, BuildContext context) {
    if (isShow) {
      context.loaderOverlay.show();
    } else {
      if (context.loaderOverlay.visible) context.loaderOverlay.hide();
    }
  }

  static void showToast(String? text) {
    if (text != null && text.isNotEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: text,
          backgroundColor: AppColor().colorPrimary,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 13.0);
    }
  }

  Future<String?> getDeviceId() async {
    if(!kIsWeb){
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        // import 'dart:io'
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
    }
    else {
      return await PlatformDeviceId.getDeviceId?? DateTime.now().toIso8601String();
    }
  }

  Future<String?> getAppVersionId() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return version;
  }

  Future<String?> getWebFirebaseToken() async {
    return await FirebaseMessaging.instance.getToken(vapidKey: web_vapid_key);
  }
  Future<String?> getMobileFirebaseToken() async {
    return await FirebaseMessaging.instance.getToken();
    if (!kIsWeb) {

    } else {
      return null;
      //return await FirebaseMessaging.instance.getToken(vapidKey: web_vapid_key);
    }
  }

  Future<void> sendNotification(
    List<String> tokenList,
    Map<String, dynamic> notificationObject,
    Map<String, dynamic> dataObject,
  ) async {
    mainService.sendNotification(tokenList, notificationObject, dataObject);
  }

  Future<void> createNotification(
    List<String> finance_uids,
    Map<String, dynamic> notificationObject,
    Map<String, dynamic> dataObject,
  ) async {
    mainService.createNotification(
        finance_uids, notificationObject, dataObject);
  }

  Future<List<UserModel>?> getFilteruser(
      {String filterName = "customer"}) async {
    return mainService.getFilteruser(filterName: filterName);
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

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 5,
    );
    print(file.lengthSync());
    print(result!.lengthSync());
    return result;
  }
}
