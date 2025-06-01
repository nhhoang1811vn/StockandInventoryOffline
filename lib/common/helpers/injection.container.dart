import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.container.config.dart';

final getIt = GetIt.asNewInstance();

// @InjectableInit()
// void configureDependencies() => getIt.init();

@injectableInit
Future<void> configureDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // This will register everything else (e.g., SharedPrefStorage)
  await getIt.init();
}