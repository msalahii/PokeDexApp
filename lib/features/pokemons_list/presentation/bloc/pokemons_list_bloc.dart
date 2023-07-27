import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_count_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_details_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_page_usecase.dart';
import '../../../../core/domain/usecase/usecase.dart';
part 'pokemons_list_event.dart';
part 'pokemons_list_state.dart';

class PokemonsListBloc extends Bloc<PokemonsListEvent, PokemonsListState> {
  final FetchPokemonsPageUsecase _fetchPokemonsPageUsecase;
  final FetchPokemonsDetailsUsecase _fetchPokemonsDetailsUsecase;
  final FetchFavoritePokemonsUsecase _fetchFavoritePokemonsUsecase;
  final FetchFavoritePokemonsCountUsecase _fetchFavoritePokemonsCountUsecase;
  PokemonsListBloc(
      {required FetchPokemonsPageUsecase fetchPokemonsPageUsecase,
      required FetchPokemonsDetailsUsecase fetchPokemonsDetailsUsecase,
      required FetchFavoritePokemonsUsecase fetchFavoritePokemonsUsecase,
      required FetchFavoritePokemonsCountUsecase
          fetchFavoritePokemonsCountUsecase})
      : _fetchPokemonsDetailsUsecase = fetchPokemonsDetailsUsecase,
        _fetchPokemonsPageUsecase = fetchPokemonsPageUsecase,
        _fetchFavoritePokemonsUsecase = fetchFavoritePokemonsUsecase,
        _fetchFavoritePokemonsCountUsecase = fetchFavoritePokemonsCountUsecase,
        super(PokemonsListInitial()) {
    int currentPageNo = 0;
    List<PokemonModel> pokemonsList = [];
    List<PokemonModel> favoritesList = [];

    on<FetchPokemonsPageEvent>((event, emit) async {
      if (event.isLoadMore) {
        emit(FetchPokemonsLoadingState(isLoadMore: event.isLoadMore));
        currentPageNo++;
        final params = FetchPokemonsPageUsecaseParams(pageNo: currentPageNo);
        final results = await _fetchPokemonsPageUsecase(params);
        results.fold(
            (failure) =>
                emit(FetchPokemonsFailedState(failureMessage: failure.message)),
            (success) {
          add(FetchPokemonsDetailsEvent(
              pokemonsDetailsLinks: success.linksList,
              isLoadMore: event.isLoadMore));
        });
      } else {
        log("Pokemons List:" + pokemonsList.length.toString());
        if (pokemonsList.isNotEmpty) {
          emit(FetchPokemonsSuccessState(pokemonsList: pokemonsList));
        } else {
          emit(FetchPokemonsLoadingState(isLoadMore: event.isLoadMore));
          final params = FetchPokemonsPageUsecaseParams(pageNo: currentPageNo);
          final results = await _fetchPokemonsPageUsecase(params);
          results.fold(
              (failure) => emit(
                  FetchPokemonsFailedState(failureMessage: failure.message)),
              (success) {
            add(FetchPokemonsDetailsEvent(
                pokemonsDetailsLinks: success.linksList,
                isLoadMore: event.isLoadMore));
          });
        }
      }
    });

    on<FetchPokemonsDetailsEvent>((event, emit) async {
      final params = FetchPokemonsDetailsUsecaseParams(
          linksList: event.pokemonsDetailsLinks);
      final results = await _fetchPokemonsDetailsUsecase(params);
      results.fold(
          (failure) =>
              emit(FetchPokemonsFailedState(failureMessage: failure.message)),
          (success) {
        if (event.isLoadMore) {
          pokemonsList.addAll(success);
        } else {
          pokemonsList = success;
        }
        emit(FetchPokemonsSuccessState(pokemonsList: pokemonsList));
      });
    });

    on<FetchFavoritesPokemonsEvent>((event, emit) async {
      emit(FetchPokemonsLoadingState(isLoadMore: false));
      final results = await _fetchFavoritePokemonsUsecase(NoParams());
      results.fold(
          (failure) =>
              emit(FetchPokemonsFailedState(failureMessage: failure.message)),
          (success) {
        favoritesList = success;
        emit(FetchPokemonsSuccessState(pokemonsList: favoritesList));
      });
    });

    on<RefreshFavoritePokemonsListEvent>((event, emit) async {
      favoritesList.removeWhere((element) => !element.isFavorite);
      emit(FetchPokemonsSuccessState(pokemonsList: favoritesList));
    });

    on<FetchFavoritesPokemonsCountEvent>((event, emit) async {
      emit(FetchFavoritesPokemonsCountLoadingState());
      final result = await _fetchFavoritePokemonsCountUsecase(NoParams());
      result.fold(
          (failure) => emit(FetchFavoritesPokemonsCountFailedState()),
          (success) => emit(FetchFavoritesPokemonsCountSuccessState(
              favoritesCount: success)));
    });
  }
}
