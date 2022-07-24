import 'package:Heritage/constants/HeritageCircularProgressBar.dart';
import 'package:Heritage/src/studenntForm/studentFormService.dart';
import 'package:Heritage/src/studenntForm/studentFormViewModel.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../constants/HeritageErrorWidget(.dart';
import '../../utils/responsive/responsive.dart';
import '../mainViewModel.dart';

class StudenFormWidegt extends StatefulWidget {
  final String userId;

  StudenFormWidegt({Key? key, required this.userId}) : super(key: key);

  @override
  _StudenFormWidegtState createState() => _StudenFormWidegtState();
}

class _StudenFormWidegtState extends State<StudenFormWidegt> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double margin = Responsive.isDesktop(context)
        ? size.width * 0.37
        : Responsive.isTablet(context)
            ? size.width * 0.24
            : size.width * 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<StudentFormVM>(
        create: (_) => StudentFormVM(StudentFormService(), MainViewMoel()),
        child: Consumer<StudentFormVM>(builder: (context, model, child) {
          if (model.firstInt < 1) {
            model.firstInt++;
            model.checkForStudentForm(context, widget.userId);
          }

          return SafeArea(
            child: LoaderOverlay(
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
                    title: Row(
                      children: [
                        Text(
                          context.resources.strings.studentForm,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Theme.of(context).primaryColor),
                        ),
                        model.studentCaseId == null
                            ? Container()
                            : Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "#" + model.studentCaseId,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ))
                      ],
                    ),
                  ),
                  body: model.isLoading ? HeritageProgressBar() : formBody(model),
                )),
          );
        }),
      ),
    );
  }

  Widget formBody(StudentFormVM model) {
    final Stream<DocumentSnapshot> userStream = model
        .studentFormService!.studentFormDoc
        .doc(model.studentCaseId)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return HeritageErrorWidget();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return HeritageProgressBar();
        }
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        List<Widget> formWidgets = model.getWidgetList(data);
        return Padding(
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
        );
      },
    );
  }
}
