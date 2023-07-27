import 'package:flutter/material.dart';
import 'package:pokedex_app/core/data/models/pokemon_stat_model.dart';
import 'package:pokedex_app/utils/extensions.dart';
import '../../../../utils/styles.dart';

class PokemonStatWidget extends StatelessWidget {
  final PokemonStatModel pokemonstats;
  const PokemonStatWidget({Key? key, required this.pokemonstats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color progressColor = darkPinkColor;
    if (pokemonstats.value >= 35 && pokemonstats.value < 70) {
      progressColor = yellowColor;
    } else if (pokemonstats.value >= 70) {
      progressColor = Colors.green.shade300;
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              pokemonstats.name.capitalize,
              style: const TextStyle(color: greySubtitleColor),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(pokemonstats.value.toString().capitalize)
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
            backgroundColor: greyBackgroundColor,
            color: progressColor,
            value: pokemonstats.value / 100),
        const SizedBox(height: 24),
      ],
    );
  }
}
