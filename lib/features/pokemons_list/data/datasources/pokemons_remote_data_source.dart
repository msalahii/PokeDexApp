import 'dart:convert';
import 'dart:developer';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exception.dart';
import '../../../../utils/constants.dart';

abstract class PokemonsRemoteDataSource {
  Future<PokemonPageModel> fetchPokemonsPage(int pageNo);
  Future<List<PokemonModel>> fetchPokemonsDetailsList(List<String> linksList);
}

class PokemonsRemoteDataSourceImplementation extends PokemonsRemoteDataSource {
  final http.Client client;

  PokemonsRemoteDataSourceImplementation({required this.client});

  @override
  Future<PokemonPageModel> fetchPokemonsPage(int pageNo) async {
    const baseURL = "https://pokeapi.co/api/v2/";
    final url = '${baseURL}pokemon/?offset=${pageNo * 10}&limit=10';
    final response = await client.get(Uri.parse(url), headers: baseHeaders);

    Map<String, dynamic> jsonMap = json.decode(response.body);
    log(response.body);
    switch (response.statusCode) {
      case 200:
        final resultsList = jsonMap['results'] as List;
        if (resultsList.isEmpty) {
          throw const ServerException(
              exceptionMessage: 'No more data to load!');
        } else {
          return PokemonPageModel.fromJson(jsonMap);
        }
      default:
        throw const ServerException(exceptionMessage: 'Server Failure');
    }
  }

  @override
  Future<List<PokemonModel>> fetchPokemonsDetailsList(
      List<String> linksList) async {
    final responses = await Future.wait(
        linksList.map((url) => client.get(Uri.parse(url), headers: baseHeaders)));

    List<PokemonModel> pokemonsList = [];
    for (var response in responses) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        final pokemonModel = PokemonModel.fromJson(jsonMap);
        pokemonsList.add(pokemonModel);
      }
    }

    return pokemonsList;
  }
}