import 'package:flutter/material.dart';

class DetailItemImage extends StatelessWidget {

  final String imageURL;

  DetailItemImage(this.imageURL);

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Image.network(
        imageURL,
        fit: BoxFit.cover,
      ),
      //child: AssetImage("assets/brooke-lark-385507-unsplash.jpg"),
    );
  }
}