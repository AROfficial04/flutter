import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  final Widget chilD;
  final double sx;
  final double sy;
  final bool enaborder;

  const FrostedGlass({super.key, required this.chilD, required this.sx, required this.sy, required this.enaborder});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        
          border: Border.all(color: Colors.white.withOpacity(0.3)),borderRadius: BorderRadius.circular(12)
          , gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,end:Alignment.bottomRight
      )
      ),
      // color: Colors.transparent,
     
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sx, sigmaY: sy),
            child: Container(

              padding: EdgeInsets.all(20),

decoration: BoxDecoration(
 border: enaborder ? Border.all(color: Colors.white.withOpacity(0.3)): null ,borderRadius: BorderRadius.circular(12),
  // color: Colors.white.withOpacity(0.1),

),

              child: chilD,

            ),
          )
        ],
      ),
    );
  }
}
