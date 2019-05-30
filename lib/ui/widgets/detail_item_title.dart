import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DetailItemTitle extends StatelessWidget {

  final DocumentSnapshot snap;
  final double padding;

  DetailItemTitle(this.snap, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            snap.data['Task'],
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                snap.data['Date'],
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}