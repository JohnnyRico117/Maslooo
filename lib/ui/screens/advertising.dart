import 'package:flutter/material.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';


class Advertising extends StatefulWidget {
  @override
  _AdvertiseState createState() => _AdvertiseState();
}

class _AdvertiseState extends State<Advertising> {

  StateModel appState;

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    // doesn't have to be Padding
    return Padding(
      // TODO
    );
  }
}