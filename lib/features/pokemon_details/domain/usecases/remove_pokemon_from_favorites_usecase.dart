import 'package:dartz/dartz.dart';
import 'package:pokedex_app/features/pokemon_details/domain/repositories/pokemon_details_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class RemovePokemonFromFavoritesUsecase
    extends Usecase<void, RemovePokemonFromFavoriteUsecaseParams> {
  final PokemonDetailsRepository repository;
  RemovePokemonFromFavoritesUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      RemovePokemonFromFavoriteUsecaseParams params) async {
    return await repository.removePokemonFromFavorites(params.pokemonID);
  }
}

class RemovePokemonFromFavoriteUsecaseParams {
  final int pokemonID;

  RemovePokemonFromFavoriteUsecaseParams({required this.pokemonID});
}
