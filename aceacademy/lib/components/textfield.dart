import 'package:flutter/material.dart';

class TextFie extends StatelessWidget {
  final String text;
  final bool obsecure;
  final IconData? pIcon;
  final TextEditingController controller;
  const TextFie({super.key, required this.text, required this.obsecure, required this.pIcon, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 60,
        child: TextField(
          style: TextStyle(color: Colors.white),
          obscureText: obsecure,
        controller: controller,
        decoration: InputDecoration(
enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),borderRadius: BorderRadius.circular(12)
),
          focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),borderRadius: BorderRadius.circular(12)
          ),
          fillColor: Colors.white.withOpacity(0.3),
          hintText: text,hintStyle: TextStyle(color: Colors.white38,fontWeight: FontWeight.w400),
          prefixIcon: Icon(pIcon),
        
            filled: true,
          prefixIconColor: Colors.white,

        ),
        ),
      ),
    );
  }
}
