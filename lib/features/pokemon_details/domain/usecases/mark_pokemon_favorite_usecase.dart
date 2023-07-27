import 'package:dartz/dartz.dart';
import 'package:pokedex_app/features/pokemon_details/domain/repositories/pokemon_details_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';

class MarkPokemonAsFavoriteUsecase
    extends Usecase<int, MarkPokemonAsFavoriteUsecaseParams> {
  final PokemonDetailsRepository repository;
  MarkPokemonAsFavoriteUsecase(this.repository);

  @override
  Future<Either<Failure, int>> call(
      MarkPokemonAsFavoriteUsecaseParams params) async {
    return await repository.markPokemonAsFavorite(params.pokemonID);
  }
}

class MarkPokemonAsFavoriteUsecaseParams {
  final int pokemonID;

  MarkPokemonAsFavoriteUsecaseParams({required this.pokemonID});
}
