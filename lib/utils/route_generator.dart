import 'package:flutter/material.dart';
import 'package:pokedex_app/features/pokemon_details/presentation/view/pokemon_details_view.dart';
import 'package:pokedex_app/features/pokemon_details/presentation/view/pokemon_details_view_arguments.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/pages/pokemons_list_view.dart';
import 'package:pokedex_app/features/splash/presentation/view/splash_view.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case PokemonsListView.routeName:
        return MaterialPageRoute(builder: (_) => const PokemonsListView());

      case PokemonDetailsView.routeName:
        return MaterialPageRoute(
            builder: (_) => PokemonDetailsView(
                arguments: settings.arguments as PokemonDetailsViewArguments));

      default:
        return null;
    }
  }
}
