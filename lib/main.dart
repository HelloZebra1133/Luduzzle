import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luduzzle/sudoku.dart';
import 'package:luduzzle/wordle.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: const Color(0xFFF2F2F2), // Light Gray background
              appBar: AppBar(
                backgroundColor: Colors.transparent, // Transparent app bar
                elevation: 0.0, // Remove shadow
                title: Row(
                  children: [
                    // Display your app logo here (replace with your logo widget)
                    Image.asset('assets/luduzzle.png', width: 40,), // Replace with your logo image path
                    const SizedBox(width: 10.0),
                    Text(
                      'Luduzzle',
                      style: GoogleFonts.museoModerno(textStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 40)),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Daily Challenge section
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0), // Very light gray background
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Daily Challenge',
                                style: GoogleFonts.bebasNeue(
                                  textStyle: TextStyle(color: Color(0xFF2ECC71), fontSize: 30),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to daily puzzle
                              },
                              child: Text(
                                'Play',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCFF4DE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Puzzle Category buttons
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      alignment: WrapAlignment.center,
                      children: [
                        Builder(
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sudoku(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset('assets/sudoku.svg', width: 20),
                                const SizedBox(width: 5.0),
                                Text(
                                  'Sudoku',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCFF4DE),
                            ),
                          ),
                        ),
                        // Add more buttons for other puzzle categories
                        ElevatedButton(
                          onPressed: () {
// Navigate to Mazes puzzles
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/tic-tac-toe.svg', width: 20),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Match 3',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
// Navigate to Mazes puzzles
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/text.svg', width: 20),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Anagrams',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
// Navigate to Mazes puzzles
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/sudoku.svg', width: 18),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Mazes',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
// Navigate to Mazes puzzles
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/sudoku.svg', width: 20),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Nonogram',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
// Navigate to Mazes puzzles
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/text.svg', width: 20),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Crossword',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WordleScreen()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Restrict button size
                            children: [
                              SvgPicture.asset('assets/text.svg', width: 20),
                              const SizedBox(width: 5.0), // Add spacing between icon and text
                              Text(
                                'Wordle',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),


                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCFF4DE), // Emerald green button
                          ),
                        ),
// Add more buttons for other puzzle categories
                      ],
                    ),

                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.transparent,
                elevation: 0.0,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(22.5),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/settings.svg', width: 40, ),
                        onPressed: () {
                          // Navigate to Settings
                        },
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/graph.svg', width: 40,),
                      onPressed: () {
                        // Navigate to Stats
                      },
                      color: Colors.black,
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/question.svg', width: 40,),
                      onPressed: () {
                        // Navigate to Help
                      },
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}






