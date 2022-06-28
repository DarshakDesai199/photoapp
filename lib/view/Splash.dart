import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photoapp/common/Text.dart';
import 'package:photoapp/view/HomeScreen/Home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => Get.off(() => Home()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Ts(
                  text: "Wallpaper",
                  size: 40,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                Ts(
                  text: "Yard",
                  size: 35,
                  color: Color(0xffFFB74D),
                  weight: FontWeight.w500,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
