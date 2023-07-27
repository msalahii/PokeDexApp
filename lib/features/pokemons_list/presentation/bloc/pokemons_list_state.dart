part of 'pokemons_list_bloc.dart';

abstract class PokemonsListState extends Equatable {}

class PokemonsListInitial extends PokemonsListState {
  @override
  List<Object?> get props => [];
}

class FetchPokemonsLoadingState extends PokemonsListState {
  final bool isLoadMore;

  FetchPokemonsLoadingState({required this.isLoadMore});

  @override
  List<Object?> get props => [isLoadMore];
}

class FetchPokemonsFailedState extends PokemonsListState {
  final String failureMessage;

  FetchPokemonsFailedState({required this.failureMessage});

  @override
  List<Object?> get props => [failureMessage];
}

class FetchPokemonsSuccessState extends PokemonsListState {
  final List<PokemonModel> pokemonsList;

  FetchPokemonsSuccessState({required this.pokemonsList});

  @override
  List<Object?> get props => [pokemonsList];
}

class FetchFavoritesPokemonsCountLoadingState extends PokemonsListState {
  @override
  List<Object?> get props => [];
}

class FetchFavoritesPokemonsCountSuccessState extends PokemonsListState {
  final int favoritesCount;

  FetchFavoritesPokemonsCountSuccessState({required this.favoritesCount});

  @override
  List<Object?> get props => [favoritesCount];
}

class FetchFavoritesPokemonsCountFailedState extends PokemonsListState {
  @override
  List<Object?> get props => [];
}
