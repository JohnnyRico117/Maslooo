import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  String bday;
  int points;
  String likes;
  List<String> friends;
  String happy;
  String sad;
  String neutral;
  String veryHappy;

  User({
    this.bday,
    this.points,
    this.likes,
    this.friends,
    this.happy,
    this.sad,
    this.neutral,
    this.veryHappy
  });

  User.fromSnap(DocumentSnapshot snap)
      : this(
      bday: snap.data.containsKey('birthday') ? snap.data['birthday'] : '',
      points: snap.data.containsKey('points') ? snap.data['points'] : '',
      likes: snap.data.containsKey('likes') ? snap.data['likes'] : '',
      friends: (snap.data.containsKey('friends') && snap.data['friends'] is List) ? new List<String>.from(snap.data['friends']) : null,
      happy: snap.data.containsKey('happyImage') ? snap.data['happyImage'] : '',
      sad: snap.data.containsKey('sadImage') ? snap.data['sadImage'] : '',
      neutral: snap.data.containsKey('neutralImage') ? snap.data['neutralImage'] : '',
      veryHappy: snap.data.containsKey('veryHappyImage') ? snap.data['veryHappyImage'] : ''
  );

//  User.fromMap(Map<String, dynamic> data, String id)
//      : this(
//          id: id,
//          name: data['name'],
//          //type: UserType.values[data['type']],
//          //points: data['points'],
//          //todolists: new List<String>.from(data['todolists']),
//          //happyImages: new List<String>.from(data['happyImages'])
//  );
}