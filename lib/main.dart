import 'package:flutter/material.dart';
import 'dart:math';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048',
      theme:ThemeData(primarySwatch: Colors.orange),
      home: const GamePage(),
    );
  }
}
class GamePage extends StatefulWidget{
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}
class _GamePageState extends State<GamePage> {
  static const int gridSize = 4;
  List<List<int>> grid =
  List.generate(gridSize, (_) => List.filled(gridSize, 0));

  List<int> mergeRow(List<int> row) {
    // 0’ları at
    List<int> newRow = row.where((v) => v != 0).toList();

    // birleştir
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        newRow[i + 1] = 0;
      }
    }

    // tekrar 0’ları at
    newRow = newRow.where((v) => v != 0).toList();

    // sona 0 ekle
    while (newRow.length < gridSize) {
      newRow.add(0);
    }

    return newRow;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      appBar: AppBar(
        title: const Text('2048'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity == null) return;

            if (details.primaryVelocity! < 0) {
              moveUp();
            } else if (details.primaryVelocity! > 0) {
              moveDown();
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;

            if (details.primaryVelocity! < 0) {
              moveLeft();
            } else if (details.primaryVelocity! > 0) {
              moveRight();
            }
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFBBADA0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  int row = index ~/ gridSize;
                  int col = index % gridSize;
                  int value = grid[row][col];

                  return Container(
                    decoration: BoxDecoration(
                      color: value == 0
                          ? const Color(0xFFCDC1B4)
                          : Colors.orange[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: value == 0
                          ? const SizedBox()
                          : Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for(int i=0;i<gridSize;i++){
      addRandomTile();
    }
  }

  void addRandomTile() {
    List<Point<int>> emptyCells = [];

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (grid[r][c] == 0) {
          emptyCells.add(Point(r, c));
        }
      }
    }

    if (emptyCells.isEmpty) return;

    final randomCell = emptyCells[Random().nextInt(emptyCells.length)];
    grid[randomCell.x][randomCell.y] = Random().nextInt(10)==0?4:2;
  }
  void moveLeft() {
    setState(() {
      bool moved = false;

      for (int r = 0; r < gridSize; r++) {
        List<int> newRow = mergeRow(grid[r]);
        if (grid[r].toString() != newRow.toString()) {
          grid[r] = newRow;
          moved = true;
        }
      }

      if (moved) addRandomTile();
      print("LEFT");
    });
  }


  void moveRight() {
    setState(() {
      bool moved = false;

      for (int r = 0; r < gridSize; r++) {
        List<int> reversed = grid[r].reversed.toList();
        List<int> newRow = mergeRow(reversed).reversed.toList();

        if (grid[r].toString() != newRow.toString()) {
          grid[r] = newRow;
          moved = true;
        }
      }

      if (moved) addRandomTile();
      print("RIGHT");
    });
  }


  void moveUp() {
    setState(() {
      bool moved = false;

      for (int c = 0; c < gridSize; c++) {
        List<int> column = [];
        for (int r = 0; r < gridSize; r++) {
          column.add(grid[r][c]);
        }

        List<int> newColumn = mergeRow(column);

        for (int r = 0; r < gridSize; r++) {
          if (grid[r][c] != newColumn[r]) {
            grid[r][c] = newColumn[r];
            moved = true;
          }
        }
      }

      if (moved) addRandomTile();
      print("UP");
    });
  }


  void moveDown() {
    setState(() {
      bool moved = false;

      for (int c = 0; c < gridSize; c++) {
        List<int> column = [];
        for (int r = 0; r < gridSize; r++) {
          column.add(grid[r][c]);
        }

        List<int> newColumn =
        mergeRow(column.reversed.toList()).reversed.toList();

        for (int r = 0; r < gridSize; r++) {
          if (grid[r][c] != newColumn[r]) {
            grid[r][c] = newColumn[r];
            moved = true;
          }
        }
      }

      if (moved) addRandomTile();
      print("DOWN");
    });
  }

}
