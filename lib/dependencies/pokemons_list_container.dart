import 'package:pokedex_app/dependencies/service_locator.dart';
import 'package:pokedex_app/features/pokemons_list/data/datasources/pokemons_remote_data_source.dart';
import 'package:pokedex_app/features/pokemons_list/data/repositories/pokemons_list_repo_implementation.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_count_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_page_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/bloc/pokemons_list_bloc.dart';
import '../features/pokemons_list/domain/usecases/fetch_pokemons_details_usecase.dart';

class PokemonsListContainer implements ServiceLocator {
  PokemonsListContainer() {
    init();
  }

  @override
  void init() {
    serviceLocator.registerFactory(() => PokemonsListBloc(
        fetchPokemonsPageUsecase: serviceLocator(),
        fetchPokemonsDetailsUsecase: serviceLocator(),
        fetchFavoritePokemonsUsecase: serviceLocator(),
        fetchFavoritePokemonsCountUsecase: serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => FetchPokemonsPageUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => FetchPokemonsDetailsUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => FetchFavoritePokemonsUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => FetchFavoritePokemonsCountUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton<PokemonsListRepository>(() =>
        PokemonsListRepositoryImplementation(
            remoteDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
            localDataSource: serviceLocator()));

    serviceLocator.registerLazySingleton<PokemonsRemoteDataSource>(
        () => PokemonsRemoteDataSourceImplementation(client: serviceLocator()));
  }
}
