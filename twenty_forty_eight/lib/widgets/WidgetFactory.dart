import 'package:flutter/material.dart';

class WidgetFactory {

  static dynamic topWidget(int s,int bS) {
    return Stack(
      children: [
        _logo(),
        _scoreBord(s,bS)
      ],
    );
  }

  static dynamic _logo() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("2048",style: TextStyle(fontSize: 90,fontWeight: FontWeight.bold) ),
      ]
    );
  }

  static dynamic _scoreBord(int s,int bS) {
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
                    const Text("Score: ",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold) ),
                    Text('$s',style: const TextStyle(fontSize: 28) )
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
                  const Text("Best score: ",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold) ),
                  Text('$bS',style: const TextStyle(fontSize: 28) )
                ]
              )
            ),
          ],
        ),
    );
  }

}