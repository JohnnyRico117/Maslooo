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

  TextEditingController controller = new TextEditingController();
  String filter;
  FriendAction _selection;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.4],
                      colors: [
                        Colors.blueAccent[100],
                        Colors.greenAccent[100],
                      ]
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 35.0,
              left: 10.0,
              right: 10.0
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: 300.0,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search friend...",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),

                Expanded(
                  child: new StreamBuilder(
                    stream: Firestore.instance.collection('users').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return LoadingIndicator();

                      snapshot.data.documents.sort((a, b) => a['username'].toLowerCase().compareTo(b['username'].toLowerCase()));
                      
                      return new ListView(
                        padding: EdgeInsets.only(
                            top: 5.0
                        ),
                        children:
                          filter == null || filter == "" ?
                            snapshot.data.documents
                                .where((d) => appState.currentUser.friends != null && appState.currentUser.friends.contains(d.documentID))
                                .map((document) {
                              return _buildFriend(document);
                            }).toList()
                              :
                            snapshot.data.documents
                                .where((d) => appState.currentUser.friends != null && appState.currentUser.friends.contains(d.documentID))
                                .where((d) => d.data['username'].toString().toLowerCase().contains(filter.toLowerCase()))
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddFriend()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFriend(DocumentSnapshot document) {
    return Align(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
//      margin: EdgeInsets.only(
//        left: 15.0,
//        right: 15.0,
//        bottom: 5.0,
//        top: 5.0,
//      ),
          child: Container(
              width: 300.0,
              height: 85.0,
//        padding: EdgeInsets.only(
////          left: 5.0,
////          right: 5.0,
//          bottom: 5.0,
//          top: 5.0,
//        ),
              child: Align(
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
              ),
              ),
          ),
      ),
    );

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();

    path.lineTo(0.0, size.height / 2 - 40);
    //path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    //path.quadraticBezierTo(size.width, size.height, size.height, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, size.height / 2 -40);
    path.lineTo(size.width, 0.0);

//    path.lineTo(0.0, size.height);
//
//    //creating first curver near bottom left corner
//    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
//    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);
//
//    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//        firstEndPoint.dx, firstEndPoint.dy);
//
//    //creating second curver near center
//    var secondControlPoint = Offset(size.width / 5, size.height / 4);
//    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
//
//    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//        secondEndPoint.dx, secondEndPoint.dy);
//
//    //creating third curver near top right corner
//    var thirdControlPoint = Offset(
//        size.width - (size.width / 9), size.height / 6);
//    var thirdEndPoint = Offset(size.width, 0.0);
//
//    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
//        thirdEndPoint.dx, thirdEndPoint.dy);
//
//    ///move to top right corner
//    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

enum FriendAction { profile, message, remove }