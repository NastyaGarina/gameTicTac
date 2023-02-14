import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'color.dart';
import 'game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // проверить жеребьевку
  int oScore = 0; // количество побед "O"
  int xScore = 0; // количество побед "Х"
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; // счет для различных комбинаций игры

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    if (kDebugMode) {
      print(game.board);
    }
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              gameOver ? "" : "ХОД $lastValue",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 58,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Игрок Х',
                        style: txtStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        xScore.toString(),
                        style: txtStyle,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Игрок О',
                        style: txtStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        oScore.toString(),
                        style: txtStyle,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardlenth ~/ 3,
                padding: const EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardlenth, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);

                                if (gameOver) {
                                  result = "$lastValue победил!";
                                  // подсчет побед
                                  if (lastValue == "O") {
                                    setState(() {
                                      oScore++;
                                    });
                                  } else if (lastValue == "X") {
                                    setState(() {
                                      xScore++;
                                    });
                                  }
                                } else if (!gameOver && turn == 9) {
                                  result = "Ничья!";
                                  gameOver = true;
                                }
                                if (lastValue == "X") {
                                  lastValue = "O";
                                } else {
                                  lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              result,
              style: const TextStyle(color: Colors.white, fontSize: 54.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      // стереть доску
                      game.board = Game.initGameBoard();
                      lastValue = "X";
                      gameOver = false;
                      turn = 0;
                      result = "";
                      scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                    });
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text("Начать заново"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      // сброс
                      game.board = Game.initGameBoard();
                      lastValue = "X";
                      gameOver = false;
                      turn = 0;
                      result = "";
                      scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                      oScore = 0;
                      xScore = 0;
                    });
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text("Сброс"),
                ),
              ],
            ),
          ],
        ));
  }
}
