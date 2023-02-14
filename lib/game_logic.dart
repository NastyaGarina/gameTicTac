class Player {
  static const x = "X";
  static const o = "O";
  static const empty = "";
}

class Game {
  static const boardlenth = 9; // создание блоков 3*3;
  static const blocSize = 100.0;

  // Создание пустой доски
  List<String>? board;

  static List<String>? initGameBoard() =>
      List.generate(boardlenth, (index) => Player.empty);

  // алгоритм проверки победителя
  bool winnerCheck(
      String player, int index, List<int> scoreboard, int gridSize) {
    // объявление строки и столбеца
    int row = index ~/ 3;
    int col = index % 3;
    int score = player == "X" ? 1 : -1;

    scoreboard[row] += score;
    scoreboard[gridSize + col] += score;
    if (row == col) scoreboard[2 * gridSize] += score;
    if (gridSize - 1 - col == row) scoreboard[2 * gridSize + 1] += score;

    // проверяем, есть ли у нас 3 или -3 на табло
    if (scoreboard.contains(3) || scoreboard.contains(-3)) {
      return true;
    }

    // по умолчанию он вернет false
    return false;
  }
}
