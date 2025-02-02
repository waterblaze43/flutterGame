import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(child: MainPage()),
  ));
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          color: Colors.blueAccent,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          child: Center(child: button(context)),
        ),
        Container(
          color: Colors.redAccent,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          child: Center(child: button(context)),
        )
      ],
    ));
  }

  Widget button(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GamePage()));
      },
      height: 150,
      minWidth: 150,
      color: Colors.white,
      shape: CircleBorder(),
      child: Text("START"),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double heightA = 0;
  double heightB = 0;
  int scoreA = 0;
  int scoreB = 0;
  bool initialized = false;

  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('start.wav'));
      await player.resume();
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      heightA = MediaQuery.of(context).size.height / 2;
      heightB = MediaQuery.of(context).size.height / 2;
      scoreA = 5;
      scoreB = 5;
      initialized = true;
    }

    return Scaffold(
      body: Column(
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() {
                if (heightB + 50 < MediaQuery.of(context).size.height - 80) {
                  heightB += 50;
                  heightA -= 50;
                  scoreB += 5;
                  scoreA -= 5;
                } else {
                  heightB = MediaQuery.of(context).size.height;
                  heightA = 0;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ResultPage(
                          winner: "B", winnerColor: Colors.blueAccent)));
                }
              });
            },
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              height: heightB,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Player B",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      scoreB.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() {
                if (heightA + 50 < MediaQuery.of(context).size.height - 80) {
                  heightA += 50;
                  heightB -= 50;
                  scoreA += 5;
                  scoreB -= 5;
                } else {
                  heightA = MediaQuery.of(context).size.height;
                  heightB = 0;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ResultPage(
                          winner: "A", winnerColor: Colors.redAccent)));
                }
              });
            },
            child: Container(
              color: Colors.redAccent,
              width: double.infinity,
              height: heightA,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Player A",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      scoreA.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  String winner = "";
  Color winnerColor = Colors.white;

  ResultPage({super.key, required this.winner, required this.winnerColor});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Color loserColor = Colors.white;

  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('victory.mp3'));
      await player.resume();
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loserColor = widget.winnerColor == Colors.redAccent
        ? Colors.blueAccent
        : Colors.redAccent;
    return Scaffold(
      body: Container(
        color: widget.winnerColor,
        child: Center(
          child: Column(
            spacing: 40,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Player ${widget.winner} has Won the Game",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              MaterialButton(
                height: 45,
                minWidth: 120,
                onPressed: () {
                  Navigator.pop(context);
                  HapticFeedback.vibrate();
                },
                color: loserColor,
                child: Text(
                  "Play Again",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
