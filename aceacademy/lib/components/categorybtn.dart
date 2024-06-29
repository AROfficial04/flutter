import 'package:flutter/material.dart';

class CateBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
   CateBtn({super.key,required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
margin: EdgeInsets.all(10),clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.purple
        ),
        child: ElevatedButton(onPressed: onPressed, child: Text(text)));
  }
}
