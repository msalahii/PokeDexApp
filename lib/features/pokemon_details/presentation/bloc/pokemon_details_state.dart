part of 'pokemon_details_bloc.dart';

abstract class PokemonDetailsState extends Equatable {
  const PokemonDetailsState();

  @override
  List<Object> get props => [];
}

class PokemonDetailsInitial extends PokemonDetailsState {}

class MarkPokemonAsFavoriteLoadingState extends PokemonDetailsState {}

class MarkPokemonAsFavoriteSuccessState extends PokemonDetailsState {}

class MarkPokemonAsFavoriteFailedState extends PokemonDetailsState {
  final String failureMessage;

  const MarkPokemonAsFavoriteFailedState({required this.failureMessage});
}


class RemovePokemonFromFavoritesLoadingState extends PokemonDetailsState {}

class RemovePokemonFromFavoritesSuccessState extends PokemonDetailsState {}

class RemovePokemonFromFavoritesFailedState extends PokemonDetailsState {
  final String failureMessage;

  const RemovePokemonFromFavoritesFailedState({required this.failureMessage});
}
