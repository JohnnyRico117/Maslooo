import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/screens/wish_list.dart';
import 'package:maslooo_app/ui/screens/folder_edit_view.dart';

class FolderItem extends StatefulWidget {

  DocumentSnapshot snap;

  FolderItem(this.snap);

  @override
  _FolderItemState createState() => _FolderItemState();

}

class _FolderItemState extends State<FolderItem> {

  StateModel appState;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return ListTile(
      leading: Icon(Icons.folder),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap.data['Name'],
                  style: _biggerFont,
                ),
//                Container(
//                  padding: const EdgeInsets.only(top: 3),
//                  child: Text(
//                    widget.snap.documentID,
//                    //document['Date'],
//                    style: _smallerFont,
//                  ),
//                )
              ],

            ),
          ),
        ],
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new FolderEditView(widget.snap),
                ),
              ),

            ),

          ]
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WishList(widget.snap.documentID)),
        );
      },
    );
  }

}


