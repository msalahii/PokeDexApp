// Mocks generated by Mockito 5.2.0 from annotations
// in pokedex_app/test/features/pokemons_list/presentation/bloc/pokemons_list_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pokedex_app/core/data/models/pokemon_model.dart' as _i9;
import 'package:pokedex_app/core/data/models/pokemon_page_model.dart' as _i7;
import 'package:pokedex_app/core/domain/usecase/usecase.dart' as _i11;
import 'package:pokedex_app/core/errors/failure.dart' as _i6;
import 'package:pokedex_app/features/pokemons_list/domain/repositories/pokemons_list_repo.dart'
    as _i2;
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_count_usecase.dart'
    as _i10;
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_favorites_pokemons_usecase.dart'
    as _i12;
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_details_usecase.dart'
    as _i8;
import 'package:pokedex_app/features/pokemons_list/domain/usecases/fetch_pokemons_page_usecase.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePokemonsListRepository_0 extends _i1.Fake
    implements _i2.PokemonsListRepository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [FetchPokemonsPageUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchPokemonsPageUsecase extends _i1.Mock
    implements _i4.FetchPokemonsPageUsecase {
  MockFetchPokemonsPageUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.PokemonsListRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakePokemonsListRepository_0())
          as _i2.PokemonsListRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.PokemonPageModel>> call(
          _i4.FetchPokemonsPageUsecaseParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, _i7.PokemonPageModel>>.value(
                      _FakeEither_1<_i6.Failure, _i7.PokemonPageModel>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i7.PokemonPageModel>>);
}

/// A class which mocks [FetchPokemonsDetailsUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchPokemonsDetailsUsecase extends _i1.Mock
    implements _i8.FetchPokemonsDetailsUsecase {
  MockFetchPokemonsDetailsUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.PokemonsListRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakePokemonsListRepository_0())
          as _i2.PokemonsListRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>> call(
          _i8.FetchPokemonsDetailsUsecaseParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>>.value(
                      _FakeEither_1<_i6.Failure, List<_i9.PokemonModel>>()))
          as _i5.Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>>);
}

/// A class which mocks [FetchFavoritePokemonsCountUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchFavoritePokemonsCountUsecase extends _i1.Mock
    implements _i10.FetchFavoritePokemonsCountUsecase {
  MockFetchFavoritePokemonsCountUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.PokemonsListRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakePokemonsListRepository_0())
          as _i2.PokemonsListRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, int>> call(_i11.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i6.Failure, int>>.value(
                  _FakeEither_1<_i6.Failure, int>()))
          as _i5.Future<_i3.Either<_i6.Failure, int>>);
}

/// A class which mocks [FetchFavoritePokemonsUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchFavoritePokemonsUsecase extends _i1.Mock
    implements _i12.FetchFavoritePokemonsUsecase {
  MockFetchFavoritePokemonsUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.PokemonsListRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakePokemonsListRepository_0())
          as _i2.PokemonsListRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>> call(
          _i11.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>>.value(
                      _FakeEither_1<_i6.Failure, List<_i9.PokemonModel>>()))
          as _i5.Future<_i3.Either<_i6.Failure, List<_i9.PokemonModel>>>);
}
