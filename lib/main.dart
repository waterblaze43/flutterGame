import "package:flutter/material.dart";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
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
      onPressed: () {},
      height: 150,
      minWidth: 150,
      color: Colors.white,
      shape: CircleBorder(),
      child: Text("Start"),
    );
  }
}

class GamePage extends StatelessWidget {
  GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
