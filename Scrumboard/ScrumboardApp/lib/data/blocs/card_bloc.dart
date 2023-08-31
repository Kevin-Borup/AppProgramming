import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:scrumboard_app/data/blocs/events/card_events.dart';
import 'package:scrumboard_app/data/blocs/states/card_states.dart';
import 'package:scrumboard_app/interfaces/IApiHttp.dart';
import 'package:scrumboard_app/models/card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/locator_service.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardState(state: CardStates.initial)) {
    on<GetAllCardsEvent>(_getAllCards);
    on<DeleteAllCardsEvent>(_deleteAllCards);
    on<PostCardEvent>(_postCard);
    on<UpdateCardEvent>(_updateCard);
    on<DeleteCardEvent>(_deleteCard);
  }

  final _api = locator<IApiHttp>(); //Using the locator to get the Api interface
  final db = Localstore.instance;
  final String colCards = "cards";

  void _getAllCards(GetAllCardsEvent event, Emitter<CardState> emit) async {
    emit(CardState(state: CardStates.loading));

    List<CardModel>? cards;
    try {
      cards = await _api.getAllCardModels();
      await db.collection(colCards).delete();
      for (var card in cards) {
        _addToOrUpdateLocalDB(card);
      }
    } on Exception {
      try {
        var dbCards = await db.collection(colCards).get();
        if (dbCards != null){
          cards = (dbCards as List).map((i) => CardModel.fromJson(i)).toList();
        }
      } on Exception {
        emit(CardState(state: CardStates.error));
      }
    }

    emit(CardState(state: CardStates.complete, cards: cards));
  }

  void _deleteAllCards(DeleteAllCardsEvent event, Emitter<CardState> emit) async {
    emit(CardState(state: CardStates.deleting));

    try {
      await _api.deleteAllCardModels();
      await db.collection(colCards).delete();
    } on Exception {
      emit(CardState(state: CardStates.error));
    }

    emit(CardState(state: CardStates.complete));
  }

  void _postCard(PostCardEvent event, Emitter<CardState> emit) async {
    emit(CardState(state: CardStates.deleting));

    try {
      await _api.postCardModel(event.cardMdl);
      await _addToOrUpdateLocalDB(event.cardMdl);
    } on Exception {
      emit(CardState(state: CardStates.error));
    }

    _getAllCards(GetAllCardsEvent(), emit);
  }

  void _updateCard(UpdateCardEvent event, Emitter<CardState> emit) async {
    emit(CardState(state: CardStates.deleting));

    try {
      await _api.updateCardModel(event.cardMdl);
      await _addToOrUpdateLocalDB(event.cardMdl);
    } on Exception {
      emit(CardState(state: CardStates.error));
    }

    _getAllCards(GetAllCardsEvent(), emit);
  }

  void _deleteCard(DeleteCardEvent event, Emitter<CardState> emit) async {
    emit(CardState(state: CardStates.deleting));

    try {
      await _api.deleteCardModel(event.cardMdl);
      final id = event.cardMdl.id == "" ? db.collection(colCards).doc().id : event.cardMdl.id;
      await db.collection(colCards).doc(id).delete();
    } on Exception {
      emit(CardState(state: CardStates.error));
    }

    _getAllCards(GetAllCardsEvent(), emit);
  }

  Future<void> _addToOrUpdateLocalDB(CardModel cardMdl) async {
    final id = cardMdl.id == "" ? db.collection(colCards).doc().id : cardMdl.id;
    await db.collection(colCards).doc(id).set(cardMdl.toMap());
  }
}
