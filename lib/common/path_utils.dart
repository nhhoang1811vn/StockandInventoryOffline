import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PathUtils{
  static final PathUtils _singleton = PathUtils._internal();

  factory PathUtils() {
    return _singleton;
  }

  PathUtils._internal();

  getDatabasePath() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = "";
    if (io.Platform.isWindows){
      String appName = "AppViet_GoodManager";
      path = join(documentsDirectory.path,appName, "main.db");
    }else{
      path = join(documentsDirectory.path, "main.db");
    }
    return path;
  }
}