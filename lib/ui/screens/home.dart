import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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



class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  StateModel appState;
  File _image;
  FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
//    _firebaseMessaging.getToken().then((token){
//      _updateToken(token);
//    });
  }
  
//  void _updateToken(token) {
//    print("TOKEN: " + token);
//    DatabaseReference ref = new FirebaseDatabase().reference();
//    ref.child('fcm-token/${token}').set({"token":token});
//
//  }

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