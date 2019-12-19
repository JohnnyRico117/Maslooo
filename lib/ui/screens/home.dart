import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
import 'package:maslooo_app/ui/widgets/happy_image_tile.dart';

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

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    //Home(),
    //Phases(),
    //ToDoList(),
    //FriendList(),
    Profile(),
    FriendList(),
    //Center(child: Icon(Icons.lightbulb_outline)),
    Center(child: Icon(Icons.lightbulb_outline)),
    Center(child: Icon(Icons.chat)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

    if (appState.user == null) {
      return new LoginScreen();
    }

    if (appState.isLoading) {
      return _buildTabView(
        body: LoadingIndicator(),
      );
//    } else if (!appState.isLoading && appState.user == null) {
//      return new LoginScreen();
////    } else if (appState.newuser == true) {
////      return new ProfileSetUp();
    } else {
      return _buildBottomTabs();
//      return _buildTabView(
//        body: _buildTabsContent(),
//      );
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
            elevation: 0.0,
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
        ExpansionTile(
          title: Text("My Expressions"),
          children: <Widget>[

            HappyImageTile(appState.currentUser.veryHappy, "Very Happy", "veryhappy", "veryHappyImage"),
            HappyImageTile(appState.currentUser.happy, "Happy", "happy", "happyImage"),
            HappyImageTile(appState.currentUser.neutral, "Neutral", "neutral", "neutralImage"),
            HappyImageTile(appState.currentUser.sad, "Sad", "sad", "sadImage"),

          ],
        ),
      ],
    );
  }

  Widget _buildBottomTabs() {
    return Scaffold(
//      appBar: AppBar(
//        elevation: 0.0,
//        backgroundColor: Colors.transparent,
////        leading: GestureDetector(
////            onTap: () => Navigator.pushNamed(context, '/profile'),
////            child: Container(
////              padding: EdgeInsets.all(8.0),
////              child: CircleAvatar(
////                backgroundImage: appState.user.photoUrl == null ? null : new NetworkImage(appState.user.photoUrl),
////              ),
////            )
////        ),
////        title: GestureDetector(
////          child: Text("Hello"),
////          onTap: () => Navigator.pushNamed(context, '/projects'),
////        ),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.settings,
//                color: Color(0xFFFFF176),
//              ),
//              onPressed: () => Navigator.pushNamed(context, '/settings')
//          )
//        ],
//      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return ui.Gradient.linear(
                  Offset(0.0, 12.0),
                  Offset(12.0, 24.0),
                  [
                    Colors.blueAccent[100],
                    Colors.greenAccent[100],
                  ],
                );
//                return RadialGradient(
//                  center: Alignment.topRight,
//                  //stops: [0.5, 0.5],
//                  radius: 2.0,
//                  colors: <Color>[
//                    Colors.greenAccent[200],
//                    Colors.blueAccent[200]
//                  ],
//                  tileMode: TileMode.repeated,
//                ).createShader(bounds);
              },
              child: Icon(Icons.home),
            ),
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.blueAccent[100]
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return ui.Gradient.linear(
                  Offset(0.0, 12.0),
                  Offset(12.0, 24.0),
                  [
                    Colors.blueAccent[100],
                    Colors.greenAccent[100],
                  ],
                );
              },
              child: Icon(Icons.group),
            ),
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.group,
              color: Colors.grey,
              //color: Color(0xFFFFF176),
            ),
            title: Text(
              'Friends',
              style: TextStyle(
                  color: Colors.blueAccent[100]
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return ui.Gradient.linear(
                  Offset(0.0, 12.0),
                  Offset(12.0, 24.0),
                  [
                    Colors.blueAccent[100],
                    Colors.greenAccent[100],
                  ],
                );
              },
              child: Icon(Icons.mood),
            ),
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.mood,
              color: Colors.grey,
              //color: Color(0xFFFFF176),
            ),
            title: Text(
              'Expressions',
              style: TextStyle(
                  color: Colors.blueAccent[100]
              ),
            ),
          ),
//          BottomNavigationBarItem(
//            backgroundColor: Color(0xFF0091EA),
//            icon: Icon(Icons.people),
//            title: Text('Team'),
//          ),
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                return ui.Gradient.linear(
                  Offset(0.0, 12.0),
                  Offset(12.0, 24.0),
                  [
                    Colors.blueAccent[100],
                    Colors.greenAccent[100],
                  ],
                );
              },
              child: Icon(Icons.chat),
            ),
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.chat,
              color: Colors.grey,
              //color: Color(0xFFFFF176),
            ),
            title: Text(
              'Chat',
              style: TextStyle(
                  color: Colors.blueAccent[100]
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Color(0xAA0091EA),
        //unselectedItemColor: Colors.black26,
        onTap: _onItemTapped,
      ),
    );
  }
}