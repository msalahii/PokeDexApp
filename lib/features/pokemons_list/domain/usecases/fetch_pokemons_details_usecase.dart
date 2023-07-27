import 'package:dartz/dartz.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class FetchPokemonsDetailsUsecase
    extends Usecase<List<PokemonModel>, FetchPokemonsDetailsUsecaseParams> {
  final PokemonsListRepository repository;
  FetchPokemonsDetailsUsecase(this.repository);

  @override
  Future<Either<Failure, List<PokemonModel>>> call(
      FetchPokemonsDetailsUsecaseParams params) async {
    return await repository.fetchPokemonsDetails(params.linksList);
  }
}

class FetchPokemonsDetailsUsecaseParams {
  final List<String> linksList;

  FetchPokemonsDetailsUsecaseParams({required this.linksList});
}
