
import 'package:flutter/material.dart';
import 'package:jutpatti/models/card.dart';
import 'dart:math';

import 'package:jutpatti/models/player.dart';

enum PlayType{
  PICK_FROM_DECK,
  PICK_FROM_DECK_OR_THROW,
  THROW_FROM_HAND,
}

enum Animations {
  THROW_TO_LEFT,
  DECK_TO_LEFT,
  LEFT_TO_THROW,
  THROW_TO_TOP,
  DECK_TO_TOP,
  TOP_TO_THROW,
  THROW_TO_RIGHT,
  DECK_TO_RIGHT,
  RIGHT_TO_THROW,
}

class GameState extends ChangeNotifier {
  List<Player> players=[];
  int numberOfPlayers = 2;
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
  Animations animation;
  Duration animationDuration = Duration(milliseconds: 500);

  setNumberOfPlayers(int number) {
    numberOfPlayers = number;
    notifyListeners();
  }

  setNumberOfCardsInHands(int number) {
    numberOfCardsInHand = number;
    notifyListeners();
  }

  beginGame() {
    players = [];
    for(int i = 0; i < numberOfPlayers; i++) {
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
    joker = allCards.removeAt(random.nextInt(allCards.length))..faceUp=true;
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
      players[turn].cards = players[turn].cards.map((card)=>card..faceUp = true).toList();
      playType = null;
      turn = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  nextTurn() {
    if(turn!=null)
      turn = (turn+1)%numberOfPlayers;
    playByComputer();
  }

  _makeDeckFromThrowDeck() {
    deck.addAll(throwDeck.map((card){card.faceUp = false; return card;}));
    throwDeck = [deck.removeAt(0)..faceUp = true];
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
    notifyListeners();
  }

  playByComputer() async {
    if(winner != null) return;
    Player player = players[turn];
    if(player.type == PlayerType.COMPUTER) {
      await Future.delayed(animationDuration);
      if(playType == PlayType.PICK_FROM_DECK) {
        await _autoPickFromDeck();
      }else if(playType == PlayType.PICK_FROM_DECK_OR_THROW) {
        PlayingCard card = throwDeck[0];
        if(sameCardInHand(card) == 1) {
          animation = turn == 1 ? Animations.THROW_TO_LEFT : turn==2?Animations.THROW_TO_RIGHT:Animations.THROW_TO_TOP;
          notifyListeners();
          await Future.delayed(animationDuration);
          player.cards.add(card..faceUp=false);
          if(isWinner())
            return;
          else{
            animation = turn == 1 ? Animations.LEFT_TO_THROW : turn==2?Animations.RIGHT_TO_THROW:Animations.TOP_TO_THROW;
            notifyListeners();
            autoThrowCard();
            await Future.delayed(animationDuration);
          }
        }else{
          await _autoPickFromDeck();
        }
      }
      if(deck.length == 1) 
        _makeDeckFromThrowDeck();
      playType = PlayType.PICK_FROM_DECK_OR_THROW;
      animation = null;
      notifyListeners();
      nextTurn();
      notifyListeners();
    }
  }

  _autoPickFromDeck() async{
    animation = turn == 1 ? Animations.DECK_TO_LEFT : turn==2?Animations.DECK_TO_RIGHT:Animations.DECK_TO_TOP;
    notifyListeners();
    await Future.delayed(animationDuration);
    PlayingCard card = deck.removeAt(0);
    if(sameCardInHand(card) == 1 || jokers.contains(card)) {
      players[turn].cards.add(card);
      if(isWinner())
        return;
      animation = turn == 1 ? Animations.LEFT_TO_THROW : turn==2?Animations.RIGHT_TO_THROW:Animations.TOP_TO_THROW;
      notifyListeners();
      autoThrowCard();
      await Future.delayed(animationDuration);
    }else{
      animation = turn == 1 ? Animations.LEFT_TO_THROW : turn==2?Animations.RIGHT_TO_THROW:Animations.TOP_TO_THROW;
      notifyListeners();
      throwDeck.insert(0, card);
      await Future.delayed(animationDuration);

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

  sortCards(List<PlayingCard> cards) {
    cards.sort((card1,card2) => card1.cardType.index.compareTo(card2.cardType.index));
  }

  deckTouched() {
    if(playType == PlayType.PICK_FROM_DECK || playType == PlayType.PICK_FROM_DECK_OR_THROW) {
      deck[0]..faceUp = true;
      playType = PlayType.PICK_FROM_DECK;
      notifyListeners();
    }
  }

}