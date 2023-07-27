import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex_app/features/splash/presentation/view/splash_view.dart';
import 'package:pokedex_app/utils/constants.dart';
import 'package:pokedex_app/utils/route_generator.dart';
import 'dependencies/app_container.dart' as dependancy_injection;
import 'package:path_provider/path_provider.dart' as path_provider;


void main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await dependancy_injection.init();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<int>(pokemonsBoxName);
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedox App',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
