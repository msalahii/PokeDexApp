import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pokedex_app/core/data/models/pokemon_model.dart';
import 'package:pokedex_app/dependencies/service_locator.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/bloc/pokemons_list_bloc.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/widgets/pokemon_card_shimmer.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/widgets/pokemon_card_widget.dart';
import 'package:pokedex_app/utils/styles.dart';

import '../../../pokemon_details/presentation/view/pokemon_details_view.dart';
import '../../../pokemon_details/presentation/view/pokemon_details_view_arguments.dart';

class PokemonsListTab extends StatelessWidget {
  final bool fetchFavorites;
  final VoidCallback onFavoritesListChanged;
  const PokemonsListTab(
      {Key? key,
      required this.fetchFavorites,
      required this.onFavoritesListChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PokemonModel> pokemonsList = [];
    Color backgroundColor = Colors.indigo;
    return BlocProvider<PokemonsListBloc>(
      create: (_) => serviceLocator()
        ..add(fetchFavorites
            ? FetchFavoritesPokemonsEvent()
            : FetchPokemonsPageEvent(isLoadMore: false)),
      child: BlocConsumer<PokemonsListBloc, PokemonsListState>(
          listener: (context, state) {
        if (state is FetchPokemonsSuccessState) {
          pokemonsList = state.pokemonsList;
        } else if (state is FetchPokemonsFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.failureMessage),
            backgroundColor: primaryColor,
          ));
        }
      }, builder: (context, state) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 16, bottom: 16),
          child: LazyLoadScrollView(
            onEndOfPage: () {
              if (!fetchFavorites) {
                BlocProvider.of<PokemonsListBloc>(context)
                    .add(FetchPokemonsPageEvent(isLoadMore: true));
              }
            },
            child: GridView.builder(
              itemCount: state is FetchPokemonsLoadingState && !state.isLoadMore
                  ? 10
                  : state is FetchPokemonsSuccessState
                      ? state.pokemonsList.length
                      : state is FetchPokemonsLoadingState && state.isLoadMore
                          ? pokemonsList.length + 10
                          : 0,
              itemBuilder: ((context, index) {
                if (index % 3 == 0) {
                  backgroundColor = Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .shade200;
                }

                if (state is FetchPokemonsLoadingState && !state.isLoadMore) {
                  return PokemonCardShimmer(backgroundColor: backgroundColor);
                } else if (state is FetchPokemonsLoadingState &&
                    state.isLoadMore) {
                  return index + 1 > pokemonsList.length
                      ? PokemonCardShimmer(backgroundColor: backgroundColor)
                      : PokemonCard(pokemon: pokemonsList[index]);
                }
                return state is FetchPokemonsSuccessState
                    ? InkWell(
                        onTap: () async {
                          Navigator.pushNamed(
                              context, PokemonDetailsView.routeName,
                              arguments: PokemonDetailsViewArguments(
                                  onFavoriteStatusChanged: () {
                                    if (fetchFavorites) {
                                      BlocProvider.of<PokemonsListBloc>(context)
                                          .add(
                                              RefreshFavoritePokemonsListEvent());
                                    }

                                    onFavoritesListChanged();
                                  },
                                  pokemon: state.pokemonsList[index]));
                        },
                        child: PokemonCard(pokemon: state.pokemonsList[index]))
                    : const SizedBox();
              }),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.6),
            ),
          ),
        );
      }),
    );
  }
}
