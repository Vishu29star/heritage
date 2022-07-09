import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../route/myNavigator.dart';
import '../../route/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runsplashTimer1();
  }
  runsplashTimer1(){
    runsplashTimer();
  }


  runsplashTimer() {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (await FirebaseAuth.instance.currentUser != null) {
      // signed in
        myNavigator.popAllAndPushNamedReplacement(context, Routes.home);
      } else {
        myNavigator.popAllAndPushNamedReplacement(context, Routes.login);
      }

      //myNavigator.popAllAndPushNamedReplacement(context, Routes.home);
    } /*Navigator.pushNamed(context, Routes.login)*/,);
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Theme.of(context).primaryColor,
          child: Text(
            'Heritage',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50.0,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),
        //child: Lottie.asset('assets/lottie_animation/plane.json'),
        //child: Text("rftgyhujikolp;[kjhygtfrtgyhujiko"),
      ),
    );
  }
}
