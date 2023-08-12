import 'package:good_manager/presentation/main.dart';
import 'package:good_manager/presentation/markdown/md_provider.dart';
import 'package:good_manager/presentation/markdown/md_provider_ipm_en.dart';
import 'package:good_manager/presentation/markdown/md_provider_ipm_vn.dart';

class MDProviderFactory{
  static MDProvider get(){
    String code = storage.getLanguageCode();
    if (code == "vi"){
      return MDProviderIpmVN();
    }else{
      return MDProviderIpmEN();
    }
    //add another language here.
  }
}