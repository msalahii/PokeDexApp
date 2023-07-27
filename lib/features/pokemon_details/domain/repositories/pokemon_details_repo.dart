import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class PokemonDetailsRepository {
  Future<Either<Failure,int>> markPokemonAsFavorite(int pokemonID);
  Future<Either<Failure,void>> removePokemonFromFavorites(int pokemonID);
}
