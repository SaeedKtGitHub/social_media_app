import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({Key? key,
  required this.text,
    required this.icon,
    required this.onTab
  }) : super(key: key);
    final IconData icon;
    final String text;
    final void Function()? onTab;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
        title: Text(text),
        onTap: onTab,
      ),
    );
  }
}
