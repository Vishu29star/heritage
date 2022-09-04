import 'package:Heritage/utils/colors/appColors.dart';
import 'package:flutter/material.dart';

import '../utils/comman/commanWidget.dart';

Future<int?> showAdminTypeSelectionDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Admin Type'),
          content: ShowAdminType(),
        );
      });
}

class ShowAdminType extends StatefulWidget {
  const ShowAdminType({Key? key}) : super(key: key);

  @override
  State<ShowAdminType> createState() => _ShowAdminTypeState();
}

class _ShowAdminTypeState extends State<ShowAdminType> {
  int selectedUser = 0;

  setSelectedUser(int value){

    setState(() {
      selectedUser = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: 1,
            groupValue: selectedUser,
            title: Text("Legal"),
            onChanged: (currentUser) {
              setSelectedUser(1);
            },
            selected: selectedUser == 1,
            activeColor: AppColor().colorPrimary,
          ),
          RadioListTile(
            value: 2,
            groupValue: selectedUser,
            title: Text("Front Office"),
            onChanged: (currentUser) {
              setSelectedUser(2);
            },
            selected: selectedUser == 2,
            activeColor: AppColor().colorPrimary,
          ),
          RadioListTile(
            value: 3,
            groupValue: selectedUser,
            title: Text("Admin1"),
            onChanged: (currentUser) {
              setSelectedUser(3);
            },
            selected: selectedUser == 3,
            activeColor: AppColor().colorPrimary,
          ),
          RadioListTile(
            value: 4,
            groupValue: selectedUser,
            title: Text("Legal"),
            onChanged: (currentUser) {
              setSelectedUser(4);
            },
            selected: selectedUser == 4,
            activeColor: AppColor().colorPrimary,
          ),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if(selectedUser==0){
                    CommanWidgets.showToast("Please select Admin type.");
                  }else{
                    Navigator.pop(context, selectedUser);
                  }

                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
