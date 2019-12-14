import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/screens/add_friend.dart';
import 'package:maslooo_app/ui/widgets/loading_indicator.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  StateModel appState;

  FriendAction _selection;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.6],
                colors: [
                  Color(0xFF0091EA),
                  Color(0xFFFFF176),
                ]
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('users').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return LoadingIndicator();
                    return new ListView(
                      children: snapshot.data.documents
                          .where((d) => appState.currentUser.friends != null && appState.currentUser.friends.contains(d.documentID))
                          .map((document) {
                        return _buildFriend(document);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFriend()),
            );
          },
          child: Icon(Icons.add)
      ),
    );
  }

  Widget _buildFriend(DocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 5.0,
        top: 5.0,
      ),
      child: Padding(
        padding: EdgeInsets.only(
//          left: 5.0,
//          right: 5.0,
          bottom: 5.0,
          top: 5.0,
        ),
        child: ListTile(
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage(document['userpic']),
            radius: 30.0,
          ),
          title: new Text(document['username']),
          trailing: PopupMenuButton<FriendAction>(
            onSelected: (FriendAction result) {

              switch(result) {
                case FriendAction.profile:
                  print("PROFILE");
                  break;
                case FriendAction.message:
                  print("Message");
                  break;
                case FriendAction.remove:
                  print("Remove");
                  break;
              }

//              setState(() {
//                _selection = result;
//              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FriendAction>>[
              PopupMenuItem<FriendAction>(
                value: FriendAction.profile,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                          child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.person,
                              )
                          )
                      ),
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        text: "View profile",
                      ),
                    ]
                  )
                ),
              ),
              PopupMenuItem<FriendAction>(
                value: FriendAction.message,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.message,
                                  )
                              )
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            text: "Send message",
                          ),
                        ]
                    )
                ),
              ),
              PopupMenuItem<FriendAction>(
                value: FriendAction.remove,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.delete,
                                  )
                              )
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            text: "Remove",
                          ),
                        ]
                    )
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}

enum FriendAction { profile, message, remove }