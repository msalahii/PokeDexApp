import 'package:pokedex_app/core/data/datasources/core_local_data_source.dart';
import 'package:pokedex_app/core/errors/exception.dart';
import 'package:pokedex_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex_app/features/pokemon_details/domain/repositories/pokemon_details_repo.dart';

class PokemonDetailsRepositoryImplementation extends PokemonDetailsRepository {
  final CoreLocalDataSource coreLocalDataSource;

  PokemonDetailsRepositoryImplementation({required this.coreLocalDataSource});

  @override
  Future<Either<Failure, int>> markPokemonAsFavorite(int pokemonID) async {
    try {
      final result = await coreLocalDataSource.storeFavoritePokemon(pokemonID);
      return Right(result);
    } on NoCachedDataFoundException {
      return Left(NoCachedDataFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removePokemonFromFavorites(int pokemonID) async {
    try {
      final result = await coreLocalDataSource.removeFromFavorites(pokemonID);
      return Right(result);
    } catch (e) {
      return Left(NoCachedDataFoundFailure());
    }
  }
}
