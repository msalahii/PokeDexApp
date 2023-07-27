import 'package:pokedex_app/core/domain/entities/pokemon_state.dart';
import 'package:pokedex_app/core/domain/entities/pokemon_type.dart';

class Pokemon {
  final int id;
  final String name, imageURL;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final int weight, height;

  Pokemon(
      {required this.id,
      required this.name,
      required this.imageURL,
      required this.types,
      required this.stats,
      required this.weight,
      required this.height});
}
