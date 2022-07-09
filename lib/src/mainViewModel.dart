import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/remote/mainService.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../global/global.dart';


class MainViewMoel extends ChangeNotifier {
  //Singleton
  static final MainViewMoel _mainVM = MainViewMoel._internal();

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

}