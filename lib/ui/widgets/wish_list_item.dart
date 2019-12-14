import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/screens/detail_view.dart';

class WishListItem extends StatefulWidget {

  DocumentSnapshot snap;

  WishListItem(this.snap);

  @override
  _WishListItemState createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {

  StateModel appState;

  File _image;
  String _imageUrl;

  String _feedback;

  FirebaseStorage _storage = FirebaseStorage.instance;
  DocumentSnapshot _giverSnap;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);
  final _boldFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  void setGiver() {
    Firestore.instance.collection('users').document(widget.snap.data['Giver']).get().then((snap) {
      if(mounted) {
        setState(() {
          _giverSnap = snap;
        });
      }
    });
  }

  @override
  void initState() {
    setGiver();
    _feedback = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    final int status = widget.snap.data['Status'];
    final int happyStatus = widget.snap.data['HappyStatus'];

    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10.0,
          top: 10.0,
        ),
        child: ListTile(
          leading: Stack(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 55.0,
              ),
              Positioned.fill(
                child: Center(
                  child: Text(widget.snap.data['Points'].toString(), style: _boldFont),
                )
              ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snap.data['Task'],
                      overflow: TextOverflow.ellipsis,
                      style: _biggerFont,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        widget.snap.data['Date'],
                        style: _smallerFont,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<ToDoAction>(
            icon:
              status == 0 ? Icon(Icons.panorama_fish_eye, size: 30.0,) :
              status == 1 ? Icon(Icons.check_circle_outline, size: 30.0, color: Colors.green,) :
              status == 2 ? Icon(Icons.check_circle, size: 30.0, color: Colors.green,) :
              status == 3 ? Icon(Icons.cancel, size: 30.0, color: Colors.red,) :
              Icon(Icons.panorama_fish_eye, size: 30.0),
            onSelected: (ToDoAction result) {
              switch(result) {
                case ToDoAction.to_do:
                  setState(() {
                    widget.snap.reference.updateData({
                      'Status': 0
                    });
                  });
                  break;
                case ToDoAction.done:
                  setState(() {
                    widget.snap.reference.updateData({
                      'Status': 1
                    });
                  });
                  break;
                case ToDoAction.approved:
                  _approvedAlert();
//                  setState(() {
//                    widget.snap.reference.updateData({
//                      'Status': 2
//                    });
//                  });
                  break;
                case ToDoAction.not_approved:
                  _notApprovedAlert();
//                  setState(() {
//                    widget.snap.reference.updateData({
//                      'Status': 3
//                    });
//                  });
                  break;
                case ToDoAction.remove:
                  _deleteAlert();
                  break;
              }
//              setState(() {
//                _selection = result;
//              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ToDoAction>>[
              (status != 0 && status != 1) ? PopupMenuItem<ToDoAction>(
                value: ToDoAction.to_do,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.panorama_fish_eye,
                                  )
                              )
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            text: "To-Do",
                          ),
                        ]
                    )
                ),
              ) : null,
              status != 2 ? PopupMenuItem<ToDoAction>(
                value: ToDoAction.approved,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                              )
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            text: "Approved",
                          ),
                        ]
                    )
                ),
              ) : null,
              status != 3 ? PopupMenuItem<ToDoAction>(
                value: ToDoAction.not_approved,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )
                              )
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            text: "Not approved",
                          ),
                        ]
                    )
                ),
              ) : null,
              PopupMenuItem<ToDoAction>(
                value: ToDoAction.remove,
                child: RichText(
                    text: TextSpan(
                        children: [
                          WidgetSpan(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new DetailScreen(widget.snap),
            ),
          ),
        )
      )
    );
  }

  Future<void> _deleteAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really want to delete this task?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  widget.snap.reference.delete();
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _approvedAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Approve'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The task is done. Send a picture to show how happy you are'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Lets's go!"),
              onPressed: () {
                uploadPic(_image, widget.snap.documentID).then((val) => {
                  setState(() {
                    _imageUrl = val; // TODO: Check if it necessary
                    widget.snap.reference.updateData({
                      'Status': 2
                    });
                  }),
                  // TODO: Check if this is possible:
//                widget.snap.reference.updateData({
//                "happyImage": val
//                })
                  Firestore.instance.collection('Tasks').document(widget.snap.documentID).updateData({
                    "happyImage": val
                  })
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Only approve'),
              onPressed: () {
                setState(() {
                  widget.snap.reference.updateData({
                    'Status': 2
                  });
                });
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _notApprovedAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not approved'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please leave a comment why you don't approve this task"),
                TextField(
                  onChanged: (val) {
                    _feedback = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Leave a comment...",
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Let's go!"),
              onPressed: () {
                setState(() {
                  widget.snap.reference.updateData({
                    'Status': 3,
                    'Feedback': _feedback,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> uploadPic(File pic, String path) async {

    File file = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 800.0);

    StorageReference reference = _storage.ref().child(appState.user.uid + "/$path/");
    StorageUploadTask uploadTask = reference.putFile(file);

    Future<dynamic> uri = (await uploadTask.onComplete).ref.getDownloadURL();

    print("URI: " + uri.toString());

    return uri;
  }
}

enum ToDoAction { to_do, done, approved, not_approved, remove }