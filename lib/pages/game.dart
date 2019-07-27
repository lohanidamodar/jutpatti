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
            Transform.translate(
              offset: Offset(-100,0),
              child: Align(
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
            ),
            Transform.translate(
              offset: Offset(100,0),
              child: Align(
                alignment: Alignment.center,
                child: _buildThrowDeck(gameState),
              ),
            ),
            /* Row(
              children: <Widget>[
                Text("Deck"),
                if (gameState.deck.length > 0) _buildDeck(gameState),
                Text("Joker"),
                if (gameState.joker != null) _buildJoker(gameState),
                Text("thrown"),
                _buildThrowDeck(gameState),
              ],
            ), */
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

  Widget _buildPlayerHand(GameState gameState, Player player) {
    int index = gameState.players.indexOf(player);
    switch (index) {
      case 1:
        return _buildLeftHand(index, player, gameState);
      case 2:
        return _buildRightHand(index, player, gameState);
      case 3:
        return _buildTopHand(index, player, gameState);
      default:
        return _buildBottomHand(index, player, gameState);
    }
  }

  Widget _buildLeftHand(int index, Player player, GameState gameState) {
    return Positioned(
      bottom: (gameState.numberOfCardsInHand * 25).toDouble() + 50,
      left: -40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Stack(
            children: player.cards.map((card) {
              final int cIndex = player.cards.indexOf(card);
              return TransformedCard(
                rotation: 0,
                position: Position.LEFT,
                transformAxis: 1,
                transformDistance: -25,
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
      bottom:50,
      right: -40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 40),
          Stack(
            // mainAxisSize: MainAxisSize.min,
            children: player.cards.map((card) {
              final int cIndex = player.cards.indexOf(card);
              return TransformedCard(
                position: Position.RIGHT,
                transformAxis: 1,
                playingCard: card,
                rotation: 0,
                maxDrags: 0,
                transformIndex: cIndex,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHand(int index, Player player, GameState gameState) {
    return Transform.translate(
      offset: Offset(100,30),
      child: Align(
        alignment: Alignment.bottomCenter,
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
                    playingCard: card..faceUp=true,
                    maxDrags: player.type == PlayerType.HUMAN &&
                            gameState.playType == PlayType.THROW_FROM_HAND
                        ? 1
                        : 0,
                    rotation: 0,
                    dragData: {"card": card, "from": "hand"},
                    transformIndex: cIndex,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  Widget _buildTopHand(int index, Player player, GameState gameState) {
    return Transform.translate(
      offset: Offset(100,-40),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DragTarget<Map<String, dynamic>>(
              onAccept: (data) {
                print(data);
                gameState.accept(data);
              },
              onWillAccept: (_) {
                return gameState.turn == index &&
                    player.cards.length == gameState.numberOfCardsInHand;
              },
              builder: (_, pcard, ___) => Stack(
                children: player.cards.map((card) {
                  final int cIndex = player.cards.indexOf(card);
                  return TransformedCard(
                    position: Position.TOP,
                    rotation: 0,
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
            Text(player.name),
          ],
        ),
      ),
    );
  }

  Widget _buildDeck(GameState gameState) {
    return InkWell(
      onTap: gameState.deckTouched,
      child: TransformedCard(
        rotation: 0,
        playingCard: gameState.deck[0],
        dragData: {
          "from": "deck",
          "card": gameState.deck[0],
        },
        onDragStart: gameState.deckTouched,
        maxDrags: gameState.playType == PlayType.PICK_FROM_DECK ||
                gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW
            ? 1
            : 0,
      ),
    );
  }

  Widget _buildThrowDeck(GameState gameState) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, _, __) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 200,
          width: 200,
          alignment: Alignment.center,
          child: gameState.throwDeck.length > 0
              ? TransformedCard(
                  playingCard: gameState.throwDeck[0]..faceUp=true,
                  dragData: {"from": "throw", "card": gameState.throwDeck[0]},
                  maxDrags: gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW
                      ? 1
                      : 0,
                )
              : Container(),
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
