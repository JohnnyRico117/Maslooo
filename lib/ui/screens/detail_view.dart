import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/widgets/detail_item_title.dart';
import 'package:maslooo_app/ui/widgets/detail_item_image.dart';
import 'package:maslooo_app/ui/screens/assign_todo.dart';

class DetailScreen extends StatefulWidget {

  final DocumentSnapshot snap;

  DetailScreen(this.snap);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  StateModel appState;

  String _giverName;

  bool _tapped;
  bool _pointTapped;

  FocusNode _focusNode;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _giverName = null;
    _tapped = false;
    _pointTapped = false;

    _focusNode = FocusNode();

    setGiverName();
  }

  Future<void> setGiverName() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(widget.snap.data['Giver'])
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('username')) {

      if(this.mounted) {
        setState(() {
          _giverName = querySnapshot.data['username'];
        });
      }
    }
  }

  Widget _prizeText() {

    print(_tapped.toString());

    return
      _tapped == false ?
      GestureDetector(
          child: Row(
            children: <Widget>[
              Text("1000", style: _biggerFont),
              Icon(
                Icons.attach_money,
                color: Colors.green,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _pointTapped = false;
              _tapped = true;
            });
          }
      ) :
      Container(
          width: 150.0,
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
                hintText: 'Enter prize...',
                contentPadding: const EdgeInsets.all(16.0)
            ),
            onSubmitted: (val) {
//              widget.snap.reference.updateData({
//
//              });
              setState(() {
                _tapped = false;
              });
            },
            focusNode: _focusNode,
          )
      );
  }

  Widget _pointsText() {
    return
      _pointTapped == false ?
      GestureDetector(
          child: Row(
            children: <Widget>[
              Text(widget.snap.data['Points'].toString(), style: _biggerFont),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _tapped = false;
              _pointTapped = true;
            });
          }
      ) :
      Container(
          width: 150.0,
          child: TextField(
            autofocus: true,
            decoration: new InputDecoration(
                hintText: 'Enter points...',
                contentPadding: const EdgeInsets.all(16.0)
            ),
            onSubmitted: (val) {
              widget.snap.reference.updateData({
                'Points': int.parse(val),

              });
              setState(() {
                _pointTapped = false;
              });
            },

            focusNode: _focusNode,
          )
      );
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    //setGiverName();

    return GestureDetector(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DetailItemImage("https://images.pexels.com/photos/17796/christmas-xmas-gifts-presents.jpg?cs=srgb&dl=birthday-christmas-gift-17796.jpg&fm=jpg"),
                DetailItemTitle(widget.snap, 25.0),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text('Description: ', style: _biggerFont),
                      Text("Enter a description....", style: _biggerFont),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text('Prize: ', style: _biggerFont),
                      _prizeText(),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text('Points: ', style: _biggerFont),
                      _pointsText()
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text('Assigned to: ', style: _biggerFont),
                      GestureDetector(
                        child:
                        _giverName == null ? Text("Not Assigned", style: _biggerFont) :
                        Text(_giverName, style: _biggerFont),
                        onTap: () {
                          setState(()  {
                            _tapped = false;
                            _pointTapped = false;
                          });

                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AssignToDo(widget.snap)),
                          ).then((newGiver) {
                            setState(() {
                              _giverName = newGiver;
                            });
                          });
                        },
                      )
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text('Status: ', style: _biggerFont),
                      Text(widget.snap.data['Done'] == true ? "Done" : "Not Done", style: _biggerFont)
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
          setState(() {
            _tapped = false;
            _pointTapped = false;
          });
        }
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}