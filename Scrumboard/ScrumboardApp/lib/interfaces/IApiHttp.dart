//The api repository, to be implemented for all to-be data access layers.
import 'package:scrumboard_app/models/card_model.dart';

abstract class IApiHttp {

  Future<List<CardModel>> getAllCardModels();
  Future<CardModel> postCardModel(CardModel cardMdl);
  Future<void> updateCardModel(CardModel cardMdl);
  Future<void> deleteCardModel(CardModel cardMdl);
  Future<void> deleteAllCardModels();
}