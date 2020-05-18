import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/widgets/achievement_item.dart';


class Achievements extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new AchievementsState();
}

class AchievementsState extends State<Achievements> {

  StateModel appState;

  String _sortby;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _sortby = _dropDownMenuItems[0].value;
  }

  List _sortType = ['Alphabet', 'Date', 'Points'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sort in _sortType) {
      items.add(new DropdownMenuItem(
          value: sort,
          child: new Text(sort)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedSort) {
    setState(() {
      _sortby = selectedSort;
    });
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Points",
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _buildOverview(appState.user),

//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text("Sort by: "),
//                  new DropdownButton(
//                      value: _sortby,
//                      items: _dropDownMenuItems,
//                      onChanged: changedDropDownItem
//                  )
//                ],
//              ),
              Expanded(
                child: new StreamBuilder(
                  //stream: Firestore.instance.collection('Tasks').where("Givers", arrayContains: "giver").snapshots(),
                  stream: Firestore.instance.collection('Tasks').where("Giver", isEqualTo: appState.user.uid).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return const Text('Loading....');

                    switch(_sortby) {
                      case 'Alphabet':
                        snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
                        break;
                      case 'Points':
                      //snapshot.data.documents.sort((a, b) => int.parse(a['Points'].toString()).compareTo(int.parse(b['Points'].toString())));
                        snapshot.data.documents.sort((a, b) => a['Points'].compareTo(b['Points']));
                        break;
                      case 'Date':
                        snapshot.data.documents.sort((a, b) => a['Date'].toString().compareTo(b['Date'].toString()));
                        break;
                      default:
                        snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
                        break;
                    }

                    return new ListView(
                      children: snapshot.data.documents
                          .where((d) => d.data['Status'] == 2)
                          .map((document) {
                        return AchievementItem(document);
                      }).toList(),
                    );


//                    return ListView.builder(
//
//                        padding: const EdgeInsets.all(1.0),
//                        //itemExtent: 80.0,
//                        itemCount: snapshot.data.documents.length,
//                        itemBuilder: (context, i) {
//
//                          switch(_sortby) {
//                            case 'Alphabet':
//                              snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
//                              break;
//                            case 'Points':
//                            //snapshot.data.documents.sort((a, b) => int.parse(a['Points'].toString()).compareTo(int.parse(b['Points'].toString())));
//                              snapshot.data.documents.sort((a, b) => a['Points'].compareTo(b['Points']));
//                              break;
//                            case 'Date':
//                              snapshot.data.documents.sort((a, b) => a['Date'].toString().compareTo(b['Date'].toString()));
//                              break;
//                            default:
//                              snapshot.data.documents.sort((a, b) => a['Task'].toString().compareTo(b['Task'].toString()));
//                              break;
//                          }
//                          return AchievementItem(snapshot.data.documents[i]);
//                        });
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildOverview(FirebaseUser user) {
    return Padding(
      padding: EdgeInsets.only(
        top: 50.0
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: 300.0,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: new NetworkImage(user.photoUrl),
                      radius: 40.0,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 5.0,
                                top: 5.0,
                                bottom: 5.0
                            ),
                            child: Row(
                              children: <Widget> [
                                Text(
                                  "Hi, " + user.displayName.split(" ").first,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 5.0,
                                top: 5.0,
                                bottom: 5.0
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 30.0,
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "200",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget> [
//                  IconButton(
//                      icon: Icon(Icons.people),
//                      onPressed: null
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.mail_outline),
//                      onPressed: null
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.notifications_none),
//                      onPressed: null
//                  ),
//                  IconButton(
//                      icon: Icon(Icons.error),
//                      onPressed: null
//                  ),
//                ],
//              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}