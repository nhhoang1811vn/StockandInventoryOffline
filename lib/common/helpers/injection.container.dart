import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.container.config.dart';

final getIt = GetIt.asNewInstance();

@InjectableInit()
void configureDependencies() => getIt.init();