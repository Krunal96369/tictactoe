import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/custom_dialog.dart';
import 'package:tictactoe/game_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var player1;
  var player2;
  var activePlayer;

  List<GameButton> buttonList;
  @override
  void initState() {
    buttonList = doInit();
    super.initState();
  }

  void playGame(GameButton button) {
    setState(() {
      if (activePlayer == 1) {
        button.text = "X";
        button.bg = Color(0xffF56F6C);
        player1.add(button.Id);
        activePlayer = 2;
      } else {
        button.text = "O";
        button.bg = Color(0xff6fcdda);
        player2.add(button.Id);
        activePlayer = 1;
      }
      button.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game Tied",
                  "Press the reset button to start again.", resetGame));
        } else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonList.indexWhere((p) => p.Id == cellID);
    playGame(buttonList[i]);
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
          barrierDismissible: false,
            context: context,
            builder: (_) => CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonList = doInit();
    });
  }

  List<GameButton> doInit() {
    player1 = List();
    player2 = List();
    activePlayer = 1;

    var gameButton = <GameButton>[
      GameButton(Id: 1),
      GameButton(Id: 2),
      GameButton(Id: 3),
      GameButton(Id: 4),
      GameButton(Id: 5),
      GameButton(Id: 6),
      GameButton(Id: 7),
      GameButton(Id: 8),
      GameButton(Id: 9),
    ];
    return gameButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: kIsWeb
              ? [
                  Container(
                    height: 700,
                    width: 200,
                    margin: EdgeInsets.fromLTRB(500, 0, 500, 0),
                    child: Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 9.0,
                            mainAxisSpacing: 9.0),
                        itemCount: buttonList.length,
                        itemBuilder: (context, i) => SizedBox(
                          height: 100,
                          width: 100,
                          child: RaisedButton(
                            onPressed: buttonList[i].enabled
                                ? () => playGame(buttonList[i])
                                : null,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              buttonList[i].text,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: buttonList[i].bg,
                            disabledColor: buttonList[i].bg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: resetGame,
                    color: Color(0xffF56F6C),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ]
              : [
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0),
                      itemCount: buttonList.length,
                      itemBuilder: (context, i) => SizedBox(
                        height: 100,
                        width: 100,
                        child: RaisedButton(
                          onPressed: buttonList[i].enabled
                              ? () => playGame(buttonList[i])
                              : null,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            buttonList[i].text,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: buttonList[i].bg,
                          disabledColor: buttonList[i].bg,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: resetGame,
                    color: Color(0xffF56F6C),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
        ));
  }
}
