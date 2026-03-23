import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/food_detection_service.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  ChallengeBloc() : super(ChallengeInitial()) {
    on<UploadBeforeImageEvent>(_uploadBeforeImage);
    on<RemoveBeforeImageEvent>(_removeBeforeImage);
    on<UploadAfterImageEvent>(_uploadAfterImage);
    on<RemoveAfterImageEvent>(_removeAfterImage);
    on<SubmitChallengeEvent>(_submitChallenge);
  }

  Future<void> _uploadBeforeImage(
    UploadBeforeImageEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(BeforeUploadImageLoadingState());
    try {
      // Validate image locally without uploading to Firebase
      try {
        bool isValid =
            await FoodDetectionService.classifyFoodImage(event.imageFile.path);
        if (isValid) {
          // Just store the local file reference, don't upload yet
          emit(BeforeUploadImageSuccessState(image: event.imageFile));
        } else {
          emit(
            BeforeUploadImageErrorState(
              errorMessage:
                  AppLocalizations.of(event.context)!.weCouldntVerifyFood,
            ),
          );
        }
      } catch (detectionError) {
        emit(
          BeforeUploadImageErrorState(
            errorMessage:
                "Food detection error. Please try a clearer image. Error: ${detectionError.toString()}",
          ),
        );
      }
    } catch (e) {
      emit(
        BeforeUploadImageErrorState(
          errorMessage: "An error occurred: ${e.toString()}",
        ),
      );
    }
  }

  void _removeBeforeImage(
    RemoveBeforeImageEvent event,
    Emitter<ChallengeState> emit,
  ) {
    emit(ChallengeInitial());
  }

  Future<void> _uploadAfterImage(
    UploadAfterImageEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(AfterUploadImageLoadingState());
    try {
      // Validate both images locally without uploading to Firebase
      try {
        bool isValid = await FoodDetectionService.compareTwoPlates(
          event.beforeImageFile.path,
          event.imageFile.path,
        );
        if (isValid) {
          // Just store the local file references, don't upload yet
          emit(
            AfterUploadImageSuccessState(
              beforeImage: event.beforeImageFile,
              afterImage: event.imageFile,
            ),
          );
        } else {
          emit(
            AfterUploadImageErrorState(
              errorMessage:
                  AppLocalizations.of(event.context)!.theAfterimageDoesntShow,
            ),
          );
        }
      } catch (detectionError) {
        emit(
          AfterUploadImageErrorState(
            errorMessage:
                "Comparison error. Please try clearer images. Error: ${detectionError.toString()}",
          ),
        );
      }
    } catch (e) {
      emit(
        AfterUploadImageErrorState(
          errorMessage: "An error occurred: ${e.toString()}",
        ),
      );
    }
  }

  void _removeAfterImage(
    RemoveAfterImageEvent event,
    Emitter<ChallengeState> emit,
  ) {
    if (state is AfterUploadImageSuccessState) {
      final currentState = state as AfterUploadImageSuccessState;
      emit(BeforeUploadImageSuccessState(image: currentState.beforeImage));
    }
  }

  Future<void> _submitChallenge(
    SubmitChallengeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    // Capture current state BEFORE emitting loading (which overwrites state)
    final currentState = state;
    
    emit(ChallengeSubmissionLoadingState());
    try {
      // Get the current state to access the validated image files
      if (currentState is! AfterUploadImageSuccessState) {
        emit(
          ChallengeSubmissionErrorState(
            errorMessage: "Please upload both before and after images.",
          ),
        );
        return;
      }

      // Already validated locally, just award points
      int pointsEarned = 10;
      await Services.updateUserPoints(pointsEarned);
      emit(ChallengeSubmissionSuccessState(points: pointsEarned));
    } catch (e) {
      emit(
        ChallengeSubmissionErrorState(
          errorMessage: "An error occurred: ${e.toString()}",
        ),
      );
    }
  }
}
