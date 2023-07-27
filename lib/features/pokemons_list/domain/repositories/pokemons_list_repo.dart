import 'package:dartz/dartz.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import '../../../../core/errors/failure.dart';

abstract class PokemonsListRepository {
  Future<Either<Failure, PokemonPageModel>> fetchPokemonsPage(int pageNo);
  Future<Either<Failure, List<PokemonModel>>> fetchPokemonsDetails(
      List<String> linksList);
  Future<Either<Failure, List<PokemonModel>>> fetchFavoritePokemons();
  Future<Either<Failure, int>> fetchFavoritesCount();
}
