# PokeDex App

# State Management (BloC)

BloC has been used as a state management for this project using the following plugins:

- bloc: ^8.0.3
- flutter_bloc: ^8.0.1

```dart
class PokemonDetailsBloc
    extends Bloc<PokemonDetailsEvent, PokemonDetailsState> {
  final MarkPokemonAsFavoriteUsecase _markPokemonAsFavoriteUsecase;
  final RemovePokemonFromFavoritesUsecase _removePokemonFromFavoritesUsecase;
  PokemonDetailsBloc(
      {required MarkPokemonAsFavoriteUsecase markPokemonAsFavoriteUsecase,
      required RemovePokemonFromFavoritesUsecase
          removePokemonFromFavoritesUsecase})
      : _markPokemonAsFavoriteUsecase = markPokemonAsFavoriteUsecase,
        _removePokemonFromFavoritesUsecase = removePokemonFromFavoritesUsecase,
        super(PokemonDetailsInitial()) {
          
    on<MarkPokemonAsFavoriteEvent>((event, emit) async {
      emit(MarkPokemonAsFavoriteLoadingState());
      final params =
          MarkPokemonAsFavoriteUsecaseParams(pokemonID: event.pokemonID);
      final results = await _markPokemonAsFavoriteUsecase(params);
      results.fold(
          (failure) => emit(MarkPokemonAsFavoriteFailedState(
              failureMessage: failure.message)),
          (success) => emit(MarkPokemonAsFavoriteSuccessState()));
    });

    on<RemovePokemonFromFavoriteEvent>((event, emit) async {
      emit(RemovePokemonFromFavoritesLoadingState());
      final params =
          RemovePokemonFromFavoriteUsecaseParams(pokemonID: event.pokemonID);
      final results = await _removePokemonFromFavoritesUsecase(params);
      results.fold(
          (failure) => emit(RemovePokemonFromFavoritesFailedState(
              failureMessage: failure.message)),
          (success) => emit(RemovePokemonFromFavoritesSuccessState()));
    });
  }
}
```

# Dependency Injection (Get It)

Get It has been used as a dependency injection for this project using the following plugins:

- get_it: ^7.2.0

```dart
class PokemonsDetailsContainer implements ServiceLocator {
  PokemonsDetailsContainer() {
    init();
  }

  @override
  void init() {
    serviceLocator.registerFactory(() => PokemonDetailsBloc(
        markPokemonAsFavoriteUsecase: serviceLocator(),
        removePokemonFromFavoritesUsecase: serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => MarkPokemonAsFavoriteUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton(
        () => RemovePokemonFromFavoritesUsecase(serviceLocator()));

    serviceLocator.registerLazySingleton<PokemonDetailsRepository>(() =>
        PokemonDetailsRepositoryImplementation(
            coreLocalDataSource: serviceLocator()));
  }
}
```

# Unit Testing

The following dev plugins has been used for unit testing:

- build_runner:
- mockito: ^5.2.0
    
    Mockito and Build Runner is used for generating mocks required for unit testing.
    
- bloc_test: ^9.0.3
    
    Bloc Test plugin is for testing the BloC.
    

```dart
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
```

# Local Storage & Networking

The following plugins has been used for networking and building local data storage:

- hive_flutter: ^1.1.0
- path_provider: ^2.0.11
    
    Hive and Path Provider has been used for building a local storage for storing the favorite pokemons.
    
    ```dart
    abstract class CoreLocalDataSource {
      Future<List<int>> fetchFavoritesPokemonsIds();
      Future<int> storeFavoritePokemon(int pokemonID);
      Future<void> removeFromFavorites(int pokemonID);
    }
    
    class CoreLocalDataSourceImplementation extends CoreLocalDataSource {
      @override
      Future<List<int>> fetchFavoritesPokemonsIds() async {
        final boxValues = Hive.box<int>(pokemonsBoxName).values.toList();
        return boxValues;
      }
    
      @override
      Future<int> storeFavoritePokemon(int pokemonID) async =>
          await Hive.box<int>(pokemonsBoxName).add(pokemonID);
    
      @override
      Future<void> removeFromFavorites(int pokemonID) async {
        final box = Hive.box<int>(pokemonsBoxName);
        final Map<dynamic, int> deliveriesMap = box.toMap();
        dynamic desiredKey;
        deliveriesMap.forEach((key, value) {
          if (value == pokemonID) {
            desiredKey = key;
          }
        });
        box.delete(desiredKey);
      }
    }
    ```
    
- http: ^0.13.4
- internet_connection_checker: ^0.0.1+4
    
    Internet Checker has been used for checking internet connection before send HTTP request using the http plugin.
    
    ```dart
    abstract class NetworkInfo {
      Future<bool> get isConnected;
    }
    
    class NetworkInfoImplementation implements NetworkInfo {
      final InternetConnectionChecker connectionChecker;
    
      NetworkInfoImplementation(this.connectionChecker);
      @override
      Future<bool> get isConnected => connectionChecker.hasConnection;
    }
    ```
    
    ```dart
    Future<PokemonPageModel> fetchPokemonsPage(int pageNo) async {
        const baseURL = "https://pokeapi.co/api/v2/";
        final url = '${baseURL}pokemon/?offset=${pageNo * 10}&limit=10';
        final response = await client.get(Uri.parse(url), headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    
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
    ```
    

# UI & Widgets

The following plugins has been used in building the UI:

- lazy_load_scrollview: ^1.3.0
    
    Used for builing and infinite scroll functionality with data fetching.
    
- cached_network_image: ^3.2.1
    
    Used for caching network images and handling errors.
    
- shimmer: ^2.0.0
    
    Used for creating loading effects while fetching data from PokeAPI.
    
- google_fonts: ^3.0.1
    
    The font used in the figma file is one of the google font family so thats why this plugin has been used.
    
- flutter_svg: ^1.1.1+1
    
    Used for loading Svg assets in design.
    

# Screen Shots

- Splash Screen

![Splash Screen](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658497479.png)

Splash Screen

![Screenshot_1658498154.png](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658498154.png)

![Home Screen (Loading)](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658497831.png)

Home Screen (Loading)

![Home Screen](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658492662.png)

Home Screen

![Home Screen (Landscape)](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658498077.png)

Home Screen (Landscape)

![Pokemon Details Screen](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658492352.png)

Pokemon Details Screen

![Pokemon Details (Landscape Mode)](PokeDex%20App%201e01b8b46697467fb4d9960b40cfeb51/Screenshot_1658492513.png)

Pokemon Details (Landscape Mode)

# Running Instructions

This project has been developed using the latest flutter version (3.0.5) and configured to work on Android Emulator and IOS Simulator too.

Note: PokeAPI sometimes returns 404 Status code for the pokemons images which is being catched by flutter framework in the run time although it’s been handled by using Cached Network Image Plugin the app will pause and catch those exception is debug mode until clicking on resume from the running panel this is are a framework limitations and has been handled in release mode using the Cached Network Image plugin.

Thanks!
Muhammad Salah