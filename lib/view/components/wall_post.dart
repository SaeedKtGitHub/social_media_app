
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/helper/helper_methods.dart';
import 'package:social_media/view/components/comment.dart';
import 'package:social_media/view/components/comment_button.dart';
import 'package:social_media/view/components/delete_button.dart';
import 'package:social_media/view/components/like_button.dart';

class WallPost extends StatefulWidget {
  const WallPost(
      {Key? key,required this.message,
        required this.user,
        required this.likes,
        required this.postId,
        required this.time,

      }
      ) : super(key: key);
  final String user;
  final String message;
  final String postId;
  final List<String> likes;
  final String time;


  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  final currentUser=FirebaseAuth.instance.currentUser!;
  bool isLike=false;

  final _commentTextController=TextEditingController();
  int commentCount = 0;


  @override
  void initState() {
    super.initState();
    isLike = widget.likes.contains(currentUser.email);

    // Fetch comments and update the comment count
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .snapshots()
        .listen((event) {
      setState(() {
        commentCount = event.docs.length;
      });
    });
  }


  //toggle like:
  void toggleLike(){
    setState(() {
      isLike=!isLike;
    });


    //Access the document (Firebase):
    DocumentReference postRef=FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if(isLike){
      postRef.update({
        //if the post now liked,add the user's email to the likes fields:
        'Likes':FieldValue.arrayUnion(([currentUser.email])),
      });
    }else{
      //if the post now unliked,remove the user's email to the likes fields:
      postRef.update({
        //if the post now liked,add the user's email to the likes fields:
        'Likes':FieldValue.arrayRemove(([currentUser.email])),
      });
    }
  }

  //show a dialog box for adding comment:
  void showCommentDialog(){
    Get.defaultDialog(
        title: 'Add Comment',
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: 'Write a comment..',

          ),
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [

          //cancel button:

          TextButton(
              onPressed: (){
                Get.back();
                //clear the controller
                _commentTextController.clear();
              },
              child:Text('Cancel',style: TextStyle(color: Colors.black))
          ),
          //post Button:
          TextButton(
              onPressed:(){
                if(_commentTextController.text.trim().isNotEmpty){
                //add comment:
               addComment(_commentTextController.text);


    }
                Get.back();
                //clear the controller:
                _commentTextController.clear();

                } ,
              child:Text('Post',style: TextStyle(color: Colors.black),)
          ),
        ]
    );
  }


  //add a comment:
  void addComment(String commentText)
  {
    //write the comment to firestore under the comments collection for the post:
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText":commentText,
      "CommentedBy":currentUser.email,
      "CommentTime":Timestamp.now(),

    });
  }

  void deletePost(){
    //showing a dialog box asking confirmation before deleting the post
    Get.defaultDialog(
      title: 'Delete Post',
      content: Text('Are you sure you want to delete this post?',
        style: TextStyle(color: Colors.black),),
      actions: [
        //cancel button:
        TextButton(
            onPressed: ()=>Get.back(),
            child: Text('Cancel',style: TextStyle(color: Colors.black))
        ),

        //delete button:
        TextButton(
            onPressed: () async{
              //delete comments from firebase firestore first:
              final commentDocs=await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for(var doc in commentDocs.docs){
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              //then delete the post
               FirebaseFirestore.instance
                   .collection("User Posts")
                   .doc(widget.postId)
              .delete()
              .then((value) => print("post deleted"))
              .catchError((error) => print("Failed to delete post $error"));

              //dismiss the dialog:
              Get.back();
              },
            child: Text('Delete',style: TextStyle(color: Colors.black))
        ),
      ],

    );
  }



  @override


  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.only(top: 23.h,right: 23.w,left: 23.w),
      padding: EdgeInsets.all(23.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
         // SizedBox(width: 18.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            //group of text(message+user email)
            children: [
              Column(
                children: [
                  //message:
                  Text(widget.message,style: TextStyle(color: Colors.black)),
                  SizedBox(height: 5.h,),
                  //user:
                  //user,time
                  Row(
                    children: [
                      Text(widget.user,style: TextStyle(color: Colors.grey[500])),
                      Text(" * ",style: TextStyle(color: Colors.grey[500])),
                      Text(widget.time,style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                  SizedBox(height: 20.h,),

                ],
              ),

              //delete button:
              if(widget.user==currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like:
              Column(
                children: [
                  //like button :
                  LikeButton(onTap: toggleLike, isLiked:isLike),
                  SizedBox(height: 5.h,),
                  //like count:
                  Text(widget.likes.length.toString(),style: TextStyle(color: Colors.grey),)
                ],
              ),
              SizedBox(width:10.h),
              //comment:
              Column(
                children: [
                  //comment button :
                CommentButton(onTap: showCommentDialog),
                  SizedBox(height: 5.h,),
                  //comment count :
                  Text(commentCount.toString(), style: TextStyle(color: Colors.grey),)
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h,),


          //comments under the post:
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
              .collection("Comments")
              .orderBy("CommentTime",descending: true).snapshots(),
              builder: (context,snapshot){
                //show loading circe if no data yet
                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                }
                return ListView(
                  shrinkWrap: true, // for nested lists
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // Get the comment:
                    final commentData = doc.data() as Map<String, dynamic>;

                    // Return the comment:
                    return Comment(
                        text: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: formatData(commentData["CommentTime"])
                    );
                  }).toList(),
                );


              })
        ],
      ),
    );
  }
}
