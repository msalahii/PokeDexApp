import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/core/domain/entities/pokemon_page.dart';

void main() {
  final pokemonPageModel = PokemonPageModel(linksList: [], totalPokemons: 10);

  test('PokemonPageModel should be a sub-class from PokemonPage Entity', () {
    expect(pokemonPageModel, isA<PokemonPage>());
  });
}