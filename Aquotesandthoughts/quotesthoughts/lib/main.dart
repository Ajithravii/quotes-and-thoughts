import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quotesthoughts/UI/SplashScreen/SplashScreen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp( MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,home: AnimatedSplashScreen()));
}