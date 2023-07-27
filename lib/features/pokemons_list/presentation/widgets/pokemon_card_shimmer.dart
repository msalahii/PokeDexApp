import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCardShimmer extends StatelessWidget {
  final Color backgroundColor;
  const PokemonCardShimmer({Key? key, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(20),
            child: Shimmer.fromColors(
                baseColor: Colors.white54,
                highlightColor: backgroundColor.withAlpha(20),
                child:
                    SvgPicture.asset('assets/icons/pokemon_outlined_icon.svg')),
          )),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: 40,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                SizedBox(
                    width: double.infinity,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade300,
                  child: Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
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
