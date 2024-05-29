
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Utils/DbFunctions.dart';
import '../../Utils/creating_directory.dart';
import '../HomeScreen/HomeScreenView.dart';
import '../QuoteScreen/QuoteModel.dart';
import 'dart:ui' as ui;

class QuoteOfDay extends StatefulWidget {
  @override
  _QuoteOfDayState createState() => _QuoteOfDayState();
}

class _QuoteOfDayState extends State<QuoteOfDay> {
  late double screenWidth, screenHeight;
  final fireStore = FirebaseFirestore.instance;
  late DatabaseHandler handler;
  int indexForBgImage = 0;
  int bgImageIncrement = 0;
  List indexListForLike = [];
  List indexListForShare = [];
  String dropdownValue = 'Image';
  List bgImageList = ["assets/quotes/background.jpg", "assets/quotes/bg2.jpg", "assets/quotes/bg3.jpg"];
  List<QuoteModel> quotes = [];
  bool loader = false;

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

  loadData() async{
    setState(() {
      loader = true;
    });
    await fireStore.collection("quoteOfDay").get().then((data){
      if(data.docs.isNotEmpty){
        for (int i = 0; i < data.docs.length; i++) {
          quotes.add(QuoteModel(quote: data.docs[i]['Quote'], quoteId: data.docs[i]['uid'], category: data.docs[i]['name'], categoryId: data.docs[i]['categoryId']));
          setState(() {});
        }
      }
    });
    setState(() {
      loader = false;
    });
  }

  Widget painter() {
    final GlobalKey _globalKey = GlobalKey();
    return loader ? const Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(),)) : Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {},
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: screenWidth,
                height: 330,
                padding: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(indexForBgImage == 0
                        ? bgImageList[bgImageIncrement]
                        : bgImageList[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Text(
                  quotes[0].quote,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
              ),
            )),
        Container(
          width: screenWidth,
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  int messageidlocal = DateTime.now().microsecondsSinceEpoch;
                  setState(() {
                    if (indexListForLike.contains(0)) {
                      indexListForLike.remove(0);
                    } else {
                      indexListForLike.add(0);
                      handler.insertQuote(QuoteModel(
                          category: 'Quote of the Day',
                          quoteId: messageidlocal.toString(),
                          quote: quotes[0].quote,
                          categoryId: quotes[0].categoryId));
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                        indexListForLike.contains(0)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.teal),
                    Text(
                      indexListForLike.contains(0) ? "Liked" : "Like",
                      style: const TextStyle(color: Colors.teal),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFFEEEEEE),
                    elevation: 0,
                    duration: const Duration(milliseconds: 1500),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    content: const Text(
                      "Saved to library!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    margin: const EdgeInsets.all(90),
                  ));
                  var name = DateTime.now().millisecondsSinceEpoch.toString();
                  final RenderRepaintBoundary boundary =
                      _globalKey.currentContext!.findRenderObject()!
                          as RenderRepaintBoundary;
                  final ui.Image image =
                      await boundary.toImage(pixelRatio: 3.0);
                  final ByteData? byteData =
                      await image.toByteData(format: ui.ImageByteFormat.png);
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
                    Text(
                      "Save",
                      style: TextStyle(color: Colors.teal),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: quotes[0].quote))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFFEEEEEE),
                      elevation: 0,
                      duration: const Duration(milliseconds: 1500),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      content: const Text(
                        "copied to clipboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      margin: const EdgeInsets.all(90),
                    ));
                  });
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.copy,
                      color: Colors.teal,
                    ),
                    Text(
                      "Copy",
                      style: TextStyle(color: Colors.teal),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (indexListForShare.contains(0)) {
                      indexListForShare.remove(0);
                    } else {
                      indexListForShare.add(0);
                    }
                  });
                },
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Visibility(
                      visible: false, child: Icon(Icons.arrow_downward)),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.teal),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Image', 'Text']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      onTap: () async {
                        if (value == "Image") {
                          var name =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          final RenderRepaintBoundary boundary =
                              _globalKey.currentContext!.findRenderObject()!
                                  as RenderRepaintBoundary;
                          final ui.Image image =
                              await boundary.toImage(pixelRatio: 3.0);
                          final ByteData? byteData = await image.toByteData(
                              format: ui.ImageByteFormat.png);
                          final Uint8List pngBytes =
                              byteData!.buffer.asUint8List();
                          File file =
                              File("${appDir.mainDirectory}/" + name + ".png");
                          await file.writeAsBytes(pngBytes);
                          Share.shareFiles([file.path]);
                        } else if (value == "Text") {
                          Share.share(quotes[0].quote);
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
            title: const Text(
              "Quote of the Day",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.47,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(5),
                width: screenWidth,
                height: MediaQuery.of(context).size.height * 0.46,
                child: painter(),
              ),
            ),
          )),
    );
  }
}
