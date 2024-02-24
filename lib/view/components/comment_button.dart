import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
   CommentButton({Key? key,
  required this.onTap
  }) : super(key: key);
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Icon(Icons.comment,
      color: Colors.grey,
      ),
    );
  }
}
