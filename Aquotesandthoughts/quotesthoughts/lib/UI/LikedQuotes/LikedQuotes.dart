import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Utils/BasicWidgets.dart';
import '../../Utils/DbFunctions.dart';
import '../../Utils/creating_directory.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';
import '../HomeScreen/HomeScreenView.dart';
import 'package:share_plus/share_plus.dart';

import '../QuoteScreen/QuoteModel.dart';


class LikedQuotesView extends StatefulWidget {
  LikedQuotesView({Key? key}) : super(key: key);
  @override
  _LikedQuotesViewState createState() => _LikedQuotesViewState();
}

class _LikedQuotesViewState extends State<LikedQuotesView> with SingleTickerProviderStateMixin {
  late double screenWidth, screenHeight;
  late DatabaseHandler handler;
  int indexForBgImage = 0;
  int bgImageIncrement = 0;
  List indexListForLike = [];
  List indexListForShare = [];
  String dropdownValue = 'Image';
  List bgImageList = ["assets/quotes/background.jpg", "assets/quotes/bg2.jpg", "assets/quotes/bg3.jpg"];
  List<QuoteModel> quotes = [];

  permissionHandler() async {
    final PermissionStatus permissionStatus =
    await Permission.storage.status;
    if (permissionStatus == PermissionStatus.granted) {
      if (appDir.mainDirectory.isEmpty) {
        appDir.creatingDirectory();
      }
    }else if(permissionStatus == PermissionStatus.denied){
      await Permission.storage.request();
      permissionHandler();
    } else{
      await Permission.storage.request();
      permissionHandler();
    }
  }

  Widget painter(int index){
    final GlobalKey _globalKey = GlobalKey();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: screenWidth,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Center(
            child: Text(quotes[index].category, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),
          )
        ),
        GestureDetector(
            onTap: (){
              setState(() {
                if(indexForBgImage == index){
                  if(bgImageIncrement < bgImageList.length - 1){
                    bgImageIncrement++;
                    setState(() {});
                  }else{
                    if(bgImageIncrement == bgImageList.length - 1){
                      bgImageIncrement = 0;
                      setState(() {});
                    }
                  }
                }else{
                  indexForBgImage = index;
                  if(bgImageIncrement < bgImageList.length - 1){
                    bgImageIncrement++;
                    setState(() {});
                  }else{
                    if(bgImageIncrement == bgImageList.length - 1){
                      bgImageIncrement = 0;
                      setState(() {});
                    }
                  }
                }
              });
            },
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: screenWidth,
                height: 330,
                padding: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(indexForBgImage == index ? bgImageList[bgImageIncrement] : bgImageList[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: Text(quotes[index].quote, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
              ),
            )
        ),
        Container(
          width: screenWidth,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    handler.deleteQuote(quotes[index].quoteId);
                    loadData();
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.favorite, color: Colors.teal),
                    Text("Liked", style: TextStyle(color: Colors.teal),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFFEEEEEE),
                    elevation: 0,
                    duration: const Duration(milliseconds: 1500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    content: const Text("Saved to library!", textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),),
                    margin: const EdgeInsets.all(90),
                  ));
                  var name = DateTime.now().millisecondsSinceEpoch.toString();
                  final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
                  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                  final Uint8List pngBytes = byteData!.buffer.asUint8List();
                  File file = File("${appDir.mainDirectory}/" + name + ".png");
                  await file.writeAsBytes(pngBytes);
                  var bs64 = base64Encode(pngBytes);
                  print(pngBytes);
                  print(bs64);
                  setState(() {});
                },
                child: Row(
                  children: const [
                    Icon(Icons.download_rounded, color: Colors.teal),
                    Text("Save", style: TextStyle(color: Colors.teal),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: quotes[index].quote)).then((_){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFFEEEEEE),
                      elevation: 0,
                      duration: const Duration(milliseconds: 1500),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      content: const Text("copied to clipboard", textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),),
                      margin: const EdgeInsets.all(90),
                    ));
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.copy, color: Colors.teal,),
                    Text("Copy", style: TextStyle(color: Colors.teal),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(indexListForShare.contains(index)){
                      indexListForShare.remove(index);
                    }else{
                      indexListForShare.add(index);
                    }
                  });
                },
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.teal),
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Image', 'Text']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      onTap: () async{
                        if(value == "Image"){
                          var name = DateTime.now().millisecondsSinceEpoch.toString();
                          final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
                          final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                          final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                          final Uint8List pngBytes = byteData!.buffer.asUint8List();
                          File file = File("${appDir.mainDirectory}/" + name + ".png");
                          await file.writeAsBytes(pngBytes);
                          Share.shareFiles([file.path]);
                        } else if(value == "Text"){
                          Share.share(quotes[index].quote);
                        }
                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.share, color: Colors.teal),
                          ),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  loadData() async{
      quotes = await handler.quotes();
      print("quotes kkkkk");
      print(quotes);
      setState(() {});
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    handler = DatabaseHandler();
    permissionHandler();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreenView(),
          ),
        );
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.teal.shade50,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            shadowColor: Colors.black12,
            backgroundColor: Colors.teal.shade50,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreenView(),
                    ),
                  );
                }),
            title: const Text('Liked Quotes', style: TextStyle(color: Colors.black),),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.90,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: quotes.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(5),
                      width: screenWidth,
                      height: MediaQuery.of(context).size.height * 0.51,
                      child: painter(index),
                    );
                  }),
            ),
          )
      ),
    );
  }
}
