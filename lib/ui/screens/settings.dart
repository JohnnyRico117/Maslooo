import 'package:flutter/material.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/widgets/happy_image_tile.dart';
//import 'package:maslooo_app/ui/widgets/reward_tile.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //TODO: wenn Hier Sign out, dann wie Fkt: _buildContent in home.dart
//          SettingsButton(
//            Icons.exit_to_app,
//            "Log out",
//            appState.user.displayName,
//                () async {
//              await StateWidget.of(context).signOutOfGoogle();
//            },
//          ),
          ExpansionTile(
            title: Text("My Expressions"),
            children: <Widget>[

              HappyImageTile(appState.currentUser.veryHappy, "Very Happy", "veryhappy", "veryHappyImage"),
              HappyImageTile(appState.currentUser.happy, "Happy", "happy", "happyImage"),
              HappyImageTile(appState.currentUser.neutral, "Neutral", "neutral", "neutralImage"),
              HappyImageTile(appState.currentUser.sad, "Sad", "sad", "sadImage"),

            ],
          ),
//          ExpansionTile(
//            title: Text("My Reward System"),
//            children: <Widget>[
//              RewardTile(),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//
//                  FloatingActionButton(
//                    onPressed: null,
//                    child: Icon(Icons.add),
//                  )
//                ],
//              )
//
//            ],
//          ),



        ],
      ),
    );
  }
}