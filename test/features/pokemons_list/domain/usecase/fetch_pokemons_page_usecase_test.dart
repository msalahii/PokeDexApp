import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_page_usecase.dart';
import 'fetch_pokemons_page_usecase_test.mocks.dart';

@GenerateMocks([PokemonsListRepository])
void main() {
  late FetchPokemonsPageUsecase usecase;
  late MockPokemonsListRepository repository;

  setUp(() {
    repository = MockPokemonsListRepository();
    usecase = FetchPokemonsPageUsecase(repository);
  });

  final pokemonPage = PokemonPageModel(linksList: [], totalPokemons: 10);

  test(
    'should fetch pokemons page from the repository',
    () async {
      // arrange
      when(repository.fetchPokemonsPage(1))
          .thenAnswer((_) async => Right(pokemonPage));
      // act
      final params = FetchPokemonsPageUsecaseParams(pageNo: 1);
      final result = await usecase(params);

      // assert
      expect(result, Right(pokemonPage));
      verify(repository.fetchPokemonsPage(1));
      verifyNoMoreInteractions(repository);
    },
  );
}
