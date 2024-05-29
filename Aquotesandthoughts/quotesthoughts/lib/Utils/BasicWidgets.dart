import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quotesthoughts/Constants/ColorProperties.dart';
import 'package:quotesthoughts/Utils/ValidationUtils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasicWidgets {
  const BasicWidgets();
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key ? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  const RoundedButton({
    Key ? key,
    required this.text,
    required this.press,
    this.color = Colors.teal,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: color))),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final VoidCallback press;
  SocalIcon({
    Key ? key,
    required this.iconSrc,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.teal.shade50,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

class MainWidgets extends BasicWidgets{
  const MainWidgets();

  Widget getWillPopScopeWidget(
      BuildContext context,
      WillPopCallback onWillPop,
      Widget bodyContainer,
      bool resizeToAvoidBottomPadding,
      GlobalKey<ScaffoldState> formKey) {
    try {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            body: new GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: bodyContainer,
            ),
            resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
            key: formKey),
      );
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());
      return new Container();
    }
  }


  Widget getLogoImage(){
    return Container(
      child: Image.asset(
        "logoImage",
        height: 60.0,
        width: 90.0,
      ),
    );
  }

  Widget getTextWithBoldCenterAndAppOrange(
      String text,
      int maxLines,
      double fontSize) {
    try {
      ValidationUtil validationUtil = const ValidationUtil();
      text = validationUtil.checkStringForEmpty(text);
      return FittedBox(
          fit: BoxFit.contain,
          child: AutoSizeText(
              text,
              textAlign: TextAlign.center,
              maxLines: maxLines,
              style: TextStyle(
                  fontSize: fontSize,
                  color: appColorOrange,
                  fontWeight: FontWeight.bold)));
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());

      return new Container();
    }
  }


  Widget getTextWithBoldAndCenter(
      String text,
      Color color,
      int maxLines,
      double fontSize) {
    try {
      ValidationUtil validationUtil = const ValidationUtil();
      text = validationUtil.checkStringForEmpty(text);
      return FittedBox(
          fit: BoxFit.contain,
          child: AutoSizeText(
              text,
              textAlign: TextAlign.center,
              maxLines: maxLines,
              style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                  fontWeight: FontWeight.bold)));
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());

      return new Container();
    }
  }

  Widget getText(
      String text,
      Color color,
      int maxLines,
      double fontSize,
      bool fontWeight,) {
    try {
      ValidationUtil validationUtil = const ValidationUtil();
      text = validationUtil.checkStringForEmpty(text);
      return FittedBox(
          fit: BoxFit.contain,
          child: AutoSizeText(
              text,
              maxLines: maxLines,
              style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                  fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'AvenirLTDStd',
                  )));
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());
      return new Container();
    }
  }

  Widget getTextWithUnderlineAndOnTap(
      String text,
      VoidCallback onPressed,
      Color color,
      int maxLines,
      double fontSize,
      bool textBold) {
    try {
      ValidationUtil validationUtil = const ValidationUtil();
      text = validationUtil.checkStringForEmpty(text);
      return InkWell(
        onTap: onPressed,
        child: FittedBox(
            fit: BoxFit.contain,
            child: AutoSizeText(
                text,
                textAlign: TextAlign.center,
                maxLines: maxLines,
                style: TextStyle(
                    fontSize: fontSize,
                    decoration: TextDecoration.underline,
                    color: color,
                    fontWeight: textBold ? FontWeight.bold : FontWeight.normal))),
      );
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());

      return new Container();
    }
  }

  Widget getFullsizeButton(
      BuildContext context,
      VoidCallback onPressed,
      String buttonText,
      double buttonHeight,
      ){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(minHeight: buttonHeight),
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: appAnotherColorGreen,
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget getFullsizeButtonInOrange(
      BuildContext context,
      VoidCallback onPressed,
      String buttonText,
      double buttonHeight,
      ){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(minHeight: buttonHeight),
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: appColorOrange,
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget getContainerWithImage(
      BuildContext context,
      double ContainerWidth,
      double HeightContainer,
      String ImagePath,
      ){
    return Container(
      width: ContainerWidth,
      height: HeightContainer,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget getTextFieldWithFullSizeAndGray(
      BuildContext context,
      FormFieldSetter<String> onSaved,
      FocusNode focusNode,
      TextInputType inputType,
      String labelText,
      TextEditingController textEditingController,
      bool obsecureText,
      ){
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      child: TextFormField(
        obscureText: obsecureText,
        keyboardType: inputType,
        onSaved: onSaved,
        focusNode: focusNode,
        controller: textEditingController,
        style: TextStyle(
          height: 1.5,
          color:  Colors.black,
          fontSize: 16 ,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color:  Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            // contentPadding: EdgeInsets.all(18),
            contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }


  Widget getTextFieldWithSiffixIcon(
      BuildContext context,
      FormFieldSetter<String> onSaved,
      FocusNode focusNode,
      TextInputType inputType,
      String labelText,
      TextEditingController textEditingController,
      bool obsecureText,
      IconData suffixIcon,
      ){
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      child: TextFormField(
        obscureText: obsecureText,
        keyboardType: inputType,
        onSaved: onSaved,
        focusNode: focusNode,
        controller: textEditingController,
        style: TextStyle(
          height: 1.5,
          color:  Colors.black,
          fontSize: 16 ,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color:  Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(4.0),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: Icon(suffixIcon),
            ),
            // contentPadding: EdgeInsets.all(18),
            contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

}




