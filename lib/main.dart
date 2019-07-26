import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jutpatti/models/card.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:jutpatti/widgets/playing_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]); */
    return ChangeNotifierProvider(
      builder: (context) => GameState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
      ),
      body: SingleChildScrollView(
        child: Consumer<GameState>(
          builder: (context,gameState, _) {
            return Column(
              children: [
                Row(
                  children: gameState.player1.cards.map((card)=>TransformedCard(
                    playingCard: card,
                  )).toList(),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Text("Deck"),
                    if(gameState.deck.length > 0)
                      Draggable(
                        data: gameState.deck[0],
                        child: TransformedCard(playingCard: gameState.deck[0],),
                        feedback: Container(child: TransformedCard(
                          playingCard: gameState.deck[0],
                        ),),
                        childWhenDragging: TransformedCard(
                          playingCard: gameState.deck[1],
                        ),
                      ),
                    Text("Joker"),
                    if(gameState.joker != null)
                      TransformedCard(playingCard: gameState.joker,),
                    Text("thrown"),
                    if(gameState.throwDeck.length > 0)
                      TransformedCard(playingCard: gameState.throwDeck[0],)
                  ],
                ),
                const SizedBox(height: 10.0),
                DragTarget<PlayingCard>(
                  onAccept: (pcard) {
                    print(pcard.cardType.index);
                    gameState.player2.cards.add(pcard);
                    gameState.deck.removeAt(0);
                    gameState.notifyListeners();
                  },
                  onWillAccept: (_)=>gameState.player2.cards.length == gameState.numberOfCardsInHand,
                  builder: (_,pcard,___) => Row(
                    children: gameState.player2.cards.map((card)=>TransformedCard(
                      playingCard: card,
                    )).toList(),
                  ),
                ),
                Text("turn: ${gameState.turn}"),
                RaisedButton(
                  onPressed: (){
                    gameState.beginGame();
                  },
                  child: Text("Begin game"),
                )
              ]
            );
          },
        ),
      ),
    );
  }
}