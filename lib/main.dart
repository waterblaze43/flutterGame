import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GamePage(),
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
              HapticFeedback.mediumImpact();
              setState(() {
                if (heightB + 50 < MediaQuery.of(context).size.height) {
                  heightB += 50;
                  heightA -= 50;
                  scoreB += 5;
                  scoreA -= 5;
                } else {
                  heightB = MediaQuery.of(context).size.height;
                  heightA = 0;
                  print("B won");
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
                if (heightA + 50 < MediaQuery.of(context).size.height) {
                  heightA += 50;
                  heightB -= 50;
                  scoreA += 5;
                  scoreB -= 5;
                } else {
                  heightA = MediaQuery.of(context).size.height;
                  heightB = 0;
                  print("A won");
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
