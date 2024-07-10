import 'package:flutter/material.dart';
import 'dart:math';
import 'word_list.dart'; // Import the word list

void main() {
  runApp(WordleApp());
}

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordleScreen extends StatefulWidget {
  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  late String targetWord;
  List<List<String>> guesses = [
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
  ];
  String currentGuess = '';
  int currentRow = 0;

  @override
  void initState() {
    super.initState();
    // Pick a random word from the answer list
    targetWord = answerList[Random().nextInt(answerList.length)];
    print('Target Word: $targetWord'); // Debug: Show the target word
  }

  void handleLetterTap(String letter) {
    setState(() {
      if (letter == 'Enter') {
        if (currentGuess.length == 5 && guessList.contains(currentGuess)) {
          guesses[currentRow] = currentGuess.split('');
          if (currentGuess == targetWord) {
            // Handle win scenario
            print('Congratulations! You guessed the word.');
          } else if (currentRow == 5) {
            // Handle game over scenario
            print('Game Over! The word was $targetWord.');
          } else {
            currentRow++;
            currentGuess = '';
          }
        } else {
          // Invalid guess
          print('Invalid word!');
        }
      } else if (letter == 'Backspace') {
        if (currentGuess.isNotEmpty) {
          currentGuess = currentGuess.substring(0, currentGuess.length - 1);
        }
      } else {
        if (currentGuess.length < 5) {
          currentGuess += letter.toLowerCase(); // Ensure lowercase for validation
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Wordle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: WordBoard(guesses: guesses, currentGuess: currentGuess, currentRow: currentRow),
          ),
          Expanded(
            child: Keyboard(onLetterTap: handleLetterTap),
          ),
        ],
      ),
    );
  }
}

class WordBoard extends StatelessWidget {
  final List<List<String>> guesses;
  final String currentGuess;
  final int currentRow;

  const WordBoard({required this.guesses, required this.currentGuess, required this.currentRow});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 30,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        int rowIndex = index ~/ 5;
        int colIndex = index % 5;
        String letter = '';
        if (rowIndex < currentRow) {
          letter = guesses[rowIndex][colIndex];
        } else if (rowIndex == currentRow && colIndex < currentGuess.length) {
          letter = currentGuess[colIndex];
        }
        return LetterTile(letter: letter);
      },
    );
  }
}

class LetterTile extends StatelessWidget {
  final String letter;

  const LetterTile({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final Function(String) onLetterTap;

  const Keyboard({required this.onLetterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          SizedBox(height: 8),
          buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
          SizedBox(height: 8),
          buildKeyboardRow(['Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Backspace']),
        ],
      ),
    );
  }

  Widget buildKeyboardRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: letters.map((letter) {
        return Expanded(
          flex: (letter == 'Enter' || letter == 'Backspace') ? 2 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: KeyboardButton(
              letter: letter,
              onTap: () => onLetterTap(letter),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  final String letter;
  final VoidCallback onTap;

  const KeyboardButton({required this.letter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
