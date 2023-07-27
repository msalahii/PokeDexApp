import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/core/domain/entities/pokemon_state.dart';

void main() {
  final pokemonStatModel = PokemonStatModel(name: "name", value: 10);

  test('PokemonStatModel should be a sub-class from PokemonStat Entity', () {
    expect(pokemonStatModel, isA<PokemonStat>());
  });
}
