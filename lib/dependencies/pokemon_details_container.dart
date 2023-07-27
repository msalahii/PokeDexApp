import 'package:pokedex_app/dependencies/service_locator.dart';
import 'package:pokedex_app/features/pokemon_details/domain/repositories/pokemon_details_repo.dart';
import 'package:pokedex_app/features/pokemon_details/domain/usecases/mark_pokemon_favorite_usecase.dart';
import '../features/pokemon_details/data/repositories/pokemon_details_repo_implementation.dart';
import '../features/pokemon_details/domain/usecases/remove_pokemon_from_favorites_usecase.dart';
import '../features/pokemon_details/presentation/bloc/pokemon_details_bloc.dart';

class PokemonsDetailsContainer implements ServiceLocator {
  PokemonsDetailsContainer() {
    init();
  }

  @override
  void init() {
    serviceLocator.registerFactory(() => PokemonDetailsBloc(
        markPokemonAsFavoriteUsecase: serviceLocator(),
        removePokemonFromFavoritesUsecase: serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => MarkPokemonAsFavoriteUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => RemovePokemonFromFavoritesUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton<PokemonDetailsRepository>(() =>
        PokemonDetailsRepositoryImplementation(
            coreLocalDataSource: serviceLocator()));
  }
}
