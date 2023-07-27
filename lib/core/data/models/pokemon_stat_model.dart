import 'package:pokedex_app/core/domain/entities/pokemon_state.dart';

class PokemonStatModel extends PokemonStat {
  PokemonStatModel({required String name, required int value})
      : super(name: name, value: value);

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) =>
      PokemonStatModel(name: json['stat']['name'], value: json['base_stat']);

  static List<PokemonStatModel> decodeStatsList(List<dynamic> list) => list
      .map<PokemonStatModel>((stat) => PokemonStatModel.fromJson(stat))
      .toList();
}
