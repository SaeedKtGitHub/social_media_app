import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/helper/helper_methods.dart';
import 'package:social_media/view/components/drawer.dart';
import 'package:social_media/view/components/text_field.dart';
import 'package:social_media/view/components/wall_post.dart';
import 'package:social_media/view/pages/profile_page.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


   final currentUser=FirebaseAuth.instance.currentUser;
  void signOut(){
    FirebaseAuth.instance.signOut();
  }
   void postMessage(){
   //only post if there is something in the textfield:
     if(textController.text.isNotEmpty) {
       //store in firebase:
       FirebaseFirestore.instance.collection('User Posts').
       add({
         'UserEmail':currentUser!.email,
         'Message':textController.text,
         'TimeStamp':Timestamp.now(),
         'Likes':[]

       });


       textController.clear();
      }

  }

  void goToProfilePage(){
    //pop menu drawer:
    Get.back();
    //go to profile page:
    Get.to(()=>ProfilePage());
  }

  final textController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut:signOut ,

      ),

      appBar: AppBar(
        title: Padding(
          padding:  EdgeInsets.only(right: 40.0.w),
          child: Center(
              child: Text('The wall')
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.sp
        ),
        backgroundColor: Colors.grey[300],
          elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),



      ),

      body: Center(
        child: Column(
          children: [
            //the wall:
           Expanded(
               child:StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance.collection('User Posts').
                   orderBy('TimeStamp',descending: false)
                   .snapshots(),
                   builder: (context,snapshot){
                     if(snapshot.hasData){
                       return ListView.builder(
                         itemCount: snapshot.data!.docs.length,
                           itemBuilder: (context,index){
                             //get the message:
                             final post=snapshot.data!.docs[index];
                             return WallPost(
                               message:post['Message'],
                                 user: post['UserEmail'],
                                postId: post.id,
                               likes: List<String>.from(post['Likes']?? []),
                               time: formatData(post['TimeStamp']),
                             );
                           });
                     }else if(snapshot.hasError){
                       return Center(
                         child: Text('Error:${snapshot.error}'),
                       );
                     }
                     return const Center(
                       child: CircularProgressIndicator(),
                     );

                   }

                   ),
           ),
            //post message:
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                children: [
                 //textField:
                 Expanded(
                     child: MyTextField(
                         controller: textController,
                     hint: 'Write something on the wall..',
                     obscureText: false)
                 ),
                  //post Button:
                  IconButton(
                      onPressed: postMessage,
                      icon: Icon(Icons.arrow_circle_up)),
                ],
              ),
            ),
            //logged in as:
            Text("Logged in as:"+ currentUser!.email! ,
            style: TextStyle(
              color: Colors.grey
            ),
            ),
            SizedBox(height: 50.h,),
          ],
        ),
      ),
    );
  }
}
