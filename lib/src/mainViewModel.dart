import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';

import '../data/remote/mainService.dart';
import '../global/global.dart';
import '../utils/colors/appColors.dart';


class MainViewMoel extends ChangeNotifier {
  //Singleton
  static final MainViewMoel _mainVM = MainViewMoel._internal();
  NumberFormat formatter = new NumberFormat("0000");

  final String firebase_message_server_key = "AAAAJXOJzWs:APA91bGWR34oWC3eoHhi04gFw41Xr_6Jo6ztQYAEA73JTATaFs3zycYImuQChm71kBcvfJlWRGZX_kuABlF1ZjYBvn3gqU1rCpgELXK3GnV6nRMXunf06Dw9o1X45Dt1cZmswhx0ITc0";
  final String web_vapid_key = "BBIMiM6qxQPsLVjMHIj79ncIyTOFlOQu8L-HXL7n2HYumPFGpsH2Plt-qg5-HWnXjOoOTdZcxyoLdcyVNURyQaU";

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

      connectivitySubscription =  Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
      //notificationHandler = NotificationHandler(MainVM: this);
      // setUserTokenFromMemoryIfLggedIn();
    } catch (e) {
      print("Yazeed: Excetion While setting NotificationHandler!...");
      print(e);
    }
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    Future.delayed(Duration(seconds: 2),(){
      switch(result){
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

  showInterNetMessage(String message){
    final SnackBar snackBar = SnackBar(content: Text(message));
    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  showTopSuccessMessage(BuildContext context,String? message){
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: message!,
      ),
    );
  }

  showTopInfoMessage(BuildContext context,String? message){
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: message!,
      ),
    );
  }
  showTopErrorMessage(BuildContext context,String? message){
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: message! ,
      ),
    );
  }

  showTopPersistentMessage(BuildContext context,String? message){
    AnimationController? localAnimationController;
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: message!,
      ),
      persistent: true,
      onAnimationControllerInit: (controller) => localAnimationController = controller,
      onTap: () => localAnimationController?.reverse(),
    );
  }

  showhideprogress(bool isShow,BuildContext context){
    if(isShow){
      context.loaderOverlay.show();
    }else{
      if(context.loaderOverlay.visible)
      context.loaderOverlay.hide();
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
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }else if (kIsWeb){
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.vendor! +webBrowserInfo.userAgent!+webBrowserInfo.hardwareConcurrency.toString();
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

  Future<String?> getFirebaseToken() async {
    if (kIsWeb){
      return await FirebaseMessaging.instance.getToken(vapidKey:web_vapid_key);
    }else{
      return await FirebaseMessaging.instance.getToken();
    }
  }



}