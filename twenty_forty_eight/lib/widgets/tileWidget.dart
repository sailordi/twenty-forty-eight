import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/model/gameInfo.dart';
import 'package:twenty_forty_eight/model/tile.dart';

class TileWidget extends StatelessWidget {
  late double x;
  late double y;
  late double containerSize;
  late double size;
  late Color color;
  final Widget? child;

  TileWidget(Tile t,GameInfo i,bool animated,{super.key,this.child}) {
    if(animated == false) {
      x = i.tileSize * t.x;
      y = i.tileSize * t.y;
      size = i.tileSize - GameInfo.borderSize * 2;
    } else {
      x = i.tileSize * t.animatedX.value;
      y = i.tileSize * t.animatedY.value;
      size = (i.tileSize - GameInfo.borderSize * 2) * t.size.value;
    }

    containerSize = i.tileSize;
    color = t.tileColor();
  }

  @override
  Widget build(BuildContext context) => Positioned(
      left: x,
      top: y,
      child: Container(
          width: containerSize,
          height: containerSize,
          child: Center(
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(GameInfo.cornerRadius), color: color),
                  child: child
              )
          )
      )
  );
}

class TileNumber extends StatelessWidget {
  final int val;

  const TileNumber(this.val, {super.key});

  @override
  Widget build(BuildContext context) => Text("$val",
      style: TextStyle(color: Tile.textColor(val),fontSize: val > 512 ? 28 : 35, fontWeight: FontWeight.w900));
}
