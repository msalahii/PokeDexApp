import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/data/models/pokemon_types_model.dart';
import 'package:pokedex_app/utils/styles.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/data/models/pokemon_model.dart';
import 'package:pokedex_app/utils/extensions.dart';

class PokemonCard extends StatelessWidget {
  final PokemonModel pokemon;
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typesNamesList = pokemon.types.map((type) => type.name).toList();
    String typesString = '';
    for (var element in typesNamesList) {
      if (typesString.isEmpty) {
        typesString = element.capitalize;
      } else {
        typesString = "$typesString, ${element.capitalize}";
      }
    }
    final mainType = pokemon.types[0] as PokemonTypeModel;
    return Container(
      decoration: BoxDecoration(
          color: mainType.getBackgroundColor(),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8),
            child: /* Image.network(
              pokemon.imageURL,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return SvgPicture.asset(
                  'assets/icons/pokemon_outlined_icon.svg',
                  color: Colors.black12,
                );
              },
            ) */

            CachedNetworkImage(
              imageUrl: pokemon.imageURL,
              placeholder: (context, url) => Container(
                padding: const EdgeInsets.all(20),
                child: Shimmer.fromColors(
                    baseColor: Colors.white54,
                    highlightColor: mainType.getBackgroundColor().withAlpha(20),
                    child: SvgPicture.asset(
                        'assets/icons/pokemon_outlined_icon.svg')),
              ),
              errorWidget: (context, url, error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/pokemon_outlined_icon.svg',
                  color: Colors.black12,
                ),
              ),
            )
            ,
          )),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "#${pokemon.id.toString().threeDigitsFormatter}",
                    style: const TextStyle(
                        fontSize: 12,
                        color: greySubtitleColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: Text(
                      pokemon.name.capitalize,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    )),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    typesString,
                    style: const TextStyle(
                        fontSize: 12,
                        color: greySubtitleColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
