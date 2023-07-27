import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/domain/entities/pokemon.dart';

void main() {
  final pokemonModel = PokemonModel(
      id: 1,
      name: "name",
      imageURL: "imageURL",
      weight: 10,
      height: 10,
      types: [],
      stats: []);

  test('PokemonModel should be a sub-class from Pokemon Entity', () {
    expect(pokemonModel, isA<Pokemon>());
  });

  test('Checking if the BMI value is correct', () {
    final correctBMI =
        pokemonModel.weight / (pokemonModel.height * pokemonModel.height);
    final modelBMI = pokemonModel.getBMI();
    assert(correctBMI == modelBMI);
  });
}
