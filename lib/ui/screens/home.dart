import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/screens/login.dart';
import 'package:maslooo_app/ui/screens/profile.dart';
import 'package:maslooo_app/ui/screens/friend_list.dart';

import 'package:maslooo_app/ui/widgets/settings_button.dart';
import 'package:maslooo_app/ui/widgets/loading_indicator.dart';

import 'package:maslooo_app/ui/screens/profile_setup.dart';
//import 'package:maslooo_app/ui/screens/addfriend.dart';

//import 'package:contacts_service/contacts_service.dart';

//import 'package:flutter_sms/flutter_sms.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  StateModel appState;
  File _image;
  FirebaseStorage _storage = FirebaseStorage.instance;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: LoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
//    } else if (appState.newuser == true) {
//      return new ProfileSetUp();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.home, size: _iconSize)),
                Tab(icon: Icon(Icons.group, size: _iconSize)),
                Tab(icon: Icon(Icons.chat, size: _iconSize)),
                Tab(icon: Icon(Icons.lightbulb_outline, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

  TabBarView _buildTabsContent() {
    return TabBarView(
      children: [
        Profile(),
        FriendList(),
        Center(child: Icon(Icons.chat)),
        Center(child: Icon(Icons.lightbulb_outline)),
        _buildSettings()
      ],
    );
  }

  Column _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsButton(
          Icons.exit_to_app,
          "Log out",
          appState.user.displayName,
              () async {
            await StateWidget.of(context).signOutOfGoogle();
          },
        ),
      ],
    );
  }
}