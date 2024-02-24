import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/controller/homeController.dart';
import 'package:social_media/view/components/button.dart';
import 'package:social_media/view/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key,required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final HomeController  controller = HomeController();

  void signIn() async{

    //show loading circle:
    controller.showWaitingDialog();

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
       //pop loading circle
      if(context.mounted)Get.back();
    }

    on FirebaseAuthException catch(e){
      //pop loading circle
      if(context.mounted)Get.back();
      controller.showLoginErrorDialog(e.code);
    }


  }

  //text editing controllers:
  final emailTextController=TextEditingController();
  final passwordTextController=TextEditingController();

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
                  Text("Welcome back, you've been missed!",
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
                  //the SignIn button:
                  SignInButton(
                      text:'Sign In',
                      onTap:signIn),
                  SizedBox(height: 25.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('not a member?',
                        style: TextStyle(
                            color: Colors.grey[700]
                        ),
                      ),
                      SizedBox(width: 4.w,),
                      GestureDetector(
                        onTap:widget.onTap,
                        child: Text('Register now',
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
