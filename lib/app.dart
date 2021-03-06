import 'package:flutter/material.dart';

import 'package:maslooo_app/ui/theme.dart';
import 'package:maslooo_app/ui/screens/login.dart';
import 'package:maslooo_app/ui/screens/home.dart';
import 'package:maslooo_app/ui/screens/wish_list.dart';
import 'package:maslooo_app/ui/screens/to_do_list.dart';
import 'package:maslooo_app/ui/screens/folders.dart';
import 'package:maslooo_app/ui/screens/settings.dart';

class MasloooApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maslooo',
      theme: buildTheme(),
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/wishlist': (context) => WishList(null),
        '/todolist': (context) => ToDoList(),
        '/folders': (context) => FolderList(),
        '/settings': (context) => Settings(),
      },
    );
  }
}