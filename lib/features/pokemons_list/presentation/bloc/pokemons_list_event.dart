part of 'pokemons_list_bloc.dart';

abstract class PokemonsListEvent {}

class FetchPokemonsPageEvent extends PokemonsListEvent {
  final bool isLoadMore;

  FetchPokemonsPageEvent({required this.isLoadMore});
}

class FetchPokemonsDetailsEvent extends PokemonsListEvent {
  final List<String> pokemonsDetailsLinks;
  final bool isLoadMore;

  FetchPokemonsDetailsEvent(
      {required this.pokemonsDetailsLinks, required this.isLoadMore});
}

class FetchFavoritesPokemonsEvent extends PokemonsListEvent {}

class RefreshFavoritePokemonsListEvent extends PokemonsListEvent {}

class FetchFavoritesPokemonsCountEvent extends PokemonsListEvent {}