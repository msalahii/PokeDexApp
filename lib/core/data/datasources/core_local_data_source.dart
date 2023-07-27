import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex_app/utils/constants.dart';

abstract class CoreLocalDataSource {
  Future<List<int>> fetchFavoritesPokemonsIds();
  Future<int> storeFavoritePokemon(int pokemonID);
  Future<void> removeFromFavorites(int pokemonID);
}

class CoreLocalDataSourceImplementation extends CoreLocalDataSource {
  @override
  Future<List<int>> fetchFavoritesPokemonsIds() async {
    final boxValues = Hive.box<int>(pokemonsBoxName).values.toList();
    return boxValues;
  }

  @override
  Future<int> storeFavoritePokemon(int pokemonID) async =>
      await Hive.box<int>(pokemonsBoxName).add(pokemonID);

  @override
  Future<void> removeFromFavorites(int pokemonID) async {
    final box = Hive.box<int>(pokemonsBoxName);
    final Map<dynamic, int> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value == pokemonID) {
        desiredKey = key;
      }
    });
    box.delete(desiredKey);
  }
}
