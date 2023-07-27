part of 'pokemon_details_bloc.dart';

abstract class PokemonDetailsEvent extends Equatable {
  const PokemonDetailsEvent();

  @override
  List<Object> get props => [];
}

class MarkPokemonAsFavoriteEvent extends PokemonDetailsEvent {
  final int pokemonID;

  const MarkPokemonAsFavoriteEvent({required this.pokemonID});
}

class RemovePokemonFromFavoriteEvent extends PokemonDetailsEvent {
  final int pokemonID;

  const RemovePokemonFromFavoriteEvent({required this.pokemonID});
}
