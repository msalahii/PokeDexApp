import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/dependencies/service_locator.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/bloc/pokemons_list_bloc.dart';
import 'package:pokedex_app/features/pokemons_list/presentation/widgets/pokemons_list_tab.dart';
import 'package:pokedex_app/utils/styles.dart';

class PokemonsListView extends StatelessWidget {
  
  static const String routeName = '/pokemonsList';
  const PokemonsListView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int favoriatesListCount = 0;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/icons/pokemon_icon.svg')),
              const SizedBox(width: 8),
              const Text(
                "Pokedex",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        backgroundColor: greyBackgroundColor,
        body: BlocProvider<PokemonsListBloc>(
          create: (_) =>
              serviceLocator()..add(FetchFavoritesPokemonsCountEvent()),
          child: BlocConsumer<PokemonsListBloc, PokemonsListState>(
              listener: (context, state) {
            if (state is FetchFavoritesPokemonsCountSuccessState) {
              favoriatesListCount = state.favoritesCount;
            } else if (state is FetchFavoritesPokemonsCountFailedState) {
              favoriatesListCount = 0;
            }
          }, builder: (context, state) {
            return Column(
              children: [
                Container(
                    color: Colors.white,
                    child: TabBar(
                        labelColor: Colors.black,
                        indicator: const UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 4.0, color: primaryColor),
                        ),
                        tabs: [
                          const Tab(
                            text: "All Pokemons",
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Favorites"),
                                const SizedBox(width: 4),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: FittedBox(
                                    child: Text(
                                      favoriatesListCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          )
                        ])),
                Expanded(
                  child: TabBarView(children: [
                    PokemonsListTab(
                      onFavoritesListChanged: () {
                        BlocProvider.of<PokemonsListBloc>(context)
                            .add(FetchFavoritesPokemonsCountEvent());
                      },
                      fetchFavorites: false,
                    ),
                    PokemonsListTab(
                      fetchFavorites: true,
                      onFavoritesListChanged: () {
                        BlocProvider.of<PokemonsListBloc>(context)
                            .add(FetchFavoritesPokemonsCountEvent());
                      },
                    )
                  ]),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
