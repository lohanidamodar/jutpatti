
import 'package:flutter/material.dart';
import 'package:jutpatti/models/card.dart';
import 'dart:math';

import 'package:jutpatti/models/player.dart';

class GameState extends ChangeNotifier {
  Player player1 = Player(name: "Player 1", cards: []);
  Player player2 = Player(name: "Player 2", cards: []);
  List<PlayingCard> deck=[];
  List<PlayingCard> throwDeck=[];
  List<PlayingCard> allCards;
  PlayingCard joker;
  int turn = 0;
  int numberOfCardsInHand = 5;
  List<PlayingCard> jokers;

  beginGame() {
    allCards = List<PlayingCard>.from( getAllCards());
    player1.cards = [];
    player2.cards = [];
    deck = [];
    Random random = Random();
    for (int i = 0; i < numberOfCardsInHand * 2; i++) {
      int randomNumber = random.nextInt(allCards.length);
      if(i%2 == 0) {
        player1.cards.add(allCards.removeAt(randomNumber));
      }else{
        player2.cards.add(allCards.removeAt(randomNumber));
      }
    }
    joker = allCards.removeAt(random.nextInt(allCards.length));
    jokers = [
      PlayingCard(cardSuit: CardSuit.clubs,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.spades,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.hearts,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.diamonds,cardType: joker.nextCard()),
    ];
    deck = allCards;
    deck.shuffle();
    isWinner(player2);
    notifyListeners();
  }

  bool isWinner(Player player) {
    int pairsNeeded = (numberOfCardsInHand + 1)~/2;
    return player.isWinner(jokers,pairsNeeded);
  }

  nextTurn() {
    turn = turn == 0 ? 1 : 0;
    notifyListeners();
  }

}