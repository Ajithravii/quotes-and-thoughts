import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApplicationDirectory {
  Directory? creatingFirstMainDirectory;
  Directory? creatingMainDirectory;
  String firstMainDirectory = '';
  String mainDirectory = '';

  Future<void> creatingDirectory() async {

    if (Platform.isAndroid) {
      try {
        creatingFirstMainDirectory = await Directory('/storage/emulated/0/Android/media/com.quotesthoughts').create(recursive: true);
        firstMainDirectory = creatingFirstMainDirectory!.path;
        print("firstMainDirectory");
        print(firstMainDirectory);
        creatingMainDirectory =
        await Directory("/storage/emulated/0/Android/media/com.quotesthoughts/Quotes&Thoughts").create(recursive: true);
        mainDirectory = creatingMainDirectory!.path;
        print(mainDirectory);
      } catch (e) {
        print("Exception on android: $e");
      }
    }else if(Platform.isIOS){
      print("ios directory path");
      Directory? docDir = await getApplicationDocumentsDirectory();
      try {
      creatingFirstMainDirectory = await Directory("${docDir.path}").create(recursive: true);
      firstMainDirectory = creatingFirstMainDirectory!.path;

      creatingMainDirectory = await Directory("$firstMainDirectory/Quotes&Thoughts").create(recursive: true);
      mainDirectory = creatingMainDirectory!.path;
      } catch (e) {
        print("Exception on ios: $e");
      }
    }
  }
}

ApplicationDirectory appDir = ApplicationDirectory();
