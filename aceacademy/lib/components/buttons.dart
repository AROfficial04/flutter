import 'package:flutter/material.dart';

class ButtonDe extends StatelessWidget {
 final void Function()? onPressed;
 final String text;
 final Color colorb;
 ButtonDe({super.key,required this.onPressed, required this.text, required this.colorb});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       border: Border.all(color: colorb.withOpacity(0.6)),borderRadius: BorderRadius.circular(12)
      ),
      margin: EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 60,
      child:ElevatedButton(

        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          backgroundColor: colorb.withOpacity(0.5),
        ),
        onPressed: onPressed,child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
    );
  }
}
