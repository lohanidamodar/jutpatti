import 'package:flutter/material.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:provider/provider.dart';

import 'settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                textColor: Theme.of(context).primaryColor,
                color: Colors.white,
                height: 100,
                minWidth: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.gamepad,size: 40.0,),
                    const SizedBox(height: 5.0),
                    Text("Play".toUpperCase()),
                  ],
                ),
                onPressed: () {
                  Provider.of<GameState>(context).beginGame();
                  Navigator.of(context).pushNamed('game');
                },
              ),
              const SizedBox(width: 20.0),
              MaterialButton(
                textColor: Theme.of(context).primaryColor,
                color: Colors.white,
                height: 100,
                minWidth: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.settings,size: 40.0,),
                    const SizedBox(height: 5.0),
                    Text("Settings".toUpperCase()),
                  ],
                ),
                onPressed: () {
                  _showSettings(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Row(
          children: <Widget>[
            Text("Settings"),
            Spacer(),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: ()=>Navigator.pop(context),
            )
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        children: <Widget>[
          SettingsPage(),
        ],
      )
    );
  }
}