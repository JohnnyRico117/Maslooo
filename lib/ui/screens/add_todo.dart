import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:maslooo_app/model/state.dart';
import 'package:maslooo_app/state_widget.dart';

class AddToDo extends StatefulWidget {

  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {

  StateModel appState;

  final _formKey = GlobalKey<FormState>();

  String _task = '';
  String _date = '';
  String _points = '';

  var txt = new TextEditingController();
  DateFormat format = new DateFormat("dd.MM.yyyy 'at' hh:mm");

  @override
  Widget build(BuildContext context) {

    appState = StateWidget.of(context).state;

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Add a new Happy item')
        ),
        body: new ListView(

          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter something to do';
                      } else {
                        setState(() {
                          _task = value;
                        });
                      }
                    },
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate();
                    },
                    child: IgnorePointer(
                      child: new TextFormField(
                        controller: txt,
                        decoration: new InputDecoration(
                            hintText: 'Enter deadline...',
                            contentPadding: const EdgeInsets.all(16.0)
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a Date';
                          } else {
                            setState(() {
                              _date = txt.text;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                        hintText: 'Enter points...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some points';
                      } else {
                        setState(() {
                          _points = value;
                        });
                      }
                    },
                  )
                ],
              ),
            ),

            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  DocumentReference docRef = Firestore.instance.collection('Tasks').document();
                  docRef.setData({
                    'Task' : _task,
                    'Done': false,
                    'Date': _date,
                    'Points': int.parse(_points),
                    'ReceiverID': appState.user.uid,
                    'Status': 0,
                    'HappyStatus': 0
                  });

                  print("ID: " + docRef.documentID.toString());

                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2040)

    );
    if(picked != null) setState(() {
      txt.text = format.format(picked);
    });
  }
}

