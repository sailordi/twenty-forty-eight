import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';
import 'package:twenty_forty_eight/models/tile.dart';

class TileWidget extends AnimatedWidget {
  final Tile tile;
  final Widget child;
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;
  final GameInfo info;

  //We use Listenable.merge in order to update the animated widget when both of the controllers have change
  TileWidget(
      {super.key,
        required this.moveAnimation,
        required this.scaleAnimation,
        required this.tile,
        required this.info,
        required this.child})
      : super(listenable: Listenable.merge([moveAnimation, scaleAnimation]));

  //Get the current top position based on current index of the tile
  late final double _top = tile.top(info.tileSize);
  //Get the current left position based on current index of the tile
  late final double _left = tile.left(info.tileSize);
  //Get the next top position based on current next index of the tile
  late final double _nextTop = tile.nextTop(info.tileSize) ?? _top;
  //Get the next top position based on next index of the tile
  late final double _nextLeft = tile.nextLeft(info.tileSize) ?? _left;

  //top tween used to move the tile from top to bottom
  late final Animation<double> top = Tween<double>(
    begin: _top,
    end: _nextTop,
  ).animate(
    moveAnimation,
  ),
  //left tween used to move the tile from left to right
      left = Tween<double>(
        begin: _left,
        end: _nextLeft,
      ).animate(
        moveAnimation,
      ),
  //scale tween used to use give "pop" effect when a merge happens
      scale = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.0, end: 1.5)
                .chain(CurveTween(curve: Curves.easeOut)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeIn)),
            weight: 50.0,
          ),
        ],
      ).animate(
        scaleAnimation,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top.value,
        left: left.value,
        //Only use scale animation if the tile was merged
        child: tile.merged
            ? ScaleTransition(
          scale: scale,
          child: child,
        )
            : child);
  }
}