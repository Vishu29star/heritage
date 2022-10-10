import 'package:Heritage/constants/customTabBar.dart';
import 'package:Heritage/src/personForm/all_form_detail.dart';
import 'package:Heritage/src/personForm/family_imformation.dart';
import 'package:Heritage/src/personForm/finanical_data.dart';
import 'package:Heritage/src/personForm/ielts_data.dart';
import 'package:Heritage/src/personForm/person_form_model.dart';
import 'package:Heritage/src/personForm/person_form_service.dart';
import 'package:Heritage/src/personForm/personal_detail.dart';
import 'package:Heritage/src/personForm/travel_history.dart';
import 'package:Heritage/src/personForm/work_experience.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../constants/HeritageCircularProgressBar.dart';
import '../../constants/HeritageErrorWidget(.dart';
import '../mainViewModel.dart';
import 'education_data.dart';
import 'job_offer.dart';

class PersonFormScreen extends StatelessWidget {
  final String formUserId;

  const PersonFormScreen(this.formUserId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PersonFormVM>(
        create: (_) =>
            PersonFormVM(PersonService(), MainViewMoel(), context, formUserId),
        child: Consumer<PersonFormVM>(builder: (context, model, child) {
          return PersonFormTabPage(model);
        }));
  }
}

class PersonFormTabPage extends StatefulWidget {
  final PersonFormVM personFormVM;

  const PersonFormTabPage(this.personFormVM, {Key? key}) : super(key: key);

  @override
  State<PersonFormTabPage> createState() => _PersonFormTabPageState();
}

class _PersonFormTabPageState extends State<PersonFormTabPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            appBar: immigrationAppBar(),
            body: widget.personFormVM.isLoading
                ? HeritageProgressBar()
                : formBody(widget.personFormVM),
          ),
        ),
      ),
      onWillPop: () async {
        if (widget.personFormVM.tabPosition == 0) {
          return true;
        } else {
          widget.personFormVM.onBackPress();
          return false;
        }
      },
    );
  }

  Widget formBody(PersonFormVM model) {
    final Stream<DocumentSnapshot> studentFormStream = model
        .personService.studentFormDoc
        .doc(model.immigartionCaseId)
        .snapshots();
    print("ftgyhujikol");
    return StreamBuilder<DocumentSnapshot>(
      stream: studentFormStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return HeritageErrorWidget();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HeritageProgressBar();
        }
        if (!snapshot.hasData) {
          return Text(
            'No Data...',
          );
        } else {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          print("data");
          print(data);
          List<String> tabWidget = model.getTabs(data);
          return CustomTabView(
            itemCount: tabWidget.length,
            initPosition: model.tabPosition,
            tabBuilder: (context, index) => Tab(text: tabWidget[index]),
            pageBuilder: (BuildContext context, int index) {
              return getCurrentTabBody(index, data);
            },
            onScroll: (double value) {

            },
            onPositionChange: (int value) {
              model.tabPosition = value;
            },
            stub: Container(),
          );
        }
      },
    );
  }

  Widget getCurrentTabBody(int index, Map<String, dynamic> data) {

    if (index == 0) {
      return AllFormDetailWidget(widget.personFormVM);
    }
    if (index == 1) {
      return PersonalDetailWidget(widget.personFormVM);
    }
    if (index == 2) {
      return EducationDetail(widget.personFormVM);
    }
    if (index == 3) {
      return IeltsData(widget.personFormVM);
    }
    if (index == 4) {
      return WorkExperience(widget.personFormVM);
    }
    if (index == 5) {
      return JobOffer(widget.personFormVM);
    }
    if (index == 6) {
      return TravelHistory(widget.personFormVM);
    }
    if (index == 7) {
      return Financials(widget.personFormVM);
    }
    if (index == 8) {
      return FamilyInformation(widget.personFormVM);
    }
    return HeritageProgressBar();
  }

  AppBar immigrationAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => widget.personFormVM.onBackPress(),
      ),
      actions: [
        /* widget.personFormVM.studentPercent > 99 ? TextButton(onPressed: (){
              if(widget.personFormVM.currentUserType == "customer"){
                widget.personFormVM.createPdf(false);
              }else{
                showOptionsDialog(context,model);
              }

            }, child: Text("Download Profile")) : Container()*/
      ],
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(
            context.resources.strings.immigrationForm,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).primaryColor),
          ),
          widget.personFormVM.immigartionCaseId == null
              ? Container()
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "#" + widget.personFormVM.immigartionCaseId,
                    style: TextStyle(
                        fontSize: 11, color: Theme.of(context).primaryColor),
                  ),
                ))
        ],
      ),
    );
  }


}
