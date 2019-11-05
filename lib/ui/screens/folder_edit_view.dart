import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/widgets/detail_item_title.dart';
import 'package:maslooo_app/ui/widgets/detail_item_image.dart';
import 'package:maslooo_app/ui/widgets/loading_indicator.dart';
import 'package:maslooo_app/ui/screens/assign_todo.dart';
import 'package:maslooo_app/ui/screens/add_friend_to_folder.dart';

class FolderEditView extends StatefulWidget {

  final DocumentSnapshot snap;

  FolderEditView(this.snap);

  @override
  _FolderEditViewState createState() => _FolderEditViewState();
}

class _FolderEditViewState extends State<FolderEditView> {

  StateModel appState;

  String _folderName;

  FocusNode _focusNode;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();

    _folderName = null;

    _focusNode = FocusNode();

    //setGiverName();
  }

//  Future<void> setGiverName() async {
//    DocumentSnapshot querySnapshot = await Firestore.instance
//        .collection('users')
//        .document(widget.snap.data['Giver'])
//        .get();
//    if (querySnapshot.exists &&
//        querySnapshot.data.containsKey('username')) {
//
//      if(this.mounted) {
//        setState(() {
//          _giverName = querySnapshot.data['username'];
//        });
//      }
//    }
//  }


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
                  //DetailItemTitle(widget.snap, 25.0),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Text('Folder name: ', style: _biggerFont),
                        Text(widget.snap.data['Name'], style: _biggerFont),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Text('Assigned to: ', style: _biggerFont),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new StreamBuilder(
                      stream: Firestore.instance.collection('users').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return LoadingIndicator();
                        return new ListView(
                          children: snapshot.data.documents
                              .where((d) => widget.snap.data['Givers'] != null && widget.snap.data['Givers'].contains(d.documentID))
                              .map((document) {
                            return _buildFriend(document);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: new FloatingActionButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddFriendToFolder(widget.snap)),
                          );
                        },
                        child: Icon(Icons.add)
                    ),
                    title: new Text("Add Friend"),
                  ),


                ],
              ),
            )
        ),
    );
  }

  Widget _buildFriend(DocumentSnapshot document) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(document['userpic']),
        radius: 30.0,
      ),
      title: new Text(document['username']),

    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}