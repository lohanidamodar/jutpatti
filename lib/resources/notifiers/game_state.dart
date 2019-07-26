
import 'package:flutter/material.dart';
import 'package:jutpatti/models/card.dart';
import 'dart:math';

import 'package:jutpatti/models/player.dart';

enum PlayType{
  PICK_FROM_DECK,
  PICK_FROM_DECK_OR_THROW,
  THROW_FROM_HAND,
}

class GameState extends ChangeNotifier {
  List<Player> players=[];
  int numberOfPlayers;
  List<PlayingCard> deck=[];
  List<PlayingCard> throwDeck=[];
  List<PlayingCard> allCards;
  PlayingCard joker;
  int turnCount = 0;
  int turn;
  int numberOfCardsInHand = 5;
  List<PlayingCard> jokers;
  Player winner;
  PlayType playType;

  beginGame({int playerCount = 2,int numberOfCards = 5}) {
    numberOfCardsInHand = numberOfCards;
    numberOfPlayers = playerCount;
    players = [];
    for(int i = 0; i < playerCount; i++) {
      players.add(Player(
        cards: [],
        type: i==0 ? PlayerType.HUMAN : PlayerType.COMPUTER,
        name: "Player ${i+1}"
      ));
    }
    allCards = List<PlayingCard>.from( getAllCards());
    deck = [];
    throwDeck = [];
    winner = null;
    allCards.shuffle();
    for (int i = 0; i < numberOfCardsInHand; i++) {
      players.forEach((player)=>player.cards.add(allCards.removeAt(0)));
    }
    Random random = Random();
    joker = allCards.removeAt(random.nextInt(allCards.length));
    jokers = [
      PlayingCard(cardSuit: CardSuit.clubs,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.spades,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.hearts,cardType: joker.nextCard()),
      PlayingCard(cardSuit: CardSuit.diamonds,cardType: joker.nextCard()),
    ];
    deck = allCards;
    deck.shuffle();
    turn = 1;
    turnCount = 0;
    playType = PlayType.PICK_FROM_DECK;
    playByComputer();
    isWinner();
    notifyListeners();
  }

  bool isWinner() {
    int pairsNeeded = (numberOfCardsInHand + 1)~/2;
    if( players[turn].isWinner(jokers,pairsNeeded)){
      winner = players[turn];
      playType = null;
      turn = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  nextTurn() {
    turn = (turn+1)%numberOfPlayers;
  }

  _makeDeckFromThrowDeck() {
    deck.addAll(throwDeck);
    throwDeck = [deck.removeAt(0)];
  }

  accept(Map data) {
    if(data["from"] == "deck") {
      players[turn].cards.add(deck.removeAt(0));
      if(deck.length == 1) 
        _makeDeckFromThrowDeck();
    }else if(data["from"] == "throw") {
      players[turn].cards.add(throwDeck.removeAt(0));
    }
    isWinner();
    playType = PlayType.THROW_FROM_HAND;
    notifyListeners();
  }

  throwCard(Map data) {
    PlayingCard card = data["card"];
    if(data["from"] == "hand") {
      players[turn].cards.remove(card);
      throwDeck.insert(0,card);
    }else if(data["from"] =="deck"){
      throwDeck.insert(0, deck.removeAt(0));
      if(deck.length == 1) 
        _makeDeckFromThrowDeck();
    }
    playType = PlayType.PICK_FROM_DECK_OR_THROW;
    turnCount++;
    nextTurn();
    playByComputer();
    notifyListeners();
  }

  playByComputer() {
    Player player = players[turn];
    if(player.type == PlayerType.COMPUTER) {
      if(playType == PlayType.PICK_FROM_DECK) {
        _autoPickFromDeck();
      }else if(playType == PlayType.PICK_FROM_DECK_OR_THROW) {
        PlayingCard card = throwDeck[0];
        if(sameCardInHand(card) == 1) {
          player.cards.add(card);
          if(isWinner())
            return;
          autoThrowCard();
        }else{
          _autoPickFromDeck();
        }
      }
      nextTurn();
      notifyListeners();
    }
  }

  _autoPickFromDeck() {
    PlayingCard card = deck.removeAt(0);
    if(sameCardInHand(card) == 1 || jokers.contains(card)) {
      players[turn].cards.add(card);
      if(isWinner())
        return;
      autoThrowCard();
    }else{
      throwDeck.insert(0, card);
    }
  }

  sameCardInHand(PlayingCard card) {
    int sameCardInHand = 0;
    players[turn].cards.forEach((handCard){
      if(card.cardType == handCard.cardType)
        sameCardInHand++;
    });
    return sameCardInHand;
  }

  autoThrowCard() {
    final List<PlayingCard> throwable =  players[turn].getThrowAbleCard(jokers);
    players[turn].cards.remove(throwable[0]);
    throwDeck.insert(0, throwable[0]);
  }

}