import 'package:Heritage/constants/noDataHeritageWidget.dart';
import 'package:Heritage/src/settings/settingService.dart';
import 'package:Heritage/src/settings/settingVM.dart';
import 'package:Heritage/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/GetNameTextFeild.dart';
import '../../data/firestore_constants.dart';
import '../../models/user_model.dart';
import '../mainViewModel.dart';

class SettingPage extends StatefulWidget {
  final UserModel userModel;

  const SettingPage(this.userModel, {Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SettingVM>(
          create: (_) => SettingVM(
              SettingService(), MainViewMoel(), widget.userModel, context),
          child: Consumer<SettingVM>(builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                /*
                backgroundColor: Colors.white,*/
                title: Text(
                  context.resources.strings.setting,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
              body: model.isDataLoaded ? bodyWidget(model) :HeritageNoDataWidget(),
            );
          })),
    );
  }
  Widget bodyWidget(SettingVM model){
    if(model.error !=""){
      return Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(model.error),
        ],
      ),);

    }
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Icon(Icons.chat,size: 25,),
              SizedBox(width: 20,),
              Expanded(
                child: Text(context.resources.strings.chatDeleteTime, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
              ),
              SizedBox(width: 20,),
              Text(model.chatDeleteTime),
              SizedBox(width: 20,),
              TextButton(onPressed: () async {
                var resultLabel = await showTextInputDialogNumber(context,title: "Update Chat Delete Time",hint_Value: "90",initalValue: model.chatDeleteTime);

                if(resultLabel != null){
                  if(resultLabel != model.chatDeleteTime){
                    model.chatDeleteTime = resultLabel;
                    Map<String,dynamic> data = {FirestoreConstants.chatDeleteTimeInDays:resultLabel};
                    model.updateChatDeleteTime(data);
                  }
                }
              }, child: Text(context.resources.strings.update, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.green),)),
            ],
          ),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Icon(Icons.chat,size: 25,),
              SizedBox(width: 20,),
              Expanded(
                child: Text(context.resources.strings.passportNotiFicationTime, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
              ),
              SizedBox(width: 20,),
              Text(model.passportNotificicationTime),
              SizedBox(width: 20,),
              TextButton(onPressed: () async {
                var resultLabel = await showTextInputDialogNumber(context,title: "Update Passport notification Time",hint_Value: "90",initalValue: model.passportNotificicationTime);
                if(resultLabel != null){
                  if(resultLabel != model.passportNotificicationTime){
                    model.passportNotificicationTime = resultLabel;
                    Map<String,dynamic> data = {FirestoreConstants.passportNotificicationTime:resultLabel};
                    model.updateChatDeleteTime(data);
                  }
                }

              }, child: Text(context.resources.strings.update, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.green),)),
            ],
          ),
        ),
      ],
    );

  }
}
