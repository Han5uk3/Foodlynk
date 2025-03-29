import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

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
  ) async {
    emit(BeforeUploadImageLoadingState());
    String beforeImage = await StorageService.uploadFile(
      mainPath: "Challenges",
      fileName: Services.uid,
      filePath: event.imageFile.path,
      isDeleted: true,
    );

    if (beforeImage != null) {
      bool isSuccess = await AppApis().comapreOnePlate(beforeImage);
      if (isSuccess) {
        emit(BeforeUploadImageSuccessState(image: File(event.imageFile.path)));
      } else {
        emit(
          BeforeUploadImageErrorState(errorMessage: "Failed to verify image"),
        );
      }
    } else {
      emit(BeforeUploadImageErrorState(errorMessage: "Failed to upload image"));
    }
    if (beforeImage != null) {
      bool isSuccess = await AppApis().comapreOnePlate(beforeImage);
      if (isSuccess) {
        emit(BeforeUploadImageSuccessState(image: File(event.imageFile.path)));
      }
    }
  }

  void _removeBeforeImage(
    RemoveBeforeImageEvent event,
    Emitter<ChallengeState> emit,
  ) {
    emit(ChallengeInitial());
  }
}
