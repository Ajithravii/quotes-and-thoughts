import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ForceUpdate/forceUpdate.dart';
import '../../Utils/adHelper.dart';
import '../../Utils/creating_directory.dart';
import '../ContactUs/ContactUsView.dart';
import '../LikedQuotes/LikedQuotes.dart';
import '../PrivacyPolicy/PrivacyPolicyView.dart';
import '../QuoteOfDay/QuoteOfDay.dart';
import '../QuoteScreen/QuoteScreenView.dart';
import 'HomeScreenModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class HomeScreenView extends StatefulWidget {
  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> with SingleTickerProviderStateMixin {
  late double screenWidth, screenHeight;
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  bool exitApp = false;
  bool loader = false;
  TextEditingController searchController = TextEditingController();
  final fireStore = FirebaseFirestore.instance;
  bool emptyNotify = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<HomeScreenCategory> category = [];
  String fireBasToken = "";
  String fbToken = "";
  bool _switchValue=false;
  List<HomeScreenCategory> categoryOnSearch = [];
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

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
    final PermissionStatus permissionStatus = await Permission.storage.status;
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

 /* searchOperation(){
    categoryOnSearch.clear();
    if(searchController.text.trim().isNotEmpty){
      for(int i = 0; i < category.length; i++){
        if((category[i].categoryName.toLowerCase().trim().contains(searchController.text.toLowerCase().trim()))){
          var catSearch = [HomeScreenCategory(categoryImage: category[i].categoryImage, categoryName: category[i].categoryName, categoryUid: category[i].categoryUid)].toSet().toList();
          categoryOnSearch.add(catSearch[0]);
          setState(() {});
        }
      }
      if(categoryOnSearch.isEmpty){
        setState(() {
          emptyNotify = true;
        });
      }
    }
  }*/

  searchOperation1({required String text}){
    categoryOnSearch.clear();
    print("filterSearchResults");
    List<HomeScreenCategory> dummySearchList =[];
    dummySearchList.addAll(category);
    if(text.isNotEmpty) {
      List<HomeScreenCategory> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.categoryName.toLowerCase().contains(text.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      print("dummyListData");
      print(dummyListData);
      setState(() {
        categoryOnSearch.clear();
        categoryOnSearch.addAll(dummyListData);
      });
      return;
    }
    else {
      setState(() {
        categoryOnSearch.clear();
        categoryOnSearch.addAll(category);
      });
    }
  }

  loadData() async{
    setState(() {
      loader = true;
    });
    await fireStore.collection("category").get().then((data){
      if(data.docs.isNotEmpty){
        for (int i = 0; i < data.docs.length; i++) {
          category.add(HomeScreenCategory(categoryName: data.docs[i]['name'], categoryImage: data.docs[i]['image'], categoryUid: data.docs[i]['uid']));
          setState(() {});
        }
        categoryOnSearch.addAll(category);
      }
    });
    setState(() {
      loader = false;
    });
  }

  void fireBaseCloudMessagingListeners() {
    _firebaseMessaging.subscribeToTopic('dailyQuote');
  }

  @override
  void initState() {
    final newVersion = AppNewVersion(
      iOSId: '',
      androidId: 'com.quotesthoughts',
    );
    const simpleBehavior = true;
    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }

    fireBaseCloudMessagingListeners();
    _createInlineBannerAd();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    permissionHandler();
    _createBottomBannerAd();
    loadData();
  }

  basicStatusCheck(AppNewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(AppNewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }


  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
                child: Text("Exit App",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight:
                        FontWeight.bold,fontFamily: 'Quicksand',
                        fontSize: 16))),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    20.0)),
            children: [
              Center(
                  child: Text(
                    "Do you really want to Exit the App?",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,fontFamily: 'Quicksand',
                      fontSize: 12,),
                  )),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets
                    .symmetric(
                    horizontal: 15.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color:
                            Colors.grey,
                            fontWeight:
                            FontWeight
                                .w600,
                            fontFamily: 'Quicksand',
                            fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.teal))),
                      ),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color:
                            Colors.white,
                            fontWeight:
                            FontWeight
                                .w600,
                            fontFamily: 'Quicksand',
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              /*SizedBox(height: 10,),
              Container(
                width: _inlineBannerAd.size.width.toDouble(),
                height: _inlineBannerAd.size.height.toDouble(),
                child: AdWidget(ad: _inlineBannerAd),
              ),*/
              SizedBox(height: 10,),
            ],//this right here
            /*child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Exit App",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight:
                              FontWeight.bold,fontFamily: 'Quicksand',
                              fontSize: 16))),
                  Divider(),
                  SizedBox(height: 10,),
                  Center(
                      child: Text(
                        "Do you really want to Exit the App?",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold,fontFamily: 'Quicksand',
                            fontSize: 12,),
                      )),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color:
                                Colors.grey,
                                fontWeight:
                                FontWeight
                                    .w600,
                                fontFamily: 'Quicksand',
                                fontSize: 12),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20)),
                          onPressed: () {
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else if (Platform.isIOS) {
                              exit(0);
                            }
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight
                                    .w600,
                                fontFamily: 'Quicksand',
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: _inlineBannerAd.size.width.toDouble(),
                    height: _inlineBannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _inlineBannerAd),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),*/
          );
        });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        /*bottomNavigationBar: _isBottomBannerAdLoaded ? Container(
          height: _bottomBannerAd.size.height.toDouble(),
          width: _bottomBannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bottomBannerAd),
        ) : null,*/
        backgroundColor: Colors.teal.shade50,
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Quotes & Thoughts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  ],
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg.png"),
                        fit: BoxFit.cover)
                ),
              ),
              ListTile(
                title: const Text('Liked Quotes', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => LikedQuotesView(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Quote of the Day', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => QuoteOfDay(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Tap Sound', style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: Switch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue=value;
                    });
                  },
                ),

              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ContactUsView(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Rate Us', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  try {
                    launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.quotesthoughts"));
                  } on PlatformException catch(e) {
                    print(e);
                  } finally {
                    print("finally");
                  }
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Share App', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  //Share.share("https://play.google.com/store/apps/details?id=com.quotesthoughts");
                  Share.share("Click here to Install : https://play.google.com/store/apps/details?id=com.quotesthoughts");
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => PrivacyPolicy(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ));
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                title: const Text('Version 1.0.0', style: TextStyle(fontSize: 12),),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.transparent),
          shadowColor: Colors.black12,
          backgroundColor: Colors.teal.shade50,
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10,),
                SizedBox(
                  height: screenHeight/20.55,
                  width: screenWidth * 0.80,
                  child: TextField(
                   /* onSubmitted: (value){
                      searchOperation();
                    },*/
                    textInputAction: TextInputAction.search,
                    controller: searchController,
                    autofocus: false,
                    style: const TextStyle(
                        fontSize: 14.0, color: Color(0xff181941)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFf5f5fd),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF7f7f97),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/search_new.svg',
                          color: Color(0xFF616180),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFf5f5fd),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onChanged: (value){
                      searchOperation1(text:value);
                      setState(() {
                        emptyNotify = false;
                      });
                    },
                  ),
                ),
                IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: Icon(Icons.menu_outlined, ))
              ],
            ),
          ),
        ),
        /*appBar: AppBar(
          toolbarHeight:screenHeight/16.44,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.teal.shade50,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(child:Container(
                height: screenHeight/20.55,
                child:TextField(
                onSubmitted: (value){
                  searchOperation();
                },
                textInputAction: TextInputAction.search,
                controller: searchController,
                autofocus: false,
                style: const TextStyle(
                    fontSize: 14.0, color: Color(0xff181941)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFf5f5fd),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF7f7f97),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      'assets/search_new.svg',
                      color: Color(0xFF616180),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFf5f5fd),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFf5f5fd),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFf5f5fd),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value){
                  categoryOnSearch.clear();
                  setState(() {
                    emptyNotify = false;
                  });
                },
              ) ),),
            ],
          ),
        ),*/
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
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: searchController.text.trim().isEmpty ?
            GridView.builder(
              itemCount: categoryOnSearch.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(4.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => QuoteScreenView(categoryName: categoryOnSearch[index].categoryName, categoryId: categoryOnSearch[index].categoryUid,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
                  },
                  child: _customCard(
                    imageUrl: categoryOnSearch[index].categoryImage,
                    item: categoryOnSearch[index].categoryName,
                  )
                );
              },
            )
            : emptyNotify ? const Center(child: Text('Category not found!'),) : GridView.builder(
              itemCount: categoryOnSearch.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                mainAxisSpacing: 4.5,
                crossAxisSpacing: 4.5,
              ),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(4.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => QuoteScreenView(categoryName: categoryOnSearch[index].categoryName, categoryId: categoryOnSearch[index].categoryUid,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ));
                  },
                  child: _customCard(
                    imageUrl: categoryOnSearch[index].categoryImage,
                    item: categoryOnSearch[index].categoryName,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _customCard({required String imageUrl, required String item}){
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 55,
              height: 55,
              child: ClipRRect(
                borderRadius:
                BorderRadius.all(Radius.circular(80)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
              ),
            ),
            Text(
              item,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
