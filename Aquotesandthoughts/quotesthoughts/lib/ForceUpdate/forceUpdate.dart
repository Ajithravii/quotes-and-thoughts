import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:html/parser.dart' show parse;
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersion {
  final String localVersion;
  final String storeVersion;
  final String AppLogo;
  final String appStoreLink;
  final String? releaseNotes;

  bool get canUpdate {
    try {
      final localFields = localVersion.split('.');
      final storeFields = storeVersion.split('.');
      String localPad = '';
      String storePad = '';
      for (int i = 0; i < storeFields.length; i++) {
        localPad = localPad + localFields[i].padLeft(3, '0');
        storePad = storePad + storeFields[i].padLeft(3, '0');
      }
      if (localPad.compareTo(storePad) < 0)
        return true;
      else
        return false;
    } catch (e) {
      return localVersion.compareTo(storeVersion).isNegative;
    }
  }

  AppVersion._({
    required this.AppLogo,
    required this.localVersion,
    required this.storeVersion,
    required this.appStoreLink,
    this.releaseNotes,
  });
}

class AppNewVersion {
  final String? iOSId;
  final String? androidId;
  final String? iOSAppStoreCountry;

  AppNewVersion({
    this.androidId,
    this.iOSId,
    this.iOSAppStoreCountry,
  });

  showAlertIfNecessary({required BuildContext context}) async {
    final AppVersion? appVersion = await getVersionStatus();
    if (appVersion != null && appVersion.canUpdate) {
      showUpdateDialog(context: context, versionStatus: appVersion);
    }
  }

  Future<AppVersion?> getVersionStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      return _iosVersion(packageInfo);
    } else if (Platform.isAndroid) {
      return _androidVersion(packageInfo);
    } else {
      debugPrint(
          'The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
    }
  }

  Future<AppVersion?> _iosVersion(PackageInfo packageInfo) async {
    final id = iOSId ?? packageInfo.packageName;
    final parameters = {"bundleId": "$id"};
    if (iOSAppStoreCountry != null) {
      parameters.addAll({"country": iOSAppStoreCountry!});
    }
    var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint('Failed to query iOS App Store');
      return null;
    }
    final jsonObj = json.decode(response.body);
    final List results = jsonObj['results'];
    if (results.isEmpty) {
      debugPrint('Can\'t find an app in the App Store with the id: $id');
      return null;
    }
    return AppVersion._(
      localVersion: packageInfo.version,
      storeVersion: jsonObj['results'][0]['version'],
      appStoreLink: jsonObj['results'][0]['trackViewUrl'],
      releaseNotes: jsonObj['results'][0]['releaseNotes'],
      AppLogo: '',
    );
  }

  Future<AppVersion?> _androidVersion(PackageInfo packageInfo) async {
    final id = androidId ?? packageInfo.packageName;
    final uri =
        Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      debugPrint('Can\'t find an app in the Play Store with the id: $id');
      return null;
    }
    final document = parse(response.body);
    print(document);
    final additionalInfoElements = document.getElementsByClassName('hAyfc');
    final versionElement = additionalInfoElements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    final storeVersion = versionElement.querySelector('.htlgb')!.text;
    print(storeVersion);

    final docimagelink = document.getElementsByClassName('T75of sHb2Xb')[0];
    final finalimagelink = docimagelink.attributes['src'].toString();
    print(finalimagelink);

    final sectionElements = document.getElementsByClassName('W4P4ne');
    final releaseNotesElement = sectionElements.firstWhereOrNull(
      (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
    );
    final releaseNotes = releaseNotesElement
        ?.querySelector('.PHBdkd')
        ?.querySelector('.DWPxHb')
        ?.text;

    return AppVersion._(
      AppLogo: finalimagelink,
      localVersion: packageInfo.version,
      storeVersion: storeVersion,
      appStoreLink: uri.toString(),
      releaseNotes: releaseNotes,
    );
  }

  void showUpdateDialog({
    required BuildContext context,
    required AppVersion versionStatus,
    String dialogTitle = 'Update Available',
    String? dialogText,
    String updateButtonText = 'Update',
    bool allowDismissal = true,
    String dismissButtonText = 'Later',
    VoidCallback? dismissAction,
  }) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final dialogTitleWidget = Container(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        dialogTitle,
        style: TextStyle(fontSize: 20),
      ),
    );
    final dialogTextWidget = Text(
      dialogText ??
          'You can now update ${packageInfo.appName} from ${versionStatus.localVersion} to ${versionStatus.storeVersion}',
    );

    final updateButtonTextWidget = Text(updateButtonText);
    final updateAction = () {
      _launchAppStore(versionStatus.appStoreLink);
      if (allowDismissal) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    };

    List<Widget> actions = [
      Platform.isAndroid
          ? TextButton(
              child: updateButtonTextWidget,
              onPressed: updateAction,
            )
          : CupertinoDialogAction(
              child: updateButtonTextWidget,
              onPressed: updateAction,
            ),
    ];

    if (allowDismissal) {
      final dismissButtonTextWidget = Text(dismissButtonText);
      dismissAction = dismissAction ??
          () => Navigator.of(context, rootNavigator: true).pop();
      actions.add(
        Platform.isAndroid
            ? TextButton(
                child: dismissButtonTextWidget,
                onPressed: dismissAction,
              )
            : CupertinoDialogAction(
                child: dismissButtonTextWidget,
                onPressed: dismissAction,
              ),
      );
    }

    showDialog(
      context: context,
      barrierDismissible: allowDismissal,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Platform.isAndroid
                ? AlertDialog(
                    title: Row(
                      children: [
                        Image.network(
                          versionStatus.AppLogo,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        dialogTitleWidget
                      ],
                    ),
                    content: dialogTextWidget,
                    actions: actions,
                  )
                : CupertinoAlertDialog(
                    title: dialogTitleWidget,
                    content: dialogTextWidget,
                    actions: actions,
                  ),
            onWillPop: () => Future.value(allowDismissal));
      },
    );
  }

  void _launchAppStore(String appStoreLink) async {
    debugPrint(appStoreLink);
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw 'Could not launch appStoreLink';
    }
  }
}
