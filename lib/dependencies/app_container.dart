import 'package:pokedex_app/dependencies/pokemon_details_container.dart';
import 'package:pokedex_app/dependencies/pokemons_list_container.dart';

import 'core_container.dart';

init() {
  CoreContainer();
  PokemonsListContainer();
  PokemonsDetailsContainer();
}
