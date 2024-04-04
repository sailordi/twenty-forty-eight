import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twenty_forty_eight/widgets/tileWidget.dart';

import '../models/gameData.dart';
import '../models/gameInfo.dart';
import '../managers/boardManager.dart';
import '../models/tile.dart';

class EmptyBordWidget extends StatelessWidget {
  final GameInfo info;

  const EmptyBordWidget({super.key,required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: info.width,
      height: info.height,
      decoration: BoxDecoration(
          color: GameInfo.boardColor, borderRadius: BorderRadius.circular(6.0)),
      child: Stack(
        children: List.generate(16, (i) {
          //Render the empty board in 4x4 GridView
          var x = ((i + 1) / 4).ceil();
          var y = x - 1;

          var top = y * (info.tileSize) + (x * 12.0);
          var z = (i - (4 * y));
          var left = z * (info.tileSize) + ((z + 1) * 12.0);

          return Positioned(
            top: top,
            left: left,
            child: Container(
              width: info.tileSize,
              height: info.tileSize,
              decoration: BoxDecoration(
                  color: GameInfo.emptyTileColor,
                  borderRadius: BorderRadius.circular(6.0)),
            ),
          );
        }),
      ),
    );
  }

}

class TileBoardWidget extends ConsumerWidget {
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;
  final GameInfo info;

  const TileBoardWidget(
      {super.key, required this.moveAnimation, required this.scaleAnimation,required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(boardManager);
    List<Tile> grid = GameData.gridTiles(data.grid).where( (t) => t.value != 0).toList();

    return SizedBox(
      width: info.width,
      height: info.height,
      child: Stack(
        children: [
          ...List.generate(grid.length, (i) {
            var t= grid[i];

            return TileWidget(
              key: ValueKey(t.id),
              tile: t,
              moveAnimation: moveAnimation,
              scaleAnimation: scaleAnimation,
              info: info,
              //In order to optimize performances and prevent unneeded re-rendering the actual tile is passed as child to the AnimatedTile
              //as the tile won't change for the duration of the movement (apart from it's position)
              child: Container(
                width: info.tileSize,
                height: info.tileSize,
                decoration: BoxDecoration(
                    color: t.tileColor(),
                    borderRadius: BorderRadius.circular(6.0)),
                child: Center(
                    child: Text(
                      '${t.value}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: t.textColor() ),
                    )),
              ),
            );
          })
        ],
      ),
    );
  }

}