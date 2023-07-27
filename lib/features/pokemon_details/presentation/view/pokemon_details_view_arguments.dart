import 'package:flutter/material.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';

class PokemonDetailsViewArguments {
  final PokemonModel pokemon;
  final VoidCallback onFavoriteStatusChanged;

  PokemonDetailsViewArguments(
      {required this.pokemon, required this.onFavoriteStatusChanged});
}
