import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart';
import 'package:pokedex_app/core/errors/failure.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_count_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_details_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_page_usecase.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/bloc/pokemons_list_bloc.dart';
import 'pokemons_list_bloc_test.mocks.dart';

@GenerateMocks(
  [
    FetchPokemonsPageUsecase,
    FetchPokemonsDetailsUsecase,
    FetchFavoritePokemonsCountUsecase,
    FetchFavoritePokemonsUsecase
  ],
)
void main() {
  late PokemonsListBloc bloc;
  late MockFetchPokemonsDetailsUsecase mockFetchPokemonsDetailsUsecase;
  late MockFetchPokemonsPageUsecase mockFetchPokemonsPageUsecase;
  late MockFetchFavoritePokemonsCountUsecase
      mockFetchFavoritePokemonsCountUsecase;
  late MockFetchFavoritePokemonsUsecase mockFetchFavoritePokemonsUsecase;

  setUp(() {
    mockFetchFavoritePokemonsCountUsecase =
        MockFetchFavoritePokemonsCountUsecase();
    mockFetchPokemonsDetailsUsecase = MockFetchPokemonsDetailsUsecase();
    mockFetchFavoritePokemonsUsecase = MockFetchFavoritePokemonsUsecase();
    mockFetchPokemonsPageUsecase = MockFetchPokemonsPageUsecase();

    bloc = PokemonsListBloc(
        fetchPokemonsPageUsecase: mockFetchPokemonsPageUsecase,
        fetchFavoritePokemonsCountUsecase:
            mockFetchFavoritePokemonsCountUsecase,
        fetchFavoritePokemonsUsecase: mockFetchFavoritePokemonsUsecase,
        fetchPokemonsDetailsUsecase: mockFetchPokemonsDetailsUsecase);
  });

  final pokemonPage = PokemonPageModel(totalPokemons: 10, linksList: []);
  final pokemonsList = [
    PokemonModel(
        id: 1,
        name: "name",
        imageURL: "imageURL",
        weight: 10,
        height: 20,
        types: [],
        stats: [])
  ];

  group('FetchPokemonsPageEvent & FetchPokemonsDetailsEvent Testing', () {
    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Success State] when fetching from remote data source success',
        build: () {
          when(mockFetchPokemonsPageUsecase(any))
              .thenAnswer((realInvocation) async => Right(pokemonPage));

          when(mockFetchPokemonsDetailsUsecase(any))
              .thenAnswer((realInvocation) async => Right(pokemonsList));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchPokemonsPageUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchPokemonsPageEvent(isLoadMore: false)),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsSuccessState(pokemonsList: pokemonsList)
            ]);

    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Failed State] when fetching from remote data source fail',
        build: () {
          when(mockFetchPokemonsPageUsecase(any)).thenAnswer(
              (realInvocation) async =>
                  const Left(ServerFailure(failureMessage: 'failureMessage')));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchPokemonsPageUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchPokemonsPageEvent(isLoadMore: false)),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsFailedState(failureMessage: 'failureMessage')
            ]);

    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Failed State] when no internet connection',
        build: () {
          when(mockFetchPokemonsPageUsecase(any))
              .thenAnswer((realInvocation) async => Left(InternetFailure()));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchPokemonsPageUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchPokemonsPageEvent(isLoadMore: false)),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsFailedState(
                  failureMessage: 'Please check your internet connection!')
            ]);
  });

  group('FetchFavoritesPokemonsCountEvent Testing', () {
    blocTest<PokemonsListBloc, PokemonsListState>(
        'Should emit [Success State] when found favorite pokemons in local storage',
        build: () {
          when(mockFetchFavoritePokemonsCountUsecase(any))
              .thenAnswer((realInvocation) async => const Right(1));

          return bloc;
        },
        setUp: () {},
        verify: (_) =>
            verify(mockFetchFavoritePokemonsCountUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchFavoritesPokemonsCountEvent()),
        expect: () => [
              FetchFavoritesPokemonsCountLoadingState(),
              FetchFavoritesPokemonsCountSuccessState(favoritesCount: 1)
            ]);

    blocTest<PokemonsListBloc, PokemonsListState>(
        'Should emit [Failed State] when no favorite pokemons found in local storage',
        build: () {
          when(mockFetchFavoritePokemonsCountUsecase(any)).thenAnswer(
              (realInvocation) async => Left(NoCachedDataFoundFailure()));
          return bloc;
        },
        setUp: () {},
        verify: (_) =>
            verify(mockFetchFavoritePokemonsCountUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchFavoritesPokemonsCountEvent()),
        expect: () => [
              FetchFavoritesPokemonsCountLoadingState(),
              FetchFavoritesPokemonsCountFailedState()
            ]);
  });

  group('FetchFavoritesPokemonsEvent', () {
    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Success State] when fetching from remote data source success',
        build: () {
          when(mockFetchFavoritePokemonsUsecase(any))
              .thenAnswer((realInvocation) async => Right(pokemonsList));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchFavoritePokemonsUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchFavoritesPokemonsEvent()),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsSuccessState(pokemonsList: pokemonsList)
            ]);

    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Failed State] when fetching from remote data source fail',
        build: () {
          when(mockFetchFavoritePokemonsUsecase(any)).thenAnswer(
              (realInvocation) async =>
                  const Left(ServerFailure(failureMessage: 'failureMessage')));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchFavoritePokemonsUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchFavoritesPokemonsEvent()),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsFailedState(failureMessage: 'failureMessage')
            ]);

    blocTest<PokemonsListBloc, PokemonsListState>(
        'should emit [Failed State] when no internet connection',
        build: () {
          when(mockFetchFavoritePokemonsUsecase(any))
              .thenAnswer((realInvocation) async => Left(InternetFailure()));
          return bloc;
        },
        setUp: () {},
        verify: (_) => verify(mockFetchFavoritePokemonsUsecase(any)).called(1),
        act: (bloc) => bloc.add(FetchFavoritesPokemonsEvent()),
        expect: () => [
              FetchPokemonsLoadingState(isLoadMore: false),
              FetchPokemonsFailedState(
                  failureMessage: 'Please check your internet connection!')
            ]);
  });
}
