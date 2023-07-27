import 'package:pokedex_app/core/data/datasources/core_local_data_source.dart';
import 'package:pokedex_app/core/errors/failure.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:dartz/dartz.dart';
import 'package:pokedex_app/features/pokemons_list/data/datasources/pokemons_remote_data_source.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/network/network_info.dart';

class PokemonsListRepositoryImplementation extends PokemonsListRepository {
  final NetworkInfo networkInfo;
  final PokemonsRemoteDataSource remoteDataSource;
  final CoreLocalDataSource localDataSource;

  PokemonsListRepositoryImplementation(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, List<PokemonModel>>> fetchPokemonsDetails(
      List<String> linksList) async {
    List<PokemonModel> pokemonsList = [];
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(InternetFailure());
      } else {
        pokemonsList =
            await remoteDataSource.fetchPokemonsDetailsList(linksList);
        final favoritesList = await localDataSource.fetchFavoritesPokemonsIds();
        for (var pokemon in pokemonsList) {
          if (favoritesList.contains(pokemon.id)) {
            pokemon.isFavorite = true;
          }
        }
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.exceptionMessage));
    } catch (e) {
      return Left(InternetFailure());
    }

    return Right(pokemonsList);
  }

  @override
  Future<Either<Failure, PokemonPageModel>> fetchPokemonsPage(
      int pageNo) async {
    PokemonPageModel page;
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(InternetFailure());
      } else {
        page = await remoteDataSource.fetchPokemonsPage(pageNo);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.exceptionMessage));
    } catch (e) {
      return Left(InternetFailure());
    }

    return Right(page);
  }

  @override
  Future<Either<Failure, List<PokemonModel>>> fetchFavoritePokemons() async {
    final idsList = await localDataSource.fetchFavoritesPokemonsIds();
    List<String> linksList = [];
    for (int id in idsList) {
      linksList.add("https://pokeapi.co/api/v2/pokemon/$id/");
    }
    return await fetchPokemonsDetails(linksList);
  }

  @override
  Future<Either<Failure, int>> fetchFavoritesCount() async {
    try {
      final pokemonsList = await localDataSource.fetchFavoritesPokemonsIds();
      return Right(pokemonsList.length);
    } on NoCachedDataFoundException {
      return Left(NoCachedDataFoundFailure());
    }
  }
}
