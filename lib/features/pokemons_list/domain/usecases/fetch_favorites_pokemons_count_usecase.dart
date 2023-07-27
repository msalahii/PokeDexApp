import 'package:dartz/dartz.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class FetchFavoritePokemonsCountUsecase
    extends Usecase<int, NoParams> {
  final PokemonsListRepository repository;
  FetchFavoritePokemonsCountUsecase(this.repository);

  @override
  Future<Either<Failure,int>> call(NoParams params) async {
    return await repository.fetchFavoritesCount();
  }
}
