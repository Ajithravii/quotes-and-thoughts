import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/HomeScreenView.dart';

class ContactUsView extends StatefulWidget {
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final fireStore = FirebaseFirestore.instance;
  bool loader = false;

  uploadQuery() async{
    if(nameController.text.isNotEmpty){
      if(emailController.text.isNotEmpty){
        if(EmailValidator.validate(emailController.text.trim())){
          if(messageController.text.isNotEmpty){
            setState(() {
              loader = true;
            });
            await fireStore.collection("ContactUs").add({
              "name" : nameController.text,
              "email" : emailController.text,
              "Whatsapp" : phoneController.text,
              "message": messageController.text,
              "CreatedTime" : Timestamp.now(),
              "status": 0,
            }).then((value){
              /*Flushbar(
                message: 'Your Query is submitted!',
                titleColor: Colors.white,
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.green,
              ).show(context);*/
              setState(() {
                loader = false;
              });
            });
          } else{
            /*Flushbar(
              message: 'Please enter message!',
              titleColor: Colors.white,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red,
            ).show(context);*/
          }
        } else{
          /*Flushbar(
            message: 'Please enter valid email!',
            titleColor: Colors.white,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
          ).show(context);*/
        }
      } else{
        /*Flushbar(
          message: 'Please enter email!',
          titleColor: Colors.white,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
        ).show(context);*/
      }
    } else{
      /*Flushbar(
        message: 'Please enter name!',
        titleColor: Colors.white,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
      ).show(context);*/
    }

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
            title: const Text('Contact Us', style: TextStyle(color: Colors.black),),
          ),
          body: loader ?
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              ),
            ),
          ) :
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      label: Text('Phone No:(Optional)'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: messageController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      label: Text('Message'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.black)
                              )
                          )
                      ),
                      onPressed: (){
                        uploadQuery();
                      },
                  )
                ],
              ),
            ),
          ),
        ),
        );
  }
}
