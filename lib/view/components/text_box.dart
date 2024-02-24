import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextBox extends StatelessWidget {
  const MyTextBox({Key? key,
  required this.text,
    required this.sectionName
    ,required this.onPressed
  }) : super(key: key);
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.h),
      ),
      padding: EdgeInsets.only(bottom: 20.h,left: 20.w),
      margin: EdgeInsets.only(left: 25.w,right: 25.w,top: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //sectionName:
          children: [
              Text(sectionName,style:TextStyle(
                color: Colors.grey[500]
              ),
              ),
            //Edit button:
            IconButton(onPressed: onPressed,
                icon: Icon(Icons.settings),
            color: Colors.grey[400],
            )
            ],
          ),
          //text:
          Text(text,
            style:TextStyle(
                color: Colors.black
            ),
          ),
        ],


      ),
    );
  }
}
