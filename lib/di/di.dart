import 'package:get_it/get_it.dart';
import 'package:good_manager/di/di.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureDependencies() => getIt.init();
