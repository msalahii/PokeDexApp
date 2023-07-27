import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex_app/core/domain/entities/pokemon_type.dart';

class PokemonTypeModel extends PokemonType {
  PokemonTypeModel({required int slot, required String name})
      : super(slot: slot, name: name);

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) =>
      PokemonTypeModel(slot: json['slot'], name: json['type']['name']);

  static List<PokemonTypeModel> decodePokemonTypesList(List<dynamic> list) =>
      list
          .map<PokemonTypeModel>((type) => PokemonTypeModel.fromJson(type))
          .toList();

  Color getBackgroundColor() {
    late Color backgroundColor;
    switch (name) {
      case "fire":
        backgroundColor = Colors.amber.shade100;
        break;
      case "water":
        backgroundColor = Colors.blue.shade100;
        break;
      case "electric":
        backgroundColor = Colors.yellow.shade100;
        break;
      case "grass":
      case "bug":
        backgroundColor = Colors.green.shade100;
        break;
      case "poison":
        backgroundColor = Colors.indigo.shade100;
        break;
      case "normal":
        backgroundColor = Colors.grey.shade100;
        break;
      case "fighting":
        backgroundColor = Colors.red.shade100;
        break;
      case "ground":
      case "rock":
        backgroundColor = Colors.brown.shade100;
        break;
      default:
        backgroundColor = Colors
            .primaries[Random().nextInt(Colors.primaries.length)].shade200;
    }
    return backgroundColor;
  }
}
