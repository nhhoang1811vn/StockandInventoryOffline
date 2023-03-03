class Utils{
  static bool sameFiles(List<String> files1, List<String> files2){
    if (files1.length != files2.length){
      return false;
    }
    for (var i = 0; i < files1.length ;i++){
      if (files1[i] != files2[i]){
        return false;
      }
    }
    return true;
  }
}