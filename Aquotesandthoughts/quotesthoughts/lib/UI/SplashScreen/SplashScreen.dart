import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quotesthoughts/UI/HomeScreen/HomeScreenView.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Map _deepLinkData;
  late Map _gcd;

  startTime() async {
    var _duration =  const Duration(seconds: 2);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreenView(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController =  AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    startTime();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );

  }
}
