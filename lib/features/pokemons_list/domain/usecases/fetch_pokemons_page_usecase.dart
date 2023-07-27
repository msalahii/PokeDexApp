import 'package:dartz/dartz.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class FetchPokemonsPageUsecase
    extends Usecase<PokemonPageModel, FetchPokemonsPageUsecaseParams> {
  final PokemonsListRepository repository;
  FetchPokemonsPageUsecase(this.repository);

  @override
  Future<Either<Failure, PokemonPageModel>> call(
      FetchPokemonsPageUsecaseParams params) async {
    return await repository.fetchPokemonsPage(params.pageNo);
  }
}

class FetchPokemonsPageUsecaseParams {
  final int pageNo;

  FetchPokemonsPageUsecaseParams({required this.pageNo});
}
