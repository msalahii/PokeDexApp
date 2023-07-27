import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/core/data/datasources/core_local_data_source.dart';
import 'package:pokedex_app/dependencies/service_locator.dart';
import '../core/network/network_info.dart';

class CoreContainer extends ServiceLocator {
  CoreContainer() {
    init();
  }

  @override
  void init() async {
    serviceLocator.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImplementation(serviceLocator()));
    serviceLocator.registerLazySingleton(() => http.Client());
    serviceLocator.registerLazySingleton(() => InternetConnectionChecker());

    serviceLocator.registerLazySingleton<CoreLocalDataSource>(
        () => CoreLocalDataSourceImplementation());
  }
}
