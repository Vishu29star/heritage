import 'package:Heritage/src/studenntForm/studentFormService.dart';
import 'package:Heritage/src/studenntForm/studentFormViewModel.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';

class StudenFormWidegt extends StatefulWidget {
  final String userId;

  StudenFormWidegt({Key? key,required this.userId}) : super(key: key);

  @override
  _StudenFormWidegtState createState() => _StudenFormWidegtState();
}

class _StudenFormWidegtState extends State<StudenFormWidegt> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double margin = Responsive.isDesktop(context)
        ? size.width * 0.37
        : Responsive.isTablet(context) ? size.width * 0.24 : size.width * 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<StudentFormVM>(
        create: (_) => StudentFormVM(StudentFormService(), MainViewMoel()),
    child: Consumer<StudentFormVM>(
    builder: (context, model, child) {
      if(model.firstInt<1){
        model.checkForStudentForm(context,widget.userId);
      }

      List<Widget> formWidgets = model.getWidgetList();
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
          child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            context.resources.strings.studentForm,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).primaryColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            12.0,
          ),
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: formWidgets.length,
            controller: model.pageController,
            itemBuilder: (BuildContext context, int itemIndex) {
              return formWidgets[itemIndex];
            },
          ),
        ),
      ));
    }),),
    );


  }

}
