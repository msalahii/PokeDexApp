import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/core/data/models/pokemon_types_model.dart';
import 'package:pokedex_app/dependencies/service_locator.dart';
import 'package:pokedex_app/features/pokemon_details/presentation/bloc/pokemon_details_bloc.dart';
import 'package:pokedex_app/features/pokemon_details/presentation/view/pokemon_details_view_arguments.dart';
import 'package:pokedex_app/features/pokemon_details/presentation/widget/pokemon_stat_widget.dart';
import 'package:pokedex_app/utils/styles.dart';
import 'package:pokedex_app/utils/extensions.dart';

// ignore: must_be_immutable
class PokemonDetailsView extends StatelessWidget {
  final PokemonDetailsViewArguments arguments;
  static const routeName = '/pokemonDetails';
  PokemonDetailsView({Key? key, required this.arguments}) : super(key: key);
  bool isParentNeedsRefresh = false;

  @override
  Widget build(BuildContext context) {
    final typesNamesList =
        arguments.pokemon.types.map((type) => type.name).toList();
    String typesString = '';
    for (var element in typesNamesList) {
      if (typesString.isEmpty) {
        typesString = element.capitalize;
      } else {
        typesString = "$typesString, ${element.capitalize}";
      }
    }
    final mainPokemonType = arguments.pokemon.types[0] as PokemonTypeModel;
    return Scaffold(
      backgroundColor: greyBackgroundColor,
      floatingActionButton: BlocProvider<PokemonDetailsBloc>(
        create: (_) => serviceLocator(),
        child: BlocConsumer<PokemonDetailsBloc, PokemonDetailsState>(
            listener: (context, state) {
          if (state is MarkPokemonAsFavoriteSuccessState) {
            arguments.pokemon.isFavorite = true;
            isParentNeedsRefresh = true;
          } else if (state is RemovePokemonFromFavoritesSuccessState) {
            arguments.pokemon.isFavorite = false;
            isParentNeedsRefresh = true;
          }
        }, builder: (context, state) {
          return InkWell(
            onTap: () {
              if (arguments.pokemon.isFavorite) {
                if (state is! RemovePokemonFromFavoritesLoadingState) {
                  BlocProvider.of<PokemonDetailsBloc>(context).add(
                      RemovePokemonFromFavoriteEvent(
                          pokemonID: arguments.pokemon.id));
                }
              } else {
                if (state is! MarkPokemonAsFavoriteLoadingState) {
                  BlocProvider.of<PokemonDetailsBloc>(context).add(
                      MarkPokemonAsFavoriteEvent(
                          pokemonID: arguments.pokemon.id));
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: arguments.pokemon.isFavorite
                      ? lightIndigoColor
                      : primaryColor,
                  borderRadius: BorderRadius.circular(36)),
              child: Text(
                arguments.pokemon.isFavorite
                    ? "Remove from favourites"
                    : "Mark as favorite",
                style: TextStyle(
                    color: arguments.pokemon.isFavorite
                        ? primaryColor
                        : Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
        }),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 88,
            expandedHeight: 288,
            stretch: true,
            floating: true,
            leading: InkWell(
              onTap: () {
                if (isParentNeedsRefresh) {
                  arguments.onFavoriteStatusChanged();
                }
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
            flexibleSpace: Container(
              color: mainPokemonType.getBackgroundColor(),
              child: Stack(
                children: [
                  Positioned(
                      bottom: -8,
                      right: -40,
                      child: SizedBox(
                        width: 175,
                        height: 175,
                        child: SvgPicture.asset(
                            "assets/icons/pokemon_outlined_icon.svg",
                            color: Colors.black12),
                      )),
                  Positioned(
                      right: 16,
                      bottom: 0,
                      child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.network(arguments.pokemon.imageURL))),
                  Positioned(
                      left: 16,
                      bottom: 14,
                      child: Text(
                          '#${arguments.pokemon.id.toString().threeDigitsFormatter}')),
                  Positioned(
                      left: 16,
                      top: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arguments.pokemon.name.capitalize,
                            style: const TextStyle(
                                color: darkPrimaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            typesString,
                            style: const TextStyle(
                                fontSize: 16, color: darkPrimaryColor),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 78,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: const Text(
                        "Height",
                        style:
                            TextStyle(fontSize: 12, color: greySubtitleColor),
                      ),
                      subtitle: Text(
                        arguments.pokemon.height.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: const Text(
                        "Weight",
                        style:
                            TextStyle(fontSize: 12, color: greySubtitleColor),
                      ),
                      subtitle: Text(
                        arguments.pokemon.weight.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: const Text(
                        "BMI",
                        style:
                            TextStyle(fontSize: 12, color: greySubtitleColor),
                      ),
                      subtitle: Text(
                        arguments.pokemon.getBMI().toStringAsFixed(1),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  const Expanded(flex: 3, child: SizedBox())
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.only(top: 12, left: 16),
                width: double.infinity,
                height: 46,
                child: const Text(
                  "Base stats",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
                margin: const EdgeInsets.only(top: 1),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: arguments.pokemon.stats.length + 1,
                      itemBuilder: ((context, index) {
                        if (index + 1 > arguments.pokemon.stats.length) {
                          return PokemonStatWidget(
                              pokemonstats: PokemonStatModel(
                                  name: "Avg. Power",
                                  value: arguments.pokemon
                                      .getAveragePower()
                                      .toInt()));
                        }
                        return PokemonStatWidget(
                            pokemonstats: arguments.pokemon.stats[index]
                                as PokemonStatModel);
                      })),
                )),
          )
        ],
      ),
    );
  }
}
