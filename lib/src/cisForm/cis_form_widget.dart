import 'package:Heritage/src/cisForm/CISFormVM.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../mainViewModel.dart';
import 'CISFormService.dart';

class CISFormWidget extends StatefulWidget {

  CISFormWidget({Key? key}) : super(key: key);

  @override
  _CISFormWidgetState createState() => _CISFormWidgetState();
}

class _CISFormWidgetState extends State<CISFormWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<CISFormVM>(
        create: (_) => CISFormVM(CISFormService(), MainViewMoel()),
        child: Consumer<CISFormVM>(
            builder: (context, model, child) {
              print("hbjnkml,");
              List<Widget> formWidgets = model.getFormWidget(context);
              return Scaffold(
                appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                title: Text("CIS Form",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Theme.of(context).primaryColor),),
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
              );
            }),),
    );

  }



}
