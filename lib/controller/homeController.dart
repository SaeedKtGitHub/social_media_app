import 'package:get/get.dart';
import 'package:flutter/material.dart';
class HomeController extends GetxController {

  void showLoginErrorDialog(String message){
    Get.defaultDialog(

      middleText: message,
      middleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,// Adjust the font size as needed,
        //fontWeight: FontWeight.bold,

      ),
      barrierDismissible: false,
      textConfirm: 'OK',
      confirmTextColor: Colors.blue, // Change the text color to match your theme
      buttonColor: Colors.white, // Customize the button's background color
      onConfirm: () {
        Get.back();


      },
      radius: 10, // Customize the dialog's border radius
    );
  }
  void showWaitingDialog() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
