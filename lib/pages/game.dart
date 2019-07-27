import 'package:flutter/material.dart';
import 'package:jutpatti/models/card.dart';
import 'package:jutpatti/models/player.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:jutpatti/widgets/playing_card.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameState>(
        builder: (context, gameState, _) {
          return Stack(children: [
            ...gameState.players.map((player) {
              return _buildPlayerHand(gameState, player);
            }),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  if (gameState.joker != null) _buildJoker(gameState),
                  TransformedCard(
                    playingCard: PlayingCard(
                      cardSuit: CardSuit.clubs,
                      cardType: CardType.eight,
                      faceUp: false,
                    ),
                    rotation: 0,
                  ),
                  _buildDeck(gameState),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text("Deck"),
                if (gameState.deck.length > 0) _buildDeck(gameState),
                Text("Joker"),
                if (gameState.joker != null) _buildJoker(gameState),
                Text("thrown"),
                _buildThrowDeck(gameState),
              ],
            ),
            const SizedBox(height: 10.0),
            Text("turn: ${gameState.turn}"),
            if (gameState.winner != null)
              Text("Winner: ${gameState.winner.name}"),
          ]);
        },
      ),
    );
  }

  TransformedCard _buildJoker(GameState gameState) {
    return TransformedCard(
      playingCard: gameState.joker,
      transformIndex: 1,
      rotation: -.1,
      maxDrags: 0,
    );
  }

  _indexOfAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.bottomCenter;
      case 1:
        return Alignment.centerLeft;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget _buildPlayerHand(GameState gameState, Player player) {
    int index = gameState.players.indexOf(player);
    switch (index) {
      case 1:
        return _buildRightHand(index, player, gameState);
      default:
        return _buildBottomHand(index, player, gameState);
    }
  }

  Widget _buildLeftHand(int index, Player player, GameState gameState) {
    return Positioned(
      bottom: -100,
      left: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: player.cards.map((card) {
              final int cIndex = player.cards.indexOf(card);
              return TransformedCard(
                rotation: 3.14 / 2,
                transformAxis: 1,
                transformDistance: 55,
                playingCard: card,
                maxDrags: 0,
                transformIndex: cIndex,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  Widget _buildRightHand(int index, Player player, GameState gameState) {
    return Positioned(
      bottom: -150,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: player.cards.map((card) {
              final int cIndex = player.cards.indexOf(card);
              return TransformedCard(
                rotation: -3.14 / 2,
                transformAxis: 1,
                transformDistance: 55,
                playingCard: card,
                maxDrags: 0,
                transformIndex: cIndex,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Align _buildBottomHand(int index, Player player, GameState gameState) {
    return Align(
      alignment: _indexOfAlignment(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              mainAxisSize: MainAxisSize.min,
              children: player.cards.map((card) {
                final int cIndex = player.cards.indexOf(card);
                return TransformedCard(
                  playingCard: card,
                  maxDrags: player.type == PlayerType.HUMAN &&
                          gameState.playType == PlayType.THROW_FROM_HAND
                      ? 1
                      : 0,
                  dragData: {"card": card, "from": "hand"},
                  transformIndex: cIndex,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildDeck(GameState gameState) {
    return TransformedCard(
      rotation: 0,
      playingCard: gameState.deck[0],
      dragData: {
        "from": "deck",
        "card": gameState.deck[0],
      },
      maxDrags: gameState.playType == PlayType.PICK_FROM_DECK ||
              gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW
          ? 1
          : 0,
    );
  }

  Widget _buildThrowDeck(GameState gameState) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, _, __) {
        return gameState.throwDeck.length > 0
            ? TransformedCard(
                playingCard: gameState.throwDeck[0],
                dragData: {"from": "throw", "card": gameState.throwDeck[0]},
                maxDrags: gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW
                    ? 1
                    : 0,
              )
            : Container(
                color: Colors.green,
                height: 80,
                width: 60,
              );
      },
      onWillAccept: (data) {
        return (gameState.playType == PlayType.THROW_FROM_HAND &&
                data["from"] == "hand") ||
            ((gameState.playType == PlayType.PICK_FROM_DECK ||
                    gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW) &&
                data["from"] == "deck");
      },
      onAccept: (data) {
        gameState.throwCard(data);
      },
    );
  }
}
