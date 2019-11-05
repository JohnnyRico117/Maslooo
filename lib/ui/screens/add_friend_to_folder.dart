import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

class AddFriendToFolder extends StatefulWidget {

  final DocumentSnapshot snap;

  AddFriendToFolder(this.snap);

  @override
  State<StatefulWidget> createState() => new AddFriendToFolderState();
}

class AddFriendToFolderState extends State<AddFriendToFolder> {

  StateModel appState;

  TextEditingController controller = new TextEditingController();
  String filter;

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildFriend(DocumentSnapshot document) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(document['userpic']),
        radius: 20.0,
      ),
      title: new Text(document['username']),
      trailing: new IconButton(
        icon: Icon(Icons.person_add),
        onPressed: () => addFriend(document['id'].toString()),
      ),
    );
  }

  addFriend(String friendID) {

    final DocumentReference postRef = Firestore.instance.collection('folders').document(widget.snap.documentID);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'Givers': FieldValue.arrayUnion([friendID])
        });
      }
    });

    // TODO: TEMP
    //appState.friends.add(friendID);
    //appState.currentUser.friends.add(friendID);


    Navigator.pop(context);
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return Scaffold(
        appBar: new AppBar(
          title: Text("Add a friend"),
        ),
        body: Column(
          children: <Widget>[
//            new TextField(
//              decoration: new InputDecoration(
//                  labelText: "Search member"
//              ),
//              controller: controller,
//            ),
            Expanded(
              child: new StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();
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
        )

    );
  }

}