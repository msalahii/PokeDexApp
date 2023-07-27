import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex_app/core/data/datasources/core_local_data_source.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/core/errors/exception.dart';
import 'package:pokedex_app/core/errors/failure.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemons_list/data/datasources/pokemons_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/features/pokemons_list/data/repositories/pokemons_list_repo_implementation.dart';
import 'pokemons_list_repo_test.mocks.dart';

@GenerateMocks([PokemonsRemoteDataSource, CoreLocalDataSource, NetworkInfo])
void main() {
  late PokemonsListRepositoryImplementation repository;
  late MockPokemonsRemoteDataSource mockPokemonsRemoteDataSource;
  late MockCoreLocalDataSource mockCoreLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockPokemonsRemoteDataSource = MockPokemonsRemoteDataSource();
    mockCoreLocalDataSource = MockCoreLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PokemonsListRepositoryImplementation(
        localDataSource: mockCoreLocalDataSource,
        remoteDataSource: mockPokemonsRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('Fetch Pokemon Page', () {
    const pageNo = 1;
    final model =
        PokemonPageModel(totalPokemons: 10, linksList: ["link1", "link2"]);

    test('should call the remote data source when has internet connection',
        () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.fetchPokemonsPage(pageNo);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource.fetchPokemonsPage(pageNo)).called(1);
      verifyZeroInteractions(mockCoreLocalDataSource);
    });

    test(
        'should get search result data from remote data source when request success 200',
        () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockPokemonsRemoteDataSource.fetchPokemonsPage(pageNo))
          .thenAnswer((realInvocation) async => model);

      // act
      final result = await repository.fetchPokemonsPage(pageNo);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource.fetchPokemonsPage(pageNo)).called(1);
      expect(result, Right(model));
    });

    test('should throw server exception when request failed', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockPokemonsRemoteDataSource..fetchPokemonsPage(pageNo)).thenThrow(
          const ServerException(exceptionMessage: 'exceptionMessage'));

      // act
      final result = await repository.fetchPokemonsPage(pageNo);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource.fetchPokemonsPage(pageNo));
      verifyZeroInteractions(mockCoreLocalDataSource);
      expect(result, equals(const Left(ServerFailure(failureMessage: ''))));
    });
  });

  group('Fetch Pokemon Details', () {
    final model =
        PokemonPageModel(totalPokemons: 10, linksList: ["link1", "link2"]);
    final List<PokemonModel> pokemonsList = [
      PokemonModel(
          id: 1,
          name: "name",
          imageURL: "imageURL",
          weight: 10,
          height: 10,
          types: [],
          stats: [])
    ];

    test('should call the remote data source when has internet connection',
        () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.fetchPokemonsDetails(model.linksList);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource
              .fetchPokemonsDetailsList(model.linksList))
          .called(1);
      verifyZeroInteractions(mockCoreLocalDataSource);
    });

    test(
        'should get search result data from remote data source when request success 200',
        () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockPokemonsRemoteDataSource
              .fetchPokemonsDetailsList(model.linksList))
          .thenAnswer((realInvocation) async => pokemonsList);
      when(mockCoreLocalDataSource.fetchFavoritesPokemonsIds())
          .thenAnswer((realInvocation) async => [1]);

      // act
      final result = await repository.fetchPokemonsDetails(model.linksList);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource
              .fetchPokemonsDetailsList(model.linksList))
          .called(1);
      verify(mockCoreLocalDataSource.fetchFavoritesPokemonsIds()).called(1);
      expect(result, Right(pokemonsList));
    });

    test('should throw server exception when request failed', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockPokemonsRemoteDataSource
              .fetchPokemonsDetailsList(model.linksList))
          .thenThrow(
              const ServerException(exceptionMessage: 'exceptionMessage'));

      // act
      final result = await repository.fetchPokemonsDetails(model.linksList);

      // assert
      verify(mockNetworkInfo.isConnected);
      verify(mockPokemonsRemoteDataSource
          .fetchPokemonsDetailsList(model.linksList));
      verifyZeroInteractions(mockCoreLocalDataSource);
      expect(result, equals(const Left(ServerFailure(failureMessage: ''))));
    });
  });

  group('Fetch Favorites Count', () {
    test('return the count of favorites pokemons', () async {
      //arrange
      when(mockCoreLocalDataSource.fetchFavoritesPokemonsIds())
          .thenAnswer(((realInvocation) async => [1, 2]));

      // act
      final result = await repository.fetchFavoritesCount();

      // assert
      verify(mockCoreLocalDataSource.fetchFavoritesPokemonsIds());
      expect(result, equals(const Right(2)));
    });
  });
}
