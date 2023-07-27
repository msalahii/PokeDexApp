import 'package:dartz/dartz.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class FetchFavoritePokemonsUsecase
    extends Usecase<List<PokemonModel>, NoParams> {
  final PokemonsListRepository repository;
  FetchFavoritePokemonsUsecase(this.repository);

  @override
  Future<Either<Failure, List<PokemonModel>>> call(NoParams params) async {
    return await repository.fetchFavoritePokemons();
  }
}
