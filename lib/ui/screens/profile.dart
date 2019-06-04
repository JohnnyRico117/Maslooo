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

    return new Stack(
      children: <Widget>[
        //_buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildUserInfo(),
              _buildCards("My Wish-List", Icons.sentiment_very_satisfied, '/wishlist'),
              _buildCards("My To-Do-List", Icons.sentiment_very_satisfied, '/todolist'),
              _buildCards("Settings", Icons.settings, '/settings')
            ],
          ),
        ),

      ],
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
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.cake, color: Colors.pinkAccent),
                            Container(
                                padding: const EdgeInsets.only(left: 8),
                                //child: Text(appState.currentUser.bday)
                                child: Text("01.01.1990")
                            )

                          ],
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.yellow),
                          Container(
                              padding: const EdgeInsets.only(left: 8),
                              //child: Text(appState.points.toString())
                              child: Text(appState.currentUser.points.toString())
                          )
                        ],
                      ),
                    ),
                    Container(
                      //child: Text(appState.likes)
                        //child: Text(appState.currentUser.likes)
                        child: Text("Fun!!!")
                    ),

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
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 1.0),
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
        padding: EdgeInsets.symmetric(horizontal: 5.0),
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

}