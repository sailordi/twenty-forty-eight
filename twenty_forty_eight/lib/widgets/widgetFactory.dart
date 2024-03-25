import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/model/gameInfo.dart';
import 'package:twenty_forty_eight/model/tile.dart';

class WidgetFactory {
  static dynamic logo() {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Text("2048",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold) ),
        ]
    );
  }

  static dynamic scoreBord(int s,int bS) {
    const double fontSize = 20;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255,187, 173, 160)
            ),
            child: Column(
                children: [
                  const Text("Score: ",style: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold) ),
                  Text('$s',style: const TextStyle(fontSize: fontSize) )
                ]
            ),
          ),
          const SizedBox(width: 10),
          Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255,187, 173, 160)
              ),
              child: Column(
                  children: [
                    const Text("Best score: ",style: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold) ),
                    Text('$bS',style: const TextStyle(fontSize: fontSize) )
                  ]
              )
          ),
        ],
      ),
    );
  }

  static dynamic instructions() {
    const double fontSize = 11;

    return Row(
        children: [
          const SizedBox(width: 10,height: 30),
          const Text("Join the numbers and get to the ",style: TextStyle(fontSize: fontSize) ),
          Text("${Tile.maxValue()} tile",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: fontSize) ),
        ]
    );

  }

  static dynamic newGame(void Function() f) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GameInfo.orange, //const Color.fromARGB(255,143, 122, 102),
                foregroundColor: Colors.white,
              ),
              onPressed: f,
              child: const Text("New game")
          ),
          const SizedBox(width: 10)
        ]
    );
  }

  static dynamic emptyBoard(double width,double height) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: GameInfo.darkBrown,
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }

}