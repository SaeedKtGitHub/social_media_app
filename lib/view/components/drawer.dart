import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/view/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key,
  required this.onSignOut,
    required this.onProfileTap
  }) : super(key: key);
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    return  Drawer(
     backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header:
              DrawerHeader(child:Icon(Icons.person,
                color: Colors.white,
                size: 64.h,
              ) ),
              //home list tile:
              MyListTile(
                text: 'H O M E',
                icon: Icons.home,
                onTab: ()=>Get.back(),
              ),
              //profile list tile:
              MyListTile(text: 'P R O F I L E',
                icon: Icons.person,
                onTab:onProfileTap,
              ),
            ],
          ),
          //logout list tile:
          Padding(
            padding:  EdgeInsets.only(bottom: 25.h),
            child: MyListTile(text: 'L O G O U T',
              icon: Icons.logout,
              onTab: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
