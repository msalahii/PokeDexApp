import 'package:pokedex_app/core/domain/entities/pokemon.dart';

import 'pokemon_stat_model.dart';
import 'pokemon_types_model.dart';

class PokemonModel extends Pokemon {
  bool isFavorite;
  final List<String> _powersList = [
    'hp',
    'attack',
    'defense',
    'special-attack',
    'special-defense',
    'speed'
  ];

  PokemonModel(
      {required int id,
      required String name,
      required String imageURL,
      required int weight,
      required int height,
      required List<PokemonTypeModel> types,
      required List<PokemonStatModel> stats,
      this.isFavorite = false})
      : super(
            id: id,
            name: name,
            imageURL: imageURL,
            height: height,
            weight: weight,
            stats: stats,
            types: types);

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
        id: json['id'],
        name: json['name'],
        imageURL: json['sprites']['other']['official-artwork']['front_default'],
        weight: json['weight'],
        height: json['height'],
        stats: PokemonStatModel.decodeStatsList(json['stats']),
        types: PokemonTypeModel.decodePokemonTypesList(json['types']));
  }

  double getAveragePower() {
    int totalPowersValue = 0;
    for (var stat in stats) {
      if (_powersList.contains(stat.name)) {
        totalPowersValue += stat.value;
      }
    }
    return totalPowersValue != 0 ? totalPowersValue / 6 : 0;
  }

  double getBMI() {
    return weight / (height * height);
  }
}
