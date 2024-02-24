import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/controller/homeController.dart';
import 'package:social_media/view/components/button.dart';
import 'package:social_media/view/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key,required this.onTap}) : super(key: key);
  final Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final HomeController  controller = HomeController();

  void signOut()async{
    //show loading circle:
    controller.showWaitingDialog();
    //make sure passwords are match:
    if(passwordTextController.text!=confirmPasswordTextController.text){
      //pop loading circle
      Get.back();
      //show error to user:
      controller.showLoginErrorDialog("Passwords don't match!");
      return;

    }

    //try creating the user:
    try{
      //create the user:
      UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password:passwordTextController.text);

      //after creating the user ,create a new documentin cloud firestore called Users:
      FirebaseFirestore.instance
      .collection("Users")
      .doc(userCredential.user!.email)
      .set({
        'username':emailTextController.text.split('@')[0],//initial user (getting the name from the email)
        'bio': 'Empty bio'//initially empty bio
        //add any additional fields as needed
      });
    //pop loading circle
    if(context.mounted)Get.back();
    }on FirebaseAuthException catch(e){
      //pop loading circle
     Get.back();
      controller.showLoginErrorDialog(e.code);
    }
  }
  //text editing controllers:
  final emailTextController=TextEditingController();
  final passwordTextController=TextEditingController();
  final confirmPasswordTextController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  //the logo:
                  Icon(Icons.lock,
                    size: 100.h,
                  ),
                  SizedBox(height: 50.h,),
                  //welcome back message
                  Text("Let's create an account for you",
                    style: TextStyle(
                        color: Colors.grey[700]
                    ),
                  ),
                  SizedBox(height: 25.h,),
                  //email textfield:
                  MyTextField(controller: emailTextController,
                      hint:'Email', obscureText:
                      false),
                  SizedBox(height: 15.h,),
                  //password textfield:
                  MyTextField(controller: passwordTextController,
                      hint:'Password',
                      obscureText: true),
                  SizedBox(height: 18.h,),
                  //confirm password textfield:
                  MyTextField(controller: confirmPasswordTextController,
                      hint:'Confirm Password',
                      obscureText: true),
                  SizedBox(height: 18.h,),
                  //the SignIn button:
                  SignInButton(
                      text:'Sign Up',
                      onTap:signOut
                  ),
                  SizedBox(height: 25.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                        style: TextStyle(
                            color: Colors.grey[700]
                        ),
                      ),
                      SizedBox(width: 4.w,),
                      GestureDetector(
                        onTap:widget.onTap,
                        child: Text('Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
