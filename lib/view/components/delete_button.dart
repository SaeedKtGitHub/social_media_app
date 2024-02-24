import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key,
  required this.onTap
  }) : super(key: key);
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Icon(Icons.cancel,
      color: Colors.grey,
      ),
    );
  }
}
