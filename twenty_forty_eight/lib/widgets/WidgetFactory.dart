import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/model/tile.dart';

class WidgetFactory {

  static dynamic logo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '2048',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 52.0),
          )
        ],
      ),
    );
  }

  static dynamic scoreBord(int s,int bS) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _score('Score', s.toString() ),
        const SizedBox(
          width: 8.0,
        ),
        _score(
            'Best',
            bS.toString(),
            pad: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) ),
      ],
    );
  }

  static dynamic instructions() {
    return Row(
      children: [
        const SizedBox(width: 10,height: 30),
        const Text("Join the numbers and get to the "),
        Text("${Tile.maxValue()} tile",style: const TextStyle(fontWeight: FontWeight.bold) ),
      ]
    );
  }

  static dynamic newGame(void Function() f) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255,143, 122, 102),
          foregroundColor: Colors.white,
          ),
          onPressed: f,
          child: const Text("New")
        ),
        const SizedBox(width: 10)
      ]
    );
  }

  static dynamic emptyBoard(double width,double height) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255,187,173,160),
          borderRadius: BorderRadius.circular(6.0),
          shape: BoxShape.rectangle,
        ),
    );

  }

  static dynamic _score(String label,String score,{EdgeInsets? pad}) {
    return Container(
      padding: (pad != null) ? pad! :
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255,187, 173, 160), borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]),
    );
  }

}