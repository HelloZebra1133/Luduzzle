import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class Sudoku extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();

}

class _SudokuState extends State<Sudoku> {
  // Original Sudoku board generated from the library
  late List<List<int>> algorithmOriginalBoard;
  List<List<List<int>>> boardHistory = [];
  late List<List<int>> originalBoard;

// Function to clear the selected cell (both pencil and non-pencil numbers)
  void clearSelectedCell() {
    if (selectedRow != -1 && selectedCol != -1 &&
        !filledByAlgorithm[selectedRow][selectedCol]) {
      setState(() {
        userBoard[selectedRow][selectedCol] = 0; // Clear the user input
        pencilMarks[selectedRow][selectedCol] =
            List.generate(9, (j) => 0); // Clear pencil marks
      });
      saveUserBoardToHistory(); // Save to history when a cell is cleared
    }
  }

  void resetBoard() {
    PanaraConfirmDialog.show(
      panaraDialogType: PanaraDialogType.custom,
      context,
      title: "Reset Board",
      message: "Are you sure you want to reset the entire board?",
      confirmButtonText: "Confirm",
      color: Color(0xFF2ECC71),
      buttonTextColor: Colors.white,
      cancelButtonText: "Cancel",
      noImage: true,
      barrierDismissible: false,
      onTapConfirm: () {
        setState(() {
          userBoard = List.generate(
            9,
                (i) =>
                List.generate(
                  9,
                      (
                      j) => algorithmOriginalBoard[i][j], // Reset userBoard to original numbers
                ),
          );
          // Clear all pencil marks
          pencilMarks = List.generate(
            9,
                (i) =>
                List.generate(
                  9,
                      (j) => List.generate(9, (k) => 0),
                ),
          );
          // Reset selected cell
          selectedRow = -1;
          selectedCol = -1;
          // Clear undo and redo history
          userBoardHistory.clear();
          undoneUserBoardHistory.clear();
          boardHistory.clear();
          // Save the reset user board state to history
          saveUserBoardToHistory();
          Navigator.pop(context);
        });
      },
      onTapCancel: () =>
          Navigator.pop(context), // Optional parameter (default is true)

    );
  }


  // User's input on the board (cells can be changed)
  List<List<int>> userBoard = List.generate(
    9,
        (i) =>
        List.generate(
          9,
              (j) => 0,
        ),
  );

  // Function to handle number button onPressed
  void handleNumberButtonPressed(int value) {
    //bool isValid = SudokuUtilities.isSolved(originalBoard);

    if (selectedRow != -1 && selectedCol != -1 &&
        !filledByAlgorithm[selectedRow][selectedCol]) {
      setState(() {
        // Update main board value and clear pencil marks
        originalBoard[selectedRow][selectedCol] = value;
        userBoard[selectedRow][selectedCol] = value; // Update userBoard
        pencilMarks[selectedRow][selectedCol] = List.generate(9, (j) => 0);
      });
      saveUserBoardToHistory(); // Save to history when a non-pencil number is entered


    }
  }

  // List to store the history of user actions and corresponding board states
  List<List<List<int>>> userBoardHistory = [];


  // List to store the history of undone user actions and corresponding board states
  List<List<List<int>>> undoneUserBoardHistory = [];

// Function to save the current user board state to history
  void saveUserBoardToHistory() {
    List<List<int>> copiedBoard = List.generate(
      9,
          (i) => List.generate(9, (j) => userBoard[i][j]),
    );
    userBoardHistory.add(copiedBoard);
    boardHistory.add(copiedBoard);
    // Clear undone history when a new action is performed
    undoneUserBoardHistory.clear();
  }

// Function to undo the last user action
  void undo() {
    if (boardHistory.length >
        1) { // Check if there are more than one state in history
      setState(() {
        undoneUserBoardHistory.add(
            boardHistory.last); // Save the current state to undone history
        boardHistory.removeLast(); // Remove the current state from history
        userBoard = List.generate(
          9,
              (i) =>
              List.generate(
                9,
                    (j) =>
                boardHistory
                    .last[i][j], // Restore the previous state to userBoard
              ),
        );
      });
    }
  }

// Function to redo the last undone user action
  void redo() {
    if (undoneUserBoardHistory.isNotEmpty) {
      setState(() {
        boardHistory.add(
            undoneUserBoardHistory.last); // Restore the undone state to history
        userBoard = List.generate(
          9,
              (i) =>
              List.generate(
                9,
                    (j) =>
                undoneUserBoardHistory
                    .last[i][j], // Restore the undone state to userBoard
              ),
        );
        undoneUserBoardHistory
            .removeLast(); // Remove the undone state from undone history
      });
    }
  }


  // Tracks whether the app is in pencil mode or regular mode
  bool isPencilMode = false;

  // Function to toggle between pencil mode and regular mode
  void toggleMode() {
    setState(() {
      isPencilMode = !isPencilMode;
    });
  }

  // Cells filled by the algorithm
  List<List<bool>> filledByAlgorithm = List.generate(
    9,
        (i) =>
        List.generate(
          9,
              (j) => false,
        ),
  );

  // Function to generate a new Sudoku puzzle
  void generateNewPuzzle() {
    var sudokuGenerator = SudokuGenerator(
        emptySquares: 48, uniqueSolution: true);
    algorithmOriginalBoard = sudokuGenerator.newSudoku;
    originalBoard = List.generate(
      9,
          (i) => List.generate(9, (j) => algorithmOriginalBoard[i][j]),
    );
    userBoard = List.generate(
      9,
          (i) => List.generate(9, (j) => originalBoard[i][j]),
    );
    filledByAlgorithm = List.generate(
      9,
          (i) => List.generate(9, (j) => algorithmOriginalBoard[i][j] != 0),
    );
    setState(() {
      selectedRow = -1;
      selectedCol = -1;
      pencilMarks = List.generate(
        9,
            (i) =>
            List.generate(
              9,
                  (j) => List.generate(9, (k) => 0),
            ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    generateNewPuzzle(); // Generate a new puzzle on app initialization
    // Save the initial user board state to history
    saveUserBoardToHistory();
  }


  // Tracks currently selected cell
  int selectedRow = -1;
  int selectedCol = -1;

  // Function to toggle pencil mark for the selected cell
  void togglePencilMark(int value) {
    if (selectedRow != -1 && selectedCol != -1) {
      setState(() {
        // Toggle pencil mark for the number in the selected cell
        pencilMarks[selectedRow][selectedCol][value - 1] =
        (pencilMarks[selectedRow][selectedCol][value - 1] == 0) ? value : 0;
      });
    }
  }

  // Tracks pencil marks for each cell (0 - empty, 1-9 - pencil marks)
  List<List<List<int>>> pencilMarks = List.generate(
    9,
        (i) =>
        List.generate(
          9,
              (j) => List.generate(9, (k) => 0),
        ),
  );

  // Flag to toggle highlighting wrong numbers
  bool showErrors = false;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          // Combine logo and text into a single Row
          title: Row(
            children: [
              InkWell(
                onTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                // Navigate back to home page
                child: Image.asset(
                    'assets/luduzzle.png', width: 40.0), // Display logo
              ),
              const SizedBox(width: 10.0), // Add spacing
              Text(
                'Sudoku',
                style: GoogleFonts.museoModerno(textStyle: TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 40)),
              ),
            ],
          ),

          actions: [
            IconButton(
              icon: SvgPicture.asset(
                showErrors
                    ? "assets/light.svg"
                    : "assets/light-off.svg", // Use ternary operator
              ),
              onPressed: () {
                setState(() {
                  showErrors = !showErrors;
                });
              },
            ),
          ],
          backgroundColor: Color(0xFFF2F2F2),
        ),


        body: Column(
          children: [
            // Grid representing the Sudoku board
            Expanded(

              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 9,

                children: List.generate(81, (index) {
                  int row = index ~/ 9;
                  int col = index % 9;


                  int value = originalBoard[row][col]; // Display original board values
                  bool isSelected = row == selectedRow && col == selectedCol;
                  // Check if the Sudoku puzzle is valid according to the game rules
                  if (isSudokuCompleted(userBoard)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showCongratulationsDialog();
                    });
                  }


                  bool isValid = isValidPlacement(
                      row, col, value, algorithmOriginalBoard);

                  print('Is valid Sudoku: $isValid');
                  void handleTap() {
                    if (originalBoard[row][col] == 0) {
                      // Check if the cell is empty in the original puzzle
                      setState(() {
                        selectedRow = row;
                        selectedCol = col;
                      });
                    } else if (!filledByAlgorithm[row][col]) {
                      // Check if the cell was filled by the user
                      setState(() {
                        selectedRow = row;
                        selectedCol = col;
                      });
                    }
                  }


                  // New container with thicker borders for grid lines
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Colors.black26,
                            width: (row == 0) ? 2 : 0),
                        // Top border is thicker for the first row of each subgrid
                        left: BorderSide(
                            color: Colors.black26,
                            width: (col == 0) ? 2 : 0),
                        // Left border is thicker for the first column of each subgrid
                        right: BorderSide(
                            color: Colors.black, width: (col % 3 == 2) ? 2 : 0),
                        // Right border is thicker every 3rd column
                        bottom: BorderSide(
                            color: Colors.black,
                            width: (row % 3 == 2)
                                ? 2
                                : 0), // Bottom border is thicker every 3rd row
                      ),
                      color: isSelected
                          ? Color(0xFFCFF4DE)
                          : Colors.transparent,
                    ),
                    child: GestureDetector(
                      onTap: handleTap, // Call the onTap handler function
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              // Display user input or an empty string based on userBoard
                              userBoard[row][col] != 0 ? userBoard[row][col]
                                  .toString() : '',
                              style: TextStyle(
                                fontWeight: filledByAlgorithm[row][col]
                                    ? FontWeight.bold
                                    : FontWeight.normal,

                                fontSize: 20.0,
                                color: showErrors ? (
                                    // Check for errors based on validity and source
                                    isValidPlacement(
                                        row, col, userBoard[row][col],
                                        algorithmOriginalBoard)
                                        ? Colors.black
                                        : Colors.red
                                ) : (
                                    // Default color based on filledByAlgorithm
                                    filledByAlgorithm[row][col] ? Color(
                                        0xff161716) : Colors.black
                                ),

                              ),
                            ),
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: List.generate(9, (pencilIndex) {
                              int pencilValue =
                              pencilMarks[row][col][pencilIndex]; // Access the pencil mark for the selected cell
                              return Center(
                                child: Text(
                                  pencilValue != 0
                                      ? pencilValue.toString()
                                      : '',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: pencilValue != 0
                                        ? Colors.grey
                                        : Colors.transparent,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Undo button
                Expanded(
                  flex: 2,
                  child: AspectRatio(aspectRatio: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        undo(); // Implement undo functionality
                      },
                      child: SvgPicture.asset('assets/undo.svg', height: 40,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                    ),
                  ),
                ),


                // Redo button
                Expanded(
                  flex: 2,
                  child: AspectRatio(aspectRatio: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        redo(); // Implement redo functionality
                      },
                      child: SvgPicture.asset('assets/redo.svg', height: 40,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                    ),
                  ),
                ),


                // Erase whole board button
                Expanded(
                  flex: 2,
                  child: AspectRatio(aspectRatio: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        resetBoard(); // Implement erase whole board functionality
                      },
                      child: SvgPicture.asset(
                        'assets/clear-all.svg', height: 45,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),

                // Clear selected cell button
                Expanded(
                  flex: 4,
                  child:
                  AspectRatio(aspectRatio: 2,

                    child: ElevatedButton(

                      onPressed: () {
                        clearSelectedCell(); // Implement clear selected cell functionality
                      },

                      child: SvgPicture.asset('assets/erase.svg', height: 45,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            AspectRatio(aspectRatio: 25,
              child: SizedBox(height: 20),
            ),


            // Row to display number buttons for input or pencil marks
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Render regular number buttons if not in pencil mode
                if (!isPencilMode)
                  for (var i = 1; i <= 5; i++)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          onPressed: () => handleNumberButtonPressed(i),
                          // Call handleNumberButtonPressed function
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(i.toString(),
                                style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,

                                ),
                              ),

                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCFF4DE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),
                // Render pencil buttons if in pencil mode
                if (isPencilMode)
                  for (var i = 1; i <= 5; i++)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          onPressed: () => togglePencilMark(i),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(i.toString(),
                                style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,

                                ),
                              ),
                              SvgPicture.asset('assets/pen.svg', width: 10,)
                              // Add the icon here
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCFF4DE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
            // Row to display remaining number buttons for input or pencil marks
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Render regular number buttons if not in pencil mode
                if (!isPencilMode)
                  for (var i = 6; i <= 9; i++)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedRow != -1 &&
                                selectedCol != -1 &&
                                !filledByAlgorithm[selectedRow][selectedCol]) {
                              setState(() {
                                // Update main board value and clear pencil marks
                                originalBoard[selectedRow][selectedCol] = i;
                                userBoard[selectedRow][selectedCol] =
                                    i; // Update userBoard
                                pencilMarks[selectedRow][selectedCol] =
                                    List.generate(9, (j) => 0);
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(i.toString(),
                                style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,

                                ),
                              ),
                              //SvgPicture.asset('assets/pen.svg',width: 10,) // Add the icon here
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCFF4DE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),


                // Render pencil buttons if in pencil mode
                if (isPencilMode)
                  for (var i = 6; i <= 9; i++)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ElevatedButton(
                          onPressed: () => togglePencilMark(i),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(i.toString(),
                                style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,

                                ),
                              ),
                              SvgPicture.asset('assets/pen.svg', width: 10,)
                              // Add the icon here
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCFF4DE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),
                // Button to toggle between pencil mode and regular mode
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ElevatedButton(
                      onPressed: toggleMode,
                      child: SvgPicture.asset(isPencilMode
                          ? "assets/pen.svg"
                          : "assets/not-pencil.svg"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),


          ],
        ),
        backgroundColor: Color(0xFFF2F2F2),
      ),


    );
  }

  bool isValidPlacement(int row, int col, int value, List<List<int>> board) {
    // Check row for conflicts
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == value && col != i) return false;
    }

    // Check column for conflicts
    for (int i = 0; i < 9; i++) {
      if (board[i][col] == value && row != i) return false;
    }

    // Check 3x3 subgrid for conflicts
    int subgridRowStart = (row ~/ 3) * 3;
    int subgridColStart = (col ~/ 3) * 3;
    for (int i = subgridRowStart; i < subgridRowStart + 3; i++) {
      for (int j = subgridColStart; j < subgridColStart + 3; j++) {
        if (board[i][j] == value && (i != row || j != col)) return false;
      }
    }

    // No conflicts found, placement is valid
    return true;
  }


  // Function to check if the Sudoku puzzle is valid
  bool isValidSudoku(int row, int col, int userBoard) {
    // Validate the Sudoku puzzle configuration
    return SudokuUtilities.isValidConfiguration(algorithmOriginalBoard);
  }

  // Function to check if the Sudoku puzzle is completed
  bool isSudokuCompleted(List<List<int>> userBoard) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (userBoard[row][col] == 0) {
          return false; // Empty cell found, Sudoku not completed
        } else
        if (!isValidPlacement(row, col, userBoard[row][col], userBoard)) {
          return false; // Invalid placement found
        }
      }
    }
    return true; // All cells filled and valid
  }
  void _showCongratulationsDialog() {
    PanaraConfirmDialog.show(
      panaraDialogType: PanaraDialogType.custom,
      context,
      title: "Puzzle Solved",
      message: "You have completed the Sudoku puzzle.",
      confirmButtonText: "Play Again",
      color: Color(0xFF2ECC71),
      buttonTextColor: Colors.white,
      cancelButtonText: "Main Menu",
      noImage: true,
      barrierDismissible: false,
      onTapConfirm: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Sudoku()),
        );
      },


      onTapCancel: () => Navigator.popUntil(context, (route) => route.isFirst),
    );
  }






}


