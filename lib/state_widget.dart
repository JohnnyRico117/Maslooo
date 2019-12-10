import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/model/user.dart';
import 'package:maslooo_app/utils/auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String usertoken;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
    _firebaseMessaging.getToken().then((token){
      usertoken = token;
    });
  }


  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }


  Future<User> getUser() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists) {
      return User.fromSnap(querySnapshot);
    }
    return null;
  }

//  Future<Iterable<Contact>> getContacts() async {
//    Iterable<Contact> contacts = await ContactsService.getContacts();
//    return contacts;
//  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    state.user = firebaseUser;

    if (firebaseUser != null) {

      final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        state.newuser = true;
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'id': firebaseUser.uid,
          'username': firebaseUser.displayName,
          'userpic': firebaseUser.photoUrl,
          //'birthday': _birthday,
          //'likes': _likes,
          'points': 0,
          'token': usertoken
        });
      } else {
        Firestore.instance.collection('users').document(firebaseUser.uid).updateData({
          'token': usertoken
        });
      }

      User theUser = await getUser();

      //Iterable<Contact> contacts = await getContacts();

      setState(() {
        state.isLoading = false;

        //state.contacts = contacts;

        state.currentUser = theUser;

      });
    }

  }

  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}