import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jutpatti/pages/animations.dart';
import 'package:jutpatti/pages/game.dart';
import 'package:jutpatti/pages/home.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ChangeNotifierProvider(
      builder: (context) => GameState(),
      child: MaterialApp(
        title: 'JutPatti',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.pink.shade400
        ),
        home: HomePage(),
        routes: {
          "game":(_) => GamePage()
        },
      ),
    );
  }
}
