import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../src/home/homeService.dart';
import '../../src/home/homeVM.dart';
import '../../src/mainViewModel.dart';
import '../../utils/extension.dart';
import '../../utils/responsive/responsive.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<HomeVM>(
        create: (_) => HomeVM(HomeService(), MainViewMoel()),
        child: Consumer<HomeVM>(
          builder: (context, model, child) {
            if(model.firstInit==0){
              model.firstInit++;
              model.firstInt(context);
            }

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
              child: model.mainModel!.isNetworkPresent
                  ?model.isDataLoad ? Responsive(
                      mobile: HomeItem(model, 1),
                      tablet: HomeItem(model, 2),
                      desktop: HomeItem(model, 3),
                    ):CircularProgressIndicator()
                  : Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.signal_wifi_off,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'No internet',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

}

class HomeItem extends StatelessWidget {
  final HomeVM model;
  final int crossAxisCount;
  const HomeItem(this.model, this.crossAxisCount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("model.isCollapsed");
    print(model.isCollapsed);
    Size size = MediaQuery.of(context).size;
    double drawerWidth = Responsive.isDesktop(context) ? size.width * 0.3 : Responsive.isTablet(context) ? size.width * 0.3 : size.width * 0.5;
    return SafeArea(
      child: Scaffold(
        key: model.key,
         appBar: AppBar(
          //backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Heritage",style: TextStyle(color: Colors.white,),),
          centerTitle: true,
        ),
        /*Drawer Example link https://blog.logrocket.com/how-to-add-navigation-drawer-flutter*/
        drawer: Drawer(
          child: Container(
            width: drawerWidth,
            child: ListView(
              children: model.generateItems,
            ),
          ),
        ),
        body: getHomeBody(model, context)!,
      ),
    );
  }


  Widget? getHomeBody(HomeVM model, BuildContext context) {
    switch (model.pagePosition) {
      case 0:
        return DashBoardBody(
          model,
        );
      case 1:
        return DashBoardBody(model);
      case 2:
        return DashBoardBody(model);
    }
  }
}

class DashBoardBody extends StatelessWidget {
  final HomeVM model;
  const DashBoardBody(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int crossAxisCount = Responsive.isDesktop(context)
        ? 3
        : Responsive.isTablet(context)
            ? 2
            : 1;
    for (int i = 0; i < model.homeItems.length; i++) {
      int count = 1;
      double ratio = 1.50;
      if (i == model.homeItems.length - 1) {
        if (crossAxisCount == 2 || crossAxisCount == 3) {
          count = crossAxisCount;
          ratio = 3.50;
        }
      }
      children.add(StaggeredGridTile.fit(
          crossAxisCellCount: count,
          child: _buildServiceCardNew(model.homeItems[i], ratio)));
    }
    return Scaffold(
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: SingleChildScrollView(
                child: StaggeredGrid.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 20.sp,
                  crossAxisSpacing: 20.sp,
                  children: children,
                ),
              )),
        ));
  }

  Widget _buildServiceCardNew(String item, double aspectRatio) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
             model.handleServiceClick(item);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    "https://previews.123rf.com/images/kesu87/kesu871811/kesu87181100404/112610230-airplane-taking-off-from-the-airport-.jpg?fj=1",
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Blah, Blah",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        height: 1.25,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*GridView.builder(
        itemCount: 250,
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.pokemon.isEmpty ? 1 : crossAxisCount,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 200 / 244,
        ),

        itemBuilder: (context, index) {
          return Container();
        },
      )*/

/*class _HomeState extends State<Home> {
  bool showLoading  = false;
  var multiply = 1.0;
  var textmultiply = 1.0;
  var width_multiply = 1.0;
  double width = 0;
  double height = 0;
  String whichPLatform = "";
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width < 600.0) {
      whichPLatform = "mobile";
      multiply = 1.0;
      textmultiply = 1.0;
      width_multiply = 1.0;
    }
    else if (width < 1000.0) {
      whichPLatform = "tablet";
      multiply = 1.3;
      textmultiply = 1.2;
      width_multiply = 0.9;
    }
    else {
      whichPLatform = "web";
      width_multiply = 0.6;
      multiply = 1.6;
      textmultiply = 1.4;
    }
    return Scaffold(
      body: Center(child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              if(whichPLatform=="mobile"){
                print("ghj");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CISFormWidget()));
              }else{
               showDialog(
                 context:context,
                 builder: (_){
                   print("ghftftj");
                   return AlertDialog(
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(10.0))
                     ),
                     content: SizedBox(
                       width: whichPLatform=="web"?width*0.35:width*0.5,
                       height: height*0.8,
                         child: CISFormWidget()),
                   );
                 }
               );
              }
            },
            child: Container(
              //padding: EdgeInsets.all(16),
              height: height*0.25,
              width: height*0.25,
              child: Center(
                child:Text("CIS\nForm",textAlign: TextAlign.center,style: TextStyle(fontSize: 22*textmultiply,fontWeight: FontWeight.w700,color: Colors.brown),),
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                      BoxShadow(
                        color: Colors.brown,
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        offset: Offset(2.0, 2.0), // shadow direction: bottom right
                      )

                ],
              ),
            ),
          ),
          SizedBox(height: 20*multiply,),
          InkWell(
            onTap: (){
              if(whichPLatform=="mobile"){
                print("ghj");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudenFormWidegt()));
              }else{
                showDialog(
                    context:context,
                    builder: (_){
                      print("ghftftj");
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        content: Container(
                          color: Colors.white,
                            width: whichPLatform=="web"?width*0.35:width*0.5,
                            height: height*0.8,
                            child: StudenFormWidegt()),
                      );
                    }
                );
              }
            },
            child: Container(
              //padding: EdgeInsets.all(16),
              height: height*0.25,
              width: height*0.25,
              child: Center(
                child:Text("Student\nForm",textAlign: TextAlign.center,style: TextStyle(fontSize: 22*textmultiply,fontWeight: FontWeight.w700,color: Colors.brown),),
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )

                ],
              ),
            ),
          ),
        ],
      ),),

    );
  }
}*/
