import 'package:flutter_application_datagrid_app1/data/events/piccon_event.dart';
import 'package:flutter_application_datagrid_app1/data/repo/i_ApiPicCons.dart';
import 'package:flutter_application_datagrid_app1/data/states/piccons_states.dart';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/service_locator.dart';

class PicConsBloc extends Bloc<PicConEvent, PicConState> {
  PicConsBloc() : super(PicConState(state: PicConStates.initial)) {
    on<PostPicConEvent>(_onPostPicCon);
    on<GetAllPicConsEvent>(_getAllPicCons);
    on<PostPicConAndGetAllEvent>(_onPostPicConAndGetAll);
  }

  final api = locator<IApiPicCons>();

  void _onPostPicCon(PostPicConEvent event, Emitter<PicConState> emit) async {
    emit(PicConState(state: PicConStates.uploading));

    try {
      api.postPicCon(event.picCon);
    } on Exception {
      emit(PicConState(state: PicConStates.error));
    }

    emit(PicConState(state: PicConStates.complete));
  }

  void _getAllPicCons(
      GetAllPicConsEvent event, Emitter<PicConState> emit) async {
    emit(PicConState(state: PicConStates.loading));

    List<PictureContainer> picCons = [];
    try {
      picCons = await api.getAllPicCons();
    } on Exception {
      emit(PicConState(state: PicConStates.error));
    }

    emit(PicConState(state: PicConStates.complete, picCons: picCons));
  }

  void _onPostPicConAndGetAll(
      PostPicConAndGetAllEvent event, Emitter<PicConState> emit) async {
    emit(PicConState(state: PicConStates.uploading));

    try {
      api.postPicCon(event.picCon);
    } on Exception {
      emit(PicConState(state: PicConStates.error));
    }

    emit(PicConState(state: PicConStates.loading));

    List<PictureContainer> picCons = [];
    try {
      picCons = await api.getAllPicCons();
    } on Exception {
      emit(PicConState(state: PicConStates.error));
    }

    emit(PicConState(state: PicConStates.complete, picCons: picCons));
  }
}
