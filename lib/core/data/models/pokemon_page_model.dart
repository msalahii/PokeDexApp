import 'package:pokedex_app/core/domain/entities/pokemon_page.dart';

class PokemonPageModel extends PokemonPage {
  PokemonPageModel(
      {required int totalPokemons, required List<String> linksList})
      : super(linksList: linksList, totalPokemons: totalPokemons);

  factory PokemonPageModel.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List;
    return PokemonPageModel(
        totalPokemons: json['count'],
        linksList: resultsList.map<String>((e) => e['url']).toList());
  }
}
