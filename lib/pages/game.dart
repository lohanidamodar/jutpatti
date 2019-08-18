import 'package:flutter/material.dart';
import 'package:jutpatti/models/card.dart';
import 'package:jutpatti/models/player.dart';
import 'package:jutpatti/pages/animations.dart';
import 'package:jutpatti/resources/notifiers/game_state.dart';
import 'package:jutpatti/widgets/player_card.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameState>(
        builder: (context, gameState, _) {
          if (gameState.animation != null) {
            _controller.reset();
            _controller.forward();
          }
          return Stack(children: [
            ...gameState.players.map((player) {
              return _buildPlayerHand(gameState, player);
            }),
            const SizedBox(height: 10.0),
            if (gameState.turn == 0 &&
                (gameState.playType == PlayType.PICK_FROM_DECK ||
                    gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW))
              _buildPickCard(gameState),
            if (gameState.turn != 0) ...[
              Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 30,
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  child: FaceDownCard()),
              if (gameState.throwDeck.isNotEmpty && gameState.animation == null)
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 30,
                  left: MediaQuery.of(context).size.width / 2 + 10,
                  child: Container(
                    width: 60,
                    height: 80,
                    child: PlayingCardUi(
                      playingCard: gameState.throwDeck[0]..faceUp = true,
                    ),
                  ),
                )
            ],
            if (gameState.playType == PlayType.THROW_FROM_HAND)
              _buildThrowTarget(gameState),
            const SizedBox(height: 10.0),
            if (gameState.winner != null) _showWinnerDialog(context, gameState),
            if (gameState.turn != 0)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => _buildAnimation(context, gameState),
              ),
          ]);
        },
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, GameState gameState) {
    switch (gameState.animation) {
      case Animations.LEFT_TO_THROW:
        return LeftToThrow(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.THROW_TO_LEFT:
        return ThrowToLeft(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.DECK_TO_LEFT:
        return DeckToLeft(controller: _controller, child: FaceDownCard());
      case Animations.RIGHT_TO_THROW:
        return RightToThrow(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.THROW_TO_RIGHT:
        return ThrowToRight(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.DECK_TO_RIGHT:
        return DeckToRight(controller: _controller, child: FaceDownCard());
      case Animations.TOP_TO_THROW:
        return TopToThrow(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.THROW_TO_TOP:
        return ThrowToTop(
          controller: _controller,
          child: SizedBox(
              width: 60,
              height: 80,
              child: PlayingCardUi(
                playingCard: gameState.throwDeck[0]..faceUp = true,
              )),
        );
      case Animations.DECK_TO_TOP:
        return DeckToTop(controller: _controller, child: FaceDownCard());
      default:
        return Container();
    }
  }

  Widget _buildPickCard(GameState gameState) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.white24),
        height: 200,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Your turn to Pick a card"),
            const SizedBox(height: 10.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    if (gameState.joker != null) _buildJoker(gameState),
                    TransformedCard(
                      playingCard: PlayingCard(
                        cardSuit: CardSuit.clubs,
                        cardType: CardType.eight,
                        faceUp: false,
                      ),
                    ),
                    _buildDeck(gameState),
                  ],
                ),
                const SizedBox(width: 20.0),
                _buildThrowDeck(gameState),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showWinnerDialog(BuildContext context, GameState gameState) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: AlertDialog(
        title: Text("Game Over"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Winner: ${gameState.winner.name}"),
            Text("Do you want to play again?")
          ],
        ),
        actions: <Widget>[
          RaisedButton(
            textColor: Colors.white,
            child: Text("Yes"),
            onPressed: () {
              gameState.beginGame();
            },
          ),
          RaisedButton(
            textColor: Colors.white,
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildJoker(GameState gameState) {
    return TransformCard(
      transformIndex: 1,
      child: DraggableCard(
        playingCard: gameState.joker,
        maxDrags: 0,
      ),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: _buildPlayer(gameState, player),
    );
  }

  AnimatedContainer _buildPlayer(GameState gameState, Player player) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(16.0),
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
          color: gameState.turn == gameState.players.indexOf(player)
              ? Colors.orange
              : Colors.white70,
          shape: BoxShape.circle),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.place),
          const SizedBox(height: 10.0),
          Text(player.name),
        ],
      ),
    );
  }

  Widget _buildRightHand(int index, Player player, GameState gameState) {
    return Align(
        alignment: Alignment.centerRight,
        child: _buildPlayer(gameState, player));
  }

  Widget _buildBottomHand(int index, Player player, GameState gameState) {
    return Transform.translate(
      offset: Offset(100, 30),
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
                  return TransformCard(
                    transformIndex: cIndex,
                    child: DraggableCard(
                      playingCard: card..faceUp = true,
                      maxDrags: player.type == PlayerType.HUMAN &&
                              gameState.playType == PlayType.THROW_FROM_HAND
                          ? 1
                          : 0,
                      dragData: {"card": card, "from": "hand"},
                    ),
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
    return Align(
      alignment: Alignment.topCenter,
      child: _buildPlayer(gameState, player),
    );
  }

  Widget _buildDeck(GameState gameState) {
    return InkWell(
      onTap: gameState.deckTouched,
      child: DraggableCard(
        playingCard: gameState.deck[0],
        dragData: {
          "from": "deck",
          "card": gameState.deck[0],
        },
        onDragStart: gameState.deckTouched,
        maxDrags: gameState.turn == 0 &&
                (gameState.playType == PlayType.PICK_FROM_DECK ||
                    gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW)
            ? 1
            : 0,
      ),
    );
  }

  Widget _buildThrowDeck(GameState gameState) {
    return Center(
      child: gameState.throwDeck.length > 0
          ? DraggableCard(
              playingCard: gameState.throwDeck[0]..faceUp = true,
              dragData: {"from": "throw", "card": gameState.throwDeck[0]},
              maxDrags: gameState.turn == 0 &&
                      gameState.playType == PlayType.PICK_FROM_DECK_OR_THROW
                  ? 1
                  : 0,
            )
          : Container(),
    );
  }

  Widget _buildThrowTarget(GameState gameState) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, _, __) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white24),
            height: 200,
            width: 200,
            alignment: Alignment.center,
            child: Text("Your turn to throw card"),
          ),
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
