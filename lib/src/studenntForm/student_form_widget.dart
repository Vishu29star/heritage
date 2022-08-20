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
  final formKey = GlobalKey<FormState>();

  StudenFormWidegt({Key? key, required this.userId}) : super(key: key);

  @override
  _StudenFormWidegtState createState() => _StudenFormWidegtState();
}

class _StudenFormWidegtState extends State<StudenFormWidegt> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: widget.formKey,
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<StudentFormVM>(
        create: (_) => StudentFormVM(StudentFormService(), MainViewMoel()),
        child: Consumer<StudentFormVM>(builder: (context, model, child) {
          if (model.firstInt < 1) {
            model.firstInt++;
            model.checkForStudentForm(context, widget.userId);
          }
          print("rftgyhujikoloijuhygtf");
          return WillPopScope(
            onWillPop: () async {
              if(model.pagePostion==0){
                return true;
              }else{
                model.onBackPress();
                return false;
              }
            },
            child: SafeArea(
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
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => model.onBackPress(),
                      ),actions: [
                        model.studentPercent > 99 ? TextButton(onPressed: (){
                          if(model.currentUserType == "customer"){
                            model.createPdf(false);
                          }else{
                            showOptionsDialog(context,model);
                          }

                        }, child: Text("Download Profile")) : Container()
                    ],
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
            ),
          );
        }),
      ),
    );
  }

  Future<void> showOptionsDialog(BuildContext context, StudentFormVM model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Optons"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("With Employee Comments"),
                    onTap: () {

                      model.createPdf(true);
                      Navigator.pop(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Without Employee Comments"),
                    onTap: () {
                      model.createPdf(false);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  Widget formBody(StudentFormVM model) {
    print("rftgyhujikolp");
    final Stream<DocumentSnapshot> studentFormStream = model
        .studentFormService!.studentFormDoc
        .doc(model.studentCaseId)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: studentFormStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print("rftgbhnjmk,l.;");
        if (snapshot.hasError) {
          return HeritageErrorWidget();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HeritageProgressBar();
        }
        if(!snapshot.hasData){
          return Text(
            'No Data...',
          );
        }else{
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
        }

      },
    );
  }
}
