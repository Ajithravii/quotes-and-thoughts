import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotesthoughts/Utils/BasicWidgets.dart';

class ViewUtil extends BasicWidgets{
  const ViewUtil();

  launchPage(BuildContext context, Widget builder) async {
    try {

        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (_) => builder));

    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());
    }
  }

  bool isTablet(BuildContext context) {
    try {
      var shortestDimension = MediaQuery.of(context).size.shortestSide;

      if (shortestDimension > 600) {
        return true;
      } else {
        return false;
      }
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());
      return false;
    }
  }

  bool isSmallMobile(BuildContext context) {
    try {
      var longestDimension = MediaQuery.of(context).size.shortestSide;
      if (longestDimension < 600) {
        return true;
      } else {
        return false;
      }
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());

      return false;
    }
  }

}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
     Key ? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/design/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/design/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}