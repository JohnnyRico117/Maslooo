import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/screens/detail_view.dart';

class ToDoItem extends StatefulWidget {

  DocumentSnapshot snap;

  ToDoItem(this.snap);

  @override
  _ToDoItemState createState() => _ToDoItemState();

}

class _ToDoItemState extends State<ToDoItem> {

  StateModel appState;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);
  final _boldFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  String _happyImageUrl;
  String _happyText;

  Future<void> _happyPopup(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_happyText),
          content:
          _happyImageUrl == "" ?
          Image.asset("assets/No_picture_available.png",
            fit: BoxFit.contain,
          ) :
          Image.network(
            _happyImageUrl,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  void setHappyPic() {

    Firestore.instance.collection('users').document(widget.snap.data['ReceiverID']).get().then((snap) {
      if(mounted) {
        setState(() {
          switch (widget.snap.data['HappyStatus']) {
            case 1:
              snap.data['sadImage'] == null
                  ? _happyImageUrl = ""
                  : _happyImageUrl = snap.data['sadImage'];
              _happyText = "Really???";
              break;
            case 2:
              snap.data['neutralImage'] == null
                  ? _happyImageUrl = ""
                  : _happyImageUrl = snap.data['neutralImage'];
              _happyText = "You can do better ;)";
              break;
            case 3:
              snap.data['happyImage'] == null
                  ? _happyImageUrl = ""
                  : _happyImageUrl = snap.data['happyImage'];
              _happyText = "Gooood job :)";
              break;
            case 4:
              snap.data['veryHappyImage'] == null
                  ? _happyImageUrl = ""
                  : _happyImageUrl = snap.data['veryHappyImage'];
              _happyText = "You make me soooooo happy :D";
              break;
            default:
              _happyImageUrl = "";
              break;
          }
        });
      }
    });
  }


  @override
  void initState() {
    setHappyPic();
    super.initState();
  }

//  @override
//  Widget build(BuildContext context) {
//
//    appState = StateWidget.of(context).state;
//
//    final int status = widget.snap.data['Status'];
//    final int happyStatus = widget.snap.data['HappyStatus'];
//
//    return ListTile(
//      title: Row(
//        children: [
//          Expanded(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Text(
//                  widget.snap.data['Task'],
//                  //document['Task'],
//                  style: _biggerFont,
//                ),
//                Container(
//                  padding: const EdgeInsets.only(top: 3),
//                  child: Text(
//                    widget.snap.data['Date'],
//                    //document['Date'],
//                    style: _smallerFont,
//                  ),
//                )
//
//              ],
//
//            ),
//          ),
//          Icon(
//            Icons.star,
//            color: Colors.yellow,
//          ),
//          Text(widget.snap.data['Points'].toString()),
//        ],
//      ),
//
//      trailing: Row(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          happyStatus == 1 ?
//          IconButton(icon: new Icon(Icons.sentiment_dissatisfied, color: Colors.red),
//            onPressed: () {
//              _happyPopup(context);
//            },
//          ) :
//          happyStatus == 2 ?
//          IconButton(icon: new Icon(Icons.sentiment_neutral, color: Colors.blue),
//            onPressed: () {
//              _happyPopup(context);
//            },
//          ) :
//          happyStatus == 3 ?
//          IconButton(icon: new Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
//            onPressed: () {
//              _happyPopup(context);
//            },
//          ) :
//          happyStatus == 4 ?
//          IconButton(icon: new Icon(Icons.sentiment_very_satisfied, color: Colors.green),
//            onPressed: () {
//              _happyPopup(context);
//            },
//          ) :
//          IconButton(icon: Icon(Icons.insert_emoticon),
//            onPressed: () {
//              null;
//            },
//          ),
//
//          status == 0 ? new IconButton(
//              icon: Icon(Icons.check_circle_outline),
//              onPressed: () {
//                setState(() {
//                  widget.snap.reference.updateData({
//                    'Status': 1
//                  });
//                });
//              }) :
//          status == 1 ? new IconButton(
//              icon: Icon(Icons.check_circle_outline, color: Colors.green),
//              onPressed: () {
//                setState(() {
//                  widget.snap.reference.updateData({
//                    'Status': 0
//                  });
//                });
//              }) :
//          new IconButton(
//              icon: Icon(Icons.check_circle, color: Colors.green),
//              onPressed: null
//          )
//
////          new IconButton(
////              icon:
////              status == 1 ? Icon(Icons.check_circle_outline, color: Colors.green) :
////              status == 2 ? Icon(Icons.check_circle, color: Colors.green) :
////              Icon(Icons.check_circle_outline),
////              onPressed: () {
////                setState(() {
////                  if (status == 0) {
////                    widget.snap.reference.updateData({
////                      'Status': 1
////                    });
////                  } else {
////                    widget.snap.reference.updateData({
////                      'Status': 0
////                    });
////                  }
////                });
////              }
////          ),
//        ],
//      ),
//      onTap: () {
//        print("TAP");
//      },
//    );
//  }
//
//}

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
                      print("Approved");
                      break;
                    case ToDoAction.not_done:
                      print("Pending");
                      break;
                    case ToDoAction.remove:
                      print("Remove");
                      break;

                  }

//              setState(() {
//                _selection = result;
//              });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<ToDoAction>>[
                  PopupMenuItem<ToDoAction>(
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
                  ),
                  PopupMenuItem<ToDoAction>(
                    value: ToDoAction.done,
                    child: RichText(
                        text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.check_circle_outline,
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
                                text: "Done",
                              ),
                            ]
                        )
                    ),
                  ),
//                  PopupMenuItem<ToDoAction>(
//                    value: ToDoAction.not_done,
//                    child: RichText(
//                        text: TextSpan(
//                            children: [
//                              WidgetSpan(
//                                  child: Padding(
//                                      padding: EdgeInsets.only(right: 10.0),
//                                      child: Icon(
//                                        Icons.cancel,
//                                        color: Colors.red,
//                                      )
//                                  )
//                              ),
//                              TextSpan(
//                                style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black,
//                                  fontSize: 16.0,
//                                ),
//                                text: "Not done",
//                              ),
//                            ]
//                        )
//                    ),
//                  ),
//                  PopupMenuItem<ToDoAction>(
//                    value: ToDoAction.remove,
//                    child: RichText(
//                        text: TextSpan(
//                            children: [
//                              WidgetSpan(
//                                  child: Padding(
//                                      padding: EdgeInsets.only(right: 10.0),
//                                      child: Icon(
//                                        Icons.delete,
//                                        color: Colors.red,
//                                      )
//                                  )
//                              ),
//                              TextSpan(
//                                style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black,
//                                  fontSize: 16.0,
//                                ),
//                                text: "Remove",
//                              ),
//                            ]
//                        )
//                    ),
//                  ),
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
}

enum ToDoAction { to_do, done, not_done, approved, remove }
