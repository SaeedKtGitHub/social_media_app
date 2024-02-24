import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key,
  required this.text,
    required this.user,
    required this.time
  }) : super(key: key);
  final String text;
  final String user;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      padding:EdgeInsets.all(15.h) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment:
          Text(text,style: TextStyle(color: Colors.grey[900]),),
           SizedBox(height: 5.h,),
          //user,time
          Row(
            children: [
              Text(user,style: TextStyle(color: Colors.grey[500])),
              Text(" * ",style: TextStyle(color: Colors.grey[500])),
              Text(time,style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}
