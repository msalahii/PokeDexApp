import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex_app/features/pokemon_details/domain/usecases/mark_pokemon_favorite_usecase.dart';
import 'package:pokedex_app/features/pokemon_details/domain/usecases/remove_pokemon_from_favorites_usecase.dart';

part 'pokemon_details_event.dart';
part 'pokemon_details_state.dart';

class PokemonDetailsBloc
    extends Bloc<PokemonDetailsEvent, PokemonDetailsState> {
  final MarkPokemonAsFavoriteUsecase _markPokemonAsFavoriteUsecase;
  final RemovePokemonFromFavoritesUsecase _removePokemonFromFavoritesUsecase;
  PokemonDetailsBloc(
      {required MarkPokemonAsFavoriteUsecase markPokemonAsFavoriteUsecase,
      required RemovePokemonFromFavoritesUsecase
          removePokemonFromFavoritesUsecase})
      : _markPokemonAsFavoriteUsecase = markPokemonAsFavoriteUsecase,
        _removePokemonFromFavoritesUsecase = removePokemonFromFavoritesUsecase,
        super(PokemonDetailsInitial()) {
          
    on<MarkPokemonAsFavoriteEvent>((event, emit) async {
      emit(MarkPokemonAsFavoriteLoadingState());
      final params =
          MarkPokemonAsFavoriteUsecaseParams(pokemonID: event.pokemonID);
      final results = await _markPokemonAsFavoriteUsecase(params);
      results.fold(
          (failure) => emit(MarkPokemonAsFavoriteFailedState(
              failureMessage: failure.message)),
          (success) => emit(MarkPokemonAsFavoriteSuccessState()));
    });

    on<RemovePokemonFromFavoriteEvent>((event, emit) async {
      emit(RemovePokemonFromFavoritesLoadingState());
      final params =
          RemovePokemonFromFavoriteUsecaseParams(pokemonID: event.pokemonID);
      final results = await _removePokemonFromFavoritesUsecase(params);
      results.fold(
          (failure) => emit(RemovePokemonFromFavoritesFailedState(
              failureMessage: failure.message)),
          (success) => emit(RemovePokemonFromFavoritesSuccessState()));
    });
  }
}
