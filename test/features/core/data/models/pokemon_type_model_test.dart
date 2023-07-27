import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/data/models/pokemon_types_model.dart';
import 'package:pokedex_app/core/domain/entities/pokemon_type.dart';

void main() {
  final pokemonType = PokemonTypeModel(slot: 1, name: "name");

  test('PokemonTypeModel should be a sub-class from PokemonType Entity', () {
    expect(pokemonType, isA<PokemonType>());
  });
}
