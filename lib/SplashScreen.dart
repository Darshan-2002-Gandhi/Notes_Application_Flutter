import 'dart:async';
import 'package:database_demo/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Homepage(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blue,
        child: Center(
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white70,
                ),
                children: [
                  TextSpan(text: 'Gandhi '),
                  TextSpan(text: 'Darshan', style: TextStyle(
                    fontSize: 60.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SquarePeg',
                  )),
                  TextSpan(text: ' Manishbhai')
                ]
            ),
          ),
        ),
      ),
    );
  }
}