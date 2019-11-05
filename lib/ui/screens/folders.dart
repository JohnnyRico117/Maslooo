import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/screens/add_folder.dart';
import 'package:maslooo_app/ui/widgets/folder_item.dart';

class FolderList extends StatefulWidget {

  @override
  _FolderListState createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
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
        title: Text("My To-Do-List"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              //stream: Firestore.instance.collection('Tasks').where("Givers", arrayContains: "giver").snapshots(),
              stream: Firestore.instance.collection('folders').where("ReceiverID", isEqualTo: appState.user.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading....');
                return ListView.builder(

                    padding: const EdgeInsets.all(16.0),
                    //itemExtent: 80.0,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      return FolderItem(snapshot.data.documents[i]);

                      //return Text(snapshot.data.documents[i].data['Name']);
                    });
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddFile()),
                      );
                    },
                    tooltip: 'Add Folder',
                    child: new Icon(Icons.add)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}