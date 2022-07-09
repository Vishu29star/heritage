import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../src/loginSignup/LoginSignUpViewModel.dart';
import '../../../src/loginSignup/screen/desktop/loginSignUpDesktop.dart';
import '../../../src/loginSignup/screen/mobile/loginSignUpmobile.dart';
import '../../../src/loginSignup/screen/tablet/loginSignUpTablet.dart';
import '../../../utils/extension.dart';
import '../../../utils/responsive/responsive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class LoginSignUpMainScreen extends StatefulWidget {
  final LoginSignUpViewModel model;
  const LoginSignUpMainScreen(this.model,{Key? key,}) : super(key: key);
  @override
  State<LoginSignUpMainScreen> createState() => _LoginSignUpMainScreenState();
}

class _LoginSignUpMainScreenState extends State<LoginSignUpMainScreen> {

  @override
  initState(){
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.model.disposeListener();
  }
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    if(widget.model.firstInit<1){
      widget.model.firstInit++;
      widget.model.initPage(context);
    }
    return Scaffold(
      body: ChangeNotifierProvider<LoginSignUpViewModel>(
        create: (_) => widget.model,
        child: Consumer<LoginSignUpViewModel>(
          builder: (context,model,child){
            return LoaderOverlay(
              useDefaultLoading: false,
              overlayWidget: Center(
                child: SpinKitCubeGrid(
                  color: context.resources.color.colorPrimary,
                  size: 50.0,
                ),
              ),
              overlayColor: Colors.black,
              overlayOpacity: 0.8,
              child: model.mainModel!.isNetworkPresent ? Responsive(
                mobile: LoginSignUpMobile(model),
                tablet: LoginSignUpTablet(model),
                desktop: LoginSignUpDesktop(model),
              ) : Center(child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.signal_wifi_off,
                    color:  Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'No internet',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),),
            );
          },
        ),
      ),
    );
  }
}
