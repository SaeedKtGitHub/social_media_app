import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/helper/helper_methods.dart';
import 'package:social_media/view/components/text_box.dart';
import 'package:social_media/view/components/wall_post.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  final currentUser=FirebaseAuth.instance.currentUser!;

  //All users:
  final userCollection=FirebaseFirestore.instance.collection("Users");
  //edit field:
  Future<void> editField(String field) async{
  String newValue="";
   await Get.defaultDialog(
     title: 'Edit'+field,
     titleStyle: TextStyle(color: Colors.white),
     backgroundColor: Colors.grey[900],
     content: TextField(
       autofocus: true,
         style: TextStyle(color: Colors.grey),
       decoration: InputDecoration(
         hintText: 'Enter new '+field,
         hintStyle: TextStyle(color: Colors.grey)
       ),
       onChanged: (value){
         newValue=value;
       },
     ),
     actions: [
       //cancel Button:
       TextButton(
         onPressed:
         ()=>Get.back()

       , child: Text('Cancel',style: TextStyle(color: Colors.white),),

       ),
       //Save Button
       TextButton(
         onPressed: (){
           Get.back(result: newValue);
         }
         , child: Text('Save',style: TextStyle(color: Colors.white),),

       )
     ]
   );
   //update in firestore:
    if(newValue.trim().length>0){
      //only update if there is something in the textfields:
      await userCollection.doc(currentUser.email).update({field:newValue});
    }
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Padding(
          padding:  EdgeInsets.only(left: 60.w),
          child: Text('Profile Page',
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream:FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots() ,
          builder: (context,snapshot){
             //get user data
            if(snapshot.hasData){
              final userData=snapshot.data!.data() as Map<String,dynamic>;

              return ListView(
                children: [
                  SizedBox(height: 50.h,),
                  //profile pic:
                  Icon(Icons.person,size: 71.h,),
                  SizedBox(height:15.h,),
                  //user email
                  Text(currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  //user details:
                  Padding(
                    padding: EdgeInsets.only(left: 25.h),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  //username
                  MyTextBox(text: userData['username'],
                    sectionName: 'username',
                    onPressed:()=>editField('username') ,
                  ),
                  //Bio
                  MyTextBox(text:  userData['bio'], sectionName: 'bio',
                    onPressed:(){editField('bio') ;}
                  ),
                  SizedBox(height: 50.h,),



                ],
              );
            }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'),);
            }
            return Center(child: CircularProgressIndicator(),);
          }
          )
    );
  }
}
