import 'package:flutter/material.dart';
import 'package:jutpatti/models/player.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:jutpatti/widgets/playing_card.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
      ),
      body: SingleChildScrollView(
        child: Consumer<GameState>(
          builder: (context, gameState, _) {
            return Column(children: [
              ...gameState.players.map((player) {
                return _buildPlayerHand(gameState, player);
              }),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Text("Deck"),
                  if (gameState.deck.length > 0) _buildDeck(gameState),
                  Text("Joker"),
                  if (gameState.joker != null)
                    TransformedCard(
                      playingCard: gameState.joker,
                      maxDrags: 0,
                    ),
                  Text("thrown"),
                  _buildThrowDeck(gameState),
                ],
              ),
              const SizedBox(height: 10.0),
              Text("turn: ${gameState.turn}"),
              RaisedButton(
                onPressed: () {
                  gameState.beginGame(playerCount: 2,numberOfCards: 5);
                },
                child: Text("Begin game"),
              ),
              if (gameState.winner != null)
                Text("Winner: ${gameState.winner.name}"),
            ]);
          },
        ),
      ),
    );
  }

  Widget _buildPlayerHand(
      GameState gameState, Player player) {
    int index = gameState.players.indexOf(player);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(player.name),
        DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            print(data);
            gameState.accept(data);
          },
          onWillAccept: (_) {
            return gameState.turn == index &&
                player.cards.length == gameState.numberOfCardsInHand;
          },
          builder: (_, pcard, ___) => Row(
            children: player.cards
                .map((card) {
                  final int index = player.cards.indexOf(card);
                  return TransformedCard(
                    playingCard: card,
                    maxDrags: player.type == PlayerType.HUMAN && gameState.playType == PlayType.THROW_FROM_HAND ? 1 : 0,
                    dragData: {
                      "card":card,
                      "from":"hand"
                    },
                    transformIndex: index,
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildDeck(GameState gameState) {
    return  TransformedCard(
        playingCard: gameState.deck[0],
        dragData: {
          "from": "deck",
          "card": gameState.deck[0],
        },
        maxDrags: gameState.playType == PlayType.PICK_FROM_DECK || gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW ? 1 : 0,
      );
  }

  Widget _buildThrowDeck(GameState gameState) {
    return DragTarget<Map<String,dynamic>>(
      builder: (context, _, __) {
        return gameState.throwDeck.length > 0
            ? TransformedCard(
                playingCard: gameState.throwDeck[0],
                dragData: {
                  "from":"throw",
                  "card": gameState.throwDeck[0]
                },
                maxDrags: gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW ? 1 : 0,
              )
            : Container(
                color: Colors.green,
                height: 80,
                width: 60,
              );
      },
      onWillAccept: (data) {
        return (gameState.playType == PlayType.THROW_FROM_HAND && data["from"] == "hand") || ((gameState.playType == PlayType.PICK_FROM_DECK || gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW) && data["from"] == "deck");
      },
      onAccept: (data) {
        gameState.throwCard(data);
      },
    );
  }
}
