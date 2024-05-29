import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Utils/DbFunctions.dart';
import '../../Utils/adHelper.dart';
import '../../Utils/creating_directory.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';
import '../HomeScreen/HomeScreenView.dart';
import 'QuoteModel.dart';
import 'package:share_plus/share_plus.dart';


class QuoteScreenView extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const QuoteScreenView({Key? key, required this.categoryName, required this.categoryId}) : super(key: key);
  @override
  _QuoteScreenViewState createState() => _QuoteScreenViewState();
}

class _QuoteScreenViewState extends State<QuoteScreenView> with SingleTickerProviderStateMixin {
  late double screenWidth, screenHeight;
  late DatabaseHandler handler;
  int indexForBgImage = 0;
  bool loader = false;
  final fireStore = FirebaseFirestore.instance;
  int bgImageIncrement = 0;
  List indexListForLike = [];
  List indexListForShare = [];
  String dropdownValue = 'Image';
  List bgImageList = ["assets/quotes/background.jpg", "assets/gradblue.jpg",
    "assets/gradient.jpg", "assets/orange.jpg", "assets/1.png",
    "assets/2.png", "assets/3.png", "assets/4.png",
    "assets/5.png", "assets/6.png", "assets/7.png"];

  List bgImageListLong = ["assets/bg_long.png"];
  List<QuoteModel> quotes = [];
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;

  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

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

  Widget painter({required BuildContext context,required int index}){
    final GlobalKey _globalKey = GlobalKey();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: (){
              print(bgImageIncrement);
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
                }
                else{
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
              child: quotes[index].quote.length > 185 ? Container(
                width: screenWidth/1.05,
                height: MediaQuery.of(context).size.height * 0.70,
                padding: EdgeInsets.symmetric(horizontal:screenWidth/9.8 ),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(
                        indexForBgImage == 0 || bgImageIncrement == 10 ?
                        bgImageListLong[0] :
                        indexForBgImage == index ?
                            bgImageIncrement == 0 ?
                            bgImageListLong[0] :
                        bgImageList[bgImageIncrement] :
                        bgImageListLong[0]),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(child: Text(quotes[index].quote,
                  style: TextStyle(color: indexForBgImage == index ?
                  bgImageIncrement == 2 ||
                  bgImageIncrement == 3 ||
                  bgImageIncrement == 4 ||
                  bgImageIncrement == 5 ||
                  bgImageIncrement == 6 ||
                  bgImageIncrement == 7 ||
                  bgImageIncrement == 8 ? Colors.white : Colors.black : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,)),
              ) :
              Container(
                width: screenWidth/1.05,
                height: screenHeight/2.67,
                padding: EdgeInsets.symmetric(horizontal:screenWidth/9.8 ),
                decoration: quotes[index].quote.length > 185 ? BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(indexForBgImage == index ? bgImageList[bgImageIncrement] : bgImageList[0]),
                    fit: BoxFit.cover,
                  ),
                ) : BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(indexForBgImage == index ? bgImageList[bgImageIncrement] : bgImageList[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: Text(quotes[index].quote,
                  style: TextStyle(color: indexForBgImage == index ?
                  bgImageIncrement == 2 ||
                      bgImageIncrement == 3 ||
                      bgImageIncrement == 4 ||
                      bgImageIncrement == 5 ||
                      bgImageIncrement == 6 ||
                      bgImageIncrement == 7 ||
                      bgImageIncrement == 8 ? Colors.white : Colors.black : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,)),
              ),
            )
        ),
        Container(
          width: screenWidth/1.05,
          height: screenHeight/16.5,
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
                  int messageidlocal = DateTime.now().microsecondsSinceEpoch;
                  setState(() {
                    if(indexListForLike.contains(index)){
                      indexListForLike.remove(index);
                    } else{
                      indexListForLike.add(index);
                      handler.insertQuote(QuoteModel(category: widget.categoryName, quoteId: messageidlocal.toString(), quote: quotes[index].quote, categoryId: '123'));
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(indexListForLike.contains(index) ? Icons.favorite : Icons.favorite_border, color: Colors.teal),
                    Text( indexListForLike.contains(index) ? "Liked" : "Like", style: TextStyle(color: Colors.teal),)
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
    setState(() {
      loader = true;
    });
    print(widget.categoryId);
    print("widget.categoryId");
    await fireStore.collection("quotes")
        .where('category_id', isEqualTo: widget.categoryId)
        .get().then((data){
      if(data.docs.isNotEmpty){
        for (int i = 0; i < data.docs.length; i++) {
          quotes.add(QuoteModel(quote: data.docs[i]['quote'].toString(),  category: data.docs[i]['category_name'], quoteId: data.docs[i]['uid'], categoryId: data.docs[i]['category_id']),);
          setState(() {});
        }
      } else{
        print("data.docs[0]");
      }
    });
    setState(() {
      loader = false;
    });
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
    _createInlineBannerAd();
    permissionHandler();
    loadData();
  }

  @override
  void dispose() {
    _inlineBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return HomeScreenView();
          }));
          return false;
        },
        child:Scaffold(
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
          title: Text(widget.categoryName, style: TextStyle(color: Colors.black),),
        ),
        body: loader ?
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.90,
          child: const Center(
            child: SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(),
            ),
          ),
        ) :
        quotes.isEmpty ?
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.90,
          child: const Center(
            child: Text('No Quotes Found!'),
          ),
        ) :
        ListView.builder(
            shrinkWrap: true,
            itemCount: quotes.length,
            itemBuilder: (BuildContext context, int index) {
              return
                /*index % 5 == 0 ?
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(5),
                    width: screenWidth,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: painter(context:context,index:index),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    width: _inlineBannerAd.size.width.toDouble(),
                    height: _inlineBannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _inlineBannerAd),
                  ),
                ],
              ) :*/
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(5),
                width: screenWidth,
                height: quotes[index].quote.length > 185 ? MediaQuery.of(context).size.height * 0.80 :  MediaQuery.of(context).size.height * 0.45,
                child: painter(context:context,index:index),
              );
            })
    ));
  }
}
