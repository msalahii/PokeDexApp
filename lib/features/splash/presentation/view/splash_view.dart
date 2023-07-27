import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/pages/pokemons_list_view.dart';
import 'package:pokedex_app/utils/styles.dart';

class SplashView extends StatefulWidget {
  static const routeName = '/splash';
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    ///Running Timer on Splash for navigation is not the best practice
    ///splash is best practice here is to call get pokemons endpoint
    ///to get the pokemons to not make the user wait in the other screen
    ///while we have couple seconds that can be used to fetch the data
    ///but in the requirements of this task it was mentioned that the interview
    ///want to see a loading indicator and handling loading while fetching
    ///the pokemons in the pokemons list screen thats why I decided
    /// to just run a timer for 3 seconds to show the splash screen then
    /// navigate to the next one.
    timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, PokemonsListView.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                  width: 75,
                  height: 75,
                  child: SvgPicture.asset('assets/icons/pokemon_icon.svg')),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Pokemon",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "Pokedex",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700),
                ),
              ],
            )
          ],
        ));
  }
}
