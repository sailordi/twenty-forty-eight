import 'dart:math';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import 'GameInfo.dart';
import 'Tile.dart';

class Grid {
  // We will use this list to retrieve the right index when user swipes up/down
  final verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];
  List<Tile> tiles = [];

  Grid() {
    for(int i = 0; i < GameInfo.scale*GameInfo.scale; i++) {
      tiles.add(Tile(index: i));
    }

  }

  void randomTile() {
    int i = 0;
    int t = 0;
    final generator = Random();

    do {
      i = generator.nextInt(GameInfo.scale*GameInfo.scale);
    } while (t != GameInfo.scale*GameInfo.scale && tiles[i].value != 0);

    int value = generator.nextDouble() < 0.1 ? 4 : 2;

    tiles[i].value = value;
  }

  Tile _calculate(Tile t,List<Tile> tiles,SwipeDirection direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;

    // Get the first index from the left in the row
    // If it's ascending: 2 * 4 – 4 = 4, which is the first index from the left side in the second row
    // If it's descending: 2 * 4 – 1 = 7, which is the last index from the left side and first index from the right side in the second row
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
    int index = vert ? verticalOrder[t.index] : t.index;
    int nextIndex = ((index + 1)/GameInfo.scale).ceil()*GameInfo.scale-(asc?GameInfo.scale:1);

    if(tiles.isNotEmpty) {
      Tile l = tiles.last;
      // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
      var lastIndex = l.nextIndex ?? l.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;

      if(_validIndex(index,nextIndex) ) {
        // If the order is ascending set the tile after the last processed tile
        // If the order is descending set the tile before the last processed tile
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }

    return t.copyWith(nextIndex: nextIndex);
  }

  bool _validIndex(int index,int nextIndex) {
    int scale = GameInfo.scale;
    int scale2 = scale+scale;
    int scale3 = scale2+scale;

    return index < scale && nextIndex < scale ||
      index >= scale && index < scale2 && nextIndex >= scale && nextIndex < scale2 ||
      index >= scale2 && index < scale3 && nextIndex >= scale2 && nextIndex < scale3 ||
      index >= scale3 && nextIndex >= scale3;
  }

  void move(SwipeDirection direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;

    // Sort the list of tiles by index.
    tiles.sort(((a, b) =>
      (asc ? 1 : -1) *
        (vert ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index) ) ) );

    List<Tile> tmp = [];

    for(int i = 0, l = tiles.length; i < l; i++) {
      Tile t = tiles[i];

      t = _calculate(t,tiles,direction);

      tmp.add(t);

      if (i + 1 < l) {
        Tile n = tiles[i + 1];
        int index = vert ? verticalOrder[t.index] : t.index;
        int nextIndex = vert ? verticalOrder[n.index] : n.index;

        if(t.value == n.value){
          if (_validIndex(index,nextIndex)) {
            tmp.add(n.copyWith(nextIndex: t.nextIndex));
            // Skip next iteration if next tile was already assigned nextIndex.
            i += 1;
            continue;
          }

        }

      }

    }
    tiles = tmp;
  }

  void resetGrid() {
     tiles = [];

    for(int i = 0; i < GameInfo.scale*GameInfo.scale; i++) {
      tiles.add(Tile(index: i));
    }

  }

}