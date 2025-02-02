import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  String playerA = "A";
  String playerB = "B";

  TextEditingController textControllerA = TextEditingController();
  TextEditingController textControllerB = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(child: button(context)),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Colors.blueAccent,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
          ),
        ),
        Container(
          color: Colors.redAccent,
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
        ),
        Center(child: button(context)),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: nameEntry(context, "A", textControllerA, Colors.redAccent),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: nameEntry(context, "B", textControllerB, Colors.blueAccent),
          ),
        ),
      ],
    ));
  }

  Widget nameEntry(BuildContext context, String player,
      TextEditingController textController, Color bColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      decoration:
          BoxDecoration(color: bColor, borderRadius: BorderRadius.circular(7)),
      padding: EdgeInsets.all(0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          fillColor: Colors.redAccent,
          hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
          //contentPadding: EdgeInsets.all(20),
          hintText: "Enter player $player name: ",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (textControllerA.text != "" && textControllerB.text != "") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GamePage(
                      playerA: textControllerA.text,
                      playerB: textControllerB.text)));
        }
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
  String playerA = "";
  String playerB = "";

  GamePage({super.key, required this.playerA, required this.playerB});

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
                          winner: widget.playerA,
                          winnerColor: Colors.blueAccent)));
                }
              });
            },
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              height: heightB,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.playerA,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        scoreB.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
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
                          winner: widget.playerB,
                          winnerColor: Colors.redAccent)));
                }
              });
            },
            child: Container(
              color: Colors.redAccent,
              width: double.infinity,
              height: heightA,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.playerB,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        scoreA.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
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
                "${widget.winner} has Won the Game",
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
