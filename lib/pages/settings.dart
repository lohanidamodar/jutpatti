import 'package:flutter/material.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<int> cards = [5,7,9,11];
  final List<int> players = [2,3,4];
  @override
  Widget build(BuildContext context){
    return Consumer<GameState>(
      builder: (context,state, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Number of Players"),
            Row(
              children: players.map((pCount)=>Expanded(
                  child: RadioListTile(
                    groupValue: state.numberOfPlayers,
                    value: pCount,
                    title: Text("$pCount"),
                    onChanged: (value){
                      state.setNumberOfPlayers(value);
                    },
                  ),
                )).toList(),
            ),
            Text("Number of Cards"),
            Row(
              children: cards.map((pCount)=>Expanded(
                  child: RadioListTile(
                    groupValue: state.numberOfCardsInHand,
                    value: pCount,
                    title: Text("$pCount"),
                    onChanged: (value){
                      state.setNumberOfCardsInHands(value);
                    },
                  ),
                )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}