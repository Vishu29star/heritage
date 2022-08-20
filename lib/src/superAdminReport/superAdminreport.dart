import 'package:Heritage/src/home/homeVM.dart';
import 'package:Heritage/src/superAdminReport/super-admin_report_services.dart';
import 'package:Heritage/src/superAdminReport/superAdminVm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../mainViewModel.dart';

class SuperAdminReportScreen extends StatefulWidget {
  final HomeVM homeModel;

  const SuperAdminReportScreen({Key? key, required this.homeModel})
      : super(key: key);

  @override
  State<SuperAdminReportScreen> createState() => _SuperAdminReportScreenState();
}

class _SuperAdminReportScreenState extends State<SuperAdminReportScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SuperAdminReportVM>(
        create: (_) => SuperAdminReportVM(SuperAdminReportServices(), MainViewMoel(),
            context, widget.homeModel),
        child: Consumer<SuperAdminReportVM>(builder: (context, model, child) {
          return Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 300, maxWidth: 450),
              child: Scaffold(
                body: model.isLoading ? Center(child: CircularProgressIndicator(),) : DefaultTabController(
                  length: 4,
                  child: Scaffold(
                      body: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            new SliverAppBar(
                              bottom: TabBar(
                                isScrollable: false,
                                tabs: [
                                  Tab(child: Text('25')),
                                  Tab(child: Text('50')),
                                  Tab(child: Text('75')),
                                  Tab(child: Text('100')),
                                ],
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          children: <Widget>[
                            ReportListView(model,model.lessThan25),
                            ReportListView(model,model.lessThan50),
                            ReportListView(model,model.lessThan75),
                            ReportListView(model,model.moreThan75),
                          ],
                        ),
                      )),
                ),
              ),
              /*child: Scaffold(
                appBar: AppBar(
                  title: Text("Report"),
                  automaticallyImplyLeading: false,
                  actions: [
                    
                  ],
                ),
              ),*/
            ),
          );
        }),
      ),
    );
  }
}
class ReportListView extends StatefulWidget {
  final List<UserModel> listData;
  final  SuperAdminReportVM model;
  const ReportListView(this.model,this.listData,{Key? key}) : super(key: key);

  @override
  State<ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.listData.length>0?ListView.builder(
          itemCount:widget.listData.length,itemBuilder: (context,index){
        return ListTile(
          //selected: widget.model.selectedUserId == data[FirestoreConstants.uid],
          onTap: () {
           /* widget.model.selectuser(data[FirestoreConstants.uid]);
            if (Responsive.isMobile(context)) {
              var passValue = {"model": widget.model};
              myNavigator.pushNamed(context, Routes.userDetail,
                  arguments: passValue);
            }*/
          },
          title: Text(widget.listData[index].name??"name"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.listData[index].email??"email"),
              Text((widget.listData[index].studentFormPercent ?? 0).toString()),
            ],
          ),
        );
      }):Center(child: Text("No Data"),),
    );
  }
}

