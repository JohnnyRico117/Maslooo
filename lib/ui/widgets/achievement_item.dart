import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

import 'package:maslooo_app/ui/screens/detail_view.dart';

class AchievementItem extends StatefulWidget {

  DocumentSnapshot snap;

  AchievementItem(this.snap);

  @override
  _AchievementItemState createState() => _AchievementItemState();

}

class _AchievementItemState extends State<AchievementItem> {

  StateModel appState;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 12.0);
  final _boldFont = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

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


  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    final int status = widget.snap.data['Status'];
    final int happyStatus = widget.snap.data['HappyStatus'];

    return Align(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
//            padding: EdgeInsets.only(
//              bottom: 10.0,
//              top: 10.0,
//            ),
              width: 300.0,
              height: 85.0,
              child: ListTile(
                leading: Stack(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          //stops: [0.0, 0.6],
                          colors: [
                            Colors.blueAccent[200],
                            Colors.greenAccent[200],
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned.fill(
                      bottom: 20.0,
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 30.0,
                      ),

                    ),
                    Positioned.fill(
                        top: 20.0,
                        child: Center(
                          child: Text(widget.snap.data['Points'].toString(), style: _boldFont),
                        )
                    ),
                  ],
                ),
                title: Text(
                  widget.snap.data['Task'],
                  overflow: TextOverflow.ellipsis,
                  style: _biggerFont,
                ),
                subtitle: Text(
                  widget.snap.data['Date'],
                  style: _smallerFont,
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.mood,
                      color: Colors.green,
                    ),
                    onPressed: null
                ),
//              onTap: () => Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => new DetailScreen(widget.snap),
//                ),
//              ),
              )
          )
      ),
    );
  }
}