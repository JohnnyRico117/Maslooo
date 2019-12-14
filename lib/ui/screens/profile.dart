import 'package:flutter/material.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
            colors: [
              Color(0xFF0091EA),
              //Color(0xFF03A9F4),
              //Color(0xFF29B6F6),
              Color(0xFFFFF176),

              //Colors.white

            ]
        )
        
      ),
        child: new Column(
          children: <Widget>[
            _buildAvatar(),
            _buildUserInfo(),
            _buildButtons(),
            //_buildCards("My Wish-List", Icons.sentiment_very_satisfied, '/wishlist'),
            //_buildCards("My Wish-Folders", Icons.folder, '/folders'),
            //_buildCards("My To-Do-List", Icons.sentiment_very_satisfied, '/todolist'),
            //_buildCards("My To-Do-Folders", Icons.folder, '/settings')
          ],
        ),
    );


  }

  Widget _buildAvatar() {
    return
      new CircleAvatar(
        backgroundImage: new NetworkImage(appState.user.photoUrl),
        radius: 50.0,
      );
  }

  Widget _buildUserInfo() {
    return new Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Text(
                            appState.user.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                            )
                        )
                    ),
//                    Container(
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Icon(Icons.cake, color: Colors.pinkAccent),
//                            Container(
//                                padding: const EdgeInsets.only(left: 8),
//                                //child: Text(appState.currentUser.bday)
//                                child: Text("01.01.1990")
//                            )
//
//                          ],
//                        )
//                    ),
//                    Container(
//                      padding: const EdgeInsets.all(12),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(Icons.star, color: Colors.yellow),
//                          Container(
//                              padding: const EdgeInsets.only(left: 8),
//                              //child: Text(appState.points.toString())
//                              child: Text(appState.currentUser.points.toString())
//                          )
//                        ],
//                      ),
//                    ),
//                    Container(
//                      //child: Text(appState.likes)
//                        //child: Text(appState.currentUser.likes)
//                        child: Text("Fun!!!")
//                    ),

                  ],
                )
            )
          ],
        )
    );
  }

  Widget _buildCards(String title, IconData icon, String route) {
    Card _buildCard() {
      return Card(
        elevation: 5.0,
        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 0.1),
              leading: Icon(icon, color: Colors.white),

              title: Text(
                title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),

              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () => Navigator.pushNamed(context, '/wishlist'),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.whatshot,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    Text(
                      "Wishes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),

                  ],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () => Navigator.pushNamed(context, '/todolist'),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.blue,
                      size: 50.0,
                    ),
                    Text(
                      "To-Do",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),

                  ],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () {
                  _willComeLater();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.green,
                      size: 50.0,
                    ),
                    Text(
                      "Shop",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),

                  ],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () {
                  _willComeLater();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 50.0,
                    ),
                    Text(
                      "Points",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),

                  ],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: RawMaterialButton(
                onPressed: () {
                  _willComeLater();
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.redeem,
                      color: Colors.amber,
                      size: 50.0,
                    ),
                    Text(
                      "Gifts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                      ),
                    ),

                  ],
                ),
                shape: new CircleBorder(),
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _willComeLater() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nothing here for now'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This function will come later!!!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cool'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}