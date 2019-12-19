import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';
import 'package:maslooo_app/ui/screens/add_todo.dart';
import 'package:maslooo_app/ui/screens/add_folder.dart';
import 'package:maslooo_app/ui/widgets/wish_list_item.dart';

class WishList extends StatefulWidget {

  String folderID;

  WishList(this.folderID);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList>
    with SingleTickerProviderStateMixin {

  StateModel appState;

  String _sortby;
  List _sortType = ['Alphabet', 'Date', 'Points'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<String> tasks;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _sortby = _dropDownMenuItems[0].value;
  }

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
          "My Wish-List",
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
                stream:
                    widget.folderID == null ? Firestore.instance.collection('Tasks').where("ReceiverID", isEqualTo: appState.user.uid).snapshots()
                    : Firestore.instance.collection('Tasks').where("FolderID", isEqualTo: widget.folderID).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const Text('Loading....');
                  return ListView.builder(
                      padding: const EdgeInsets.all(1.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, i) {
                        switch(_sortby) {
                          case 'Alphabet':
                            snapshot.data.documents.sort((a, b) => a['Task'].toString().toLowerCase().compareTo(b['Task'].toString().toLowerCase()));
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
                        return WishListItem(snapshot.data.documents[i]);
                    });
                },
              ),
            ),

//            Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.all(10.0),
//                  child: FloatingActionButton(
//                      onPressed: () {
//                        Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => AddToDo(widget.folderID)),
//                        );
//                      },
//                      tooltip: 'Add Wish',
//                      child: new Icon(Icons.add)
//                  ),
//                ),
//              ],
//            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddToDo(widget.folderID)),
            );
          },
          tooltip: 'Add Wish',
          child: new Icon(Icons.add)
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}