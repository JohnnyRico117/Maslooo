import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/widgets/to_do_item.dart';

class ToDoList extends StatefulWidget {

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
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
          "My To-Do-List",
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Container(
//        decoration: BoxDecoration(
//            gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                stops: [0.0, 0.6],
//                colors: [
//                  Color(0xFF0091EA),
//                  Color(0xFFFFF176),
//                ]
//            )
//        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Sort by: "),
                new DropdownButton(
                    value: _sortby,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem
                )
              ],
            ),
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
                        .where((d) => d.data['Status'] != 2)
                        .map((document) {
                          return ToDoItem(document);
                        }).toList(),
                  );


                  return ListView.builder(

                      padding: const EdgeInsets.all(1.0),
                      //itemExtent: 80.0,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {

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
                        return ToDoItem(snapshot.data.documents[i]);
                      });
                },
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}