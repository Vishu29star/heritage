
import 'package:Heritage/utils/pushNotification/push_notifcation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'data/locol/prefrencesUtils.dart';
import 'firebase_options.dart';
import 'global/global.dart';
import 'route/myNavigator.dart';
import 'route/routes.dart';
import 'src/splash/splashScreen.dart';
import 'utils/extension.dart';
/*
TO load images in web command https://console.firebase.google.com/project/heritageimm-ad896/storage/heritageimm-ad896.appspot.com/files
run for debugging

flutter run -d chrome --web-renderer html
production release

flutter build web --web-renderer html --release*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
 if(kIsWeb){
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
 }else{
   await Firebase.initializeApp(
      name: "Heritageimm",
     options: DefaultFirebaseOptions.currentPlatform,
   );
 }
  PreferenceUtils.init();
  await PushNotificationService().setupInteractedMessage();
  runApp(const MyApp());
 /* RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
      return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
        title: 'Heritage',
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        navigatorKey: myNavigator.navigatorKey,
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child!),
            maxWidth: 2000,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          primaryColor: context.resources.color.colorPrimary,
          primarySwatch: context.resources.color.colorPrimary,
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: Routes.generateRoute,
        home:LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: SpinKitCubeGrid(
                color: context.resources.color.colorPrimary,
                size: 50.0,
              ),
            ),
            overlayColor: Colors.black,
            overlayOpacity: 0.8,
            child: SplashScreen()),
        //home: Home(),
      );},
      ),
    );
  }
}

