import 'dart:io';

List<String> board = List.filled(9, ' ');

void main() {
  print('🎮 Welcome to Tic-Tac-Toe in Dart!');

  bool playAgain = true;
  while (playAgain) {
    resetBoard();

    stdout.write('Do you want to play against the computer? (y/n): ');
    String? modeInput = stdin.readLineSync();
    bool vsAI = (modeInput?.toLowerCase() == 'y');

    String humanSymbol = choosePlayerSymbol();
    String aiSymbol = (humanSymbol == 'X') ? 'O' : 'X';

    String currentPlayer = 'X';

    while (true) {
      displayBoard();

      int move;
      if (vsAI && currentPlayer == aiSymbol) {
        print('🤖 AI ($aiSymbol) is thinking...');
        move = getAIMove();
        sleep(Duration(seconds: 1));
        print('AI chooses position $move');
      } else {
        move = getPlayerMove(currentPlayer);
      }

      board[move - 1] = currentPlayer;

      if (checkWinner(currentPlayer)) {
        displayBoard();
        if (vsAI && currentPlayer == aiSymbol) {
          print('🤖 AI ($aiSymbol) wins! Better luck next time.');
        } else {
          print('🎉 Player $currentPlayer wins!');
        }
        break;
      } else if (isDraw()) {
        displayBoard();
        print('🤝 It\'s a draw!');
        break;
      }

      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }

    stdout.write('\nDo you want to play again? (y/n): ');
    String? answer = stdin.readLineSync();
    playAgain = (answer?.toLowerCase() == 'y');
  }

  print('Thanks for playing!');
}

String choosePlayerSymbol() {
  while (true) {
    stdout.write('Choose your symbol (X/O): ');
    String? input = stdin.readLineSync();
    if (input != null &&
        (input.toUpperCase() == 'X' || input.toUpperCase() == 'O')) {
      return input.toUpperCase();
    } else {
      print('❌ Invalid choice. Please enter X or O.');
    }
  }
}

void displayBoard() {
  print('\n');
  for (int i = 0; i < 9; i += 3) {
    print(' ${board[i]} | ${board[i + 1]} | ${board[i + 2]} ');
    if (i < 6) print('-----------');
  }
  print('\n');
}

int getPlayerMove(String player) {
  while (true) {
    stdout.write('Player $player, enter your move (1-9): ');
    String? input = stdin.readLineSync();

    if (input == null || int.tryParse(input) == null) {
      print('❌ Invalid input. Please enter a number between 1 and 9.');
      continue;
    }

    int move = int.parse(input);
    if (move < 1 || move > 9) {
      print('❌ Move out of range. Try again.');
    } else if (board[move - 1] != ' ') {
      print('❌ Cell already taken. Choose another.');
    } else {
      return move;
    }
  }
}

int getAIMove() {
  for (int i = 0; i < 9; i++) {
    if (board[i] == ' ') return i + 1;
  }
  return 1;
}

bool checkWinner(String player) {
  List<List<int>> winConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var condition in winConditions) {
    if (board[condition[0]] == player &&
        board[condition[1]] == player &&
        board[condition[2]] == player) {
      return true;
    }
  }
  return false;
}

bool isDraw() {
  return !board.contains(' ');
}

void resetBoard() {
  for (int i = 0; i < board.length; i++) {
    board[i] = ' ';
  }
}
