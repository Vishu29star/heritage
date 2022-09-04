import 'package:flutter/material.dart';

class SingleItemGroupWidget extends StatelessWidget {
  final Map<String,dynamic> group;
  final VoidCallback onTap;

  const SingleItemGroupWidget({Key? key, required this.group,required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10,right: 10,left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Icon(Icons.person,size: 25,),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${group["groupChatName"]}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    group["groupChatlastMessageObject"]["groupChatlastMessage"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}