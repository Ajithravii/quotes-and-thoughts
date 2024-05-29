import 'package:flutter/material.dart';
import '../HomeScreen/HomeScreenView.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {


  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
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
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0,
          title: Text('Privacy Policy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),),
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
        ),
        body: Container(
          //padding: EdgeInsets.all(15),
          child: WebView(
            initialUrl: 'https://sites.google.com/view/quotes-thoughts/',
          ),
          /*Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.80,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Text('Quotes & Thoughts App is a free app made by Quotes and thoughts app team, intended to be used in its current state.', textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("To keep your information safe, We've created this page of privacy policy guidelines.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("If you choose to use our Service, then you agree that we may collect and use your Information to make our app better. Anything that Personal Information is used for includes improving the Service. Unless otherwise described, We will not share or sell your information with anyone other than the Service.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("The definitions found in our Terms and Conditions will carry over to this Privacy Policy. The definition of Terms from the Terms and Conditions are found on Quotes & Thoughts App.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("To provide a better service & experience, our app may request some information. The information is not retained by us, rather utilized on your device to create a unique experience.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Your information may be collected by third-party services.Read the privacy policies of third party service providers used by your app.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("AdMob", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Whenever you use our service, We collect your IP address, phone log data and other information to provide better user experience to end user", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Service Providers Help Create a Positive In-store Experience", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(". We work with third-party companies and individuals because", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    SizedBox(height: 05,),
                    Text(". We need your requirement", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    SizedBox(height: 05,),
                    Text(". To provide customer service", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    SizedBox(height: 05,),
                    Text(". For us to help you better understand how our service is used.", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    SizedBox(height: 10,),
                    Text("We give third parties access to your personal information so they can help us, but they have to agree not to use it for anything else. Mostly by our ad partner AdMob", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Security alerts", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("We use commercially acceptable methods to secure your personal Information, but these are not 100% reliable. Remember that no method of data transmission is secure- we cannot guarantee the security of your personal information.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("3rd Party Links", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("In this Service, you will find links to other sites. These links will lead you to those sites. I am not responsible for the content of these third-party sites or the privacy practices of these third-parties.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Protect Children’s Privacy", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("We never collect any information for children under the age of 13. We delete any personal information we receive if they are under 13 by deleting instantly. If you are aware that your child is providing us with personal information, please contact us and we will take necessary actions.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("Changes to this privacy policy", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("Will update the Privacy Policy on a time to time basis. We suggest you visit the privacy policy periodically for any update. You will be notify for a new privacy update by us.  With Immediate effect changes will be applicable.", textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Text("For questions or suggestions, email us at", textAlign: TextAlign.justify,),
                    Text("quotesthoughts09@gmail.com", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                  ],
                ),
              )
            ],
          ),*/
        ),
      ),
    );
  }
}
