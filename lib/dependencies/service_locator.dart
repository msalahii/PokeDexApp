import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

abstract class ServiceLocator {
  void init();
}
