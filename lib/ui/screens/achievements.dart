import 'package:flutter/material.dart';


class Achievements extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new AchievementsState();
}

class AchievementsState extends State<Achievements> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Achievements")
      ),
      body: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.star, color: Colors.yellow)
            ],
          )
        ],
      )
    );
  }



}