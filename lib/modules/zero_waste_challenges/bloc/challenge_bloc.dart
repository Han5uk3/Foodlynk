import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  ChallengeBloc() : super(ChallengeInitial()) {
    on<UploadBeforeImageEvent>(_uploadBeforeImage);
    on<RemoveBeforeImageEvent>(_removeBeforeImage);
  }

  void _uploadBeforeImage(
    UploadBeforeImageEvent event,
    Emitter<ChallengeState> emit,
  ) {
    log(event.imageFile.path);
    emit(BeforeUploadImageSuccessState(image: event.imageFile));
  }

  void _removeBeforeImage(
    RemoveBeforeImageEvent event,
    Emitter<ChallengeState> emit,
  ) {
    emit(BeforeUploadImageSuccessState(image: File(null ?? "")));
  }
}
