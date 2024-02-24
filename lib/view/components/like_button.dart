import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
   LikeButton({Key? key,required this.onTap,required this.isLiked}) : super(key: key);
  final bool isLiked;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLiked
          ? Icon(
        Icons.favorite,
        color: Colors.red,
      )
          : Icon(
        Icons.favorite_border,
        color: Colors.grey,
      ),
    );

  }
}
