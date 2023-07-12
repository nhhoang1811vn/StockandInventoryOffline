import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/settings/bloc/settings_data.dart';

class SettingsCubit extends BaseCubit<SettingsData> {
  SettingsCubit(super.initialData);

  void showSelectLanguageDialog() async {
    /*String currentCode =
        await appDataManager.sharedPrefsHelper.getLanguageCode();
    showDialog(
        context: getContext(),
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
              appDataManager.sharedPrefsHelper.setLanguageCode(code);
              MyApp.setLocale(getContext(), code);
            }),
        barrierDismissible: true);*/
  }

  void onBarcodeScannerPressed() async {
    //Navigator.of(getContext()).pushNamed(Pages.barcode_scanner);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
