import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

class AddFriend extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new AddFriendState();
}

class AddFriendState extends State<AddFriend> {

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

    final DocumentReference postRef = Firestore.instance.collection('users').document(appState.user.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'friends': FieldValue.arrayUnion([friendID])
        });
      }
    });

    // TODO: TEMP
    //appState.friends.add(friendID);
    appState.currentUser.friends.add(friendID);

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
            new TextField(
              decoration: new InputDecoration(
                  labelText: "Search member"
              ),
              controller: controller,
            ),
            Expanded(
              child: new StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();
                  return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        return filter == null || filter == "" ?
                        _buildFriend(snapshot.data.documents[i]) :
                        snapshot.data.documents[i]['username'].toString().toLowerCase().contains(filter.toLowerCase()) ?
                        _buildFriend(snapshot.data.documents[i]) : new Container();
                      }
                  );
                },
              ),
            ),
          ],
        )

    );
  }

}