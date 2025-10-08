import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final AppApis _appApis = AppApis();

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
      String? beforeImagePath = await StorageService.uploadFile(
        mainPath: "Challenges",
        fileName: Services.uid ?? "",
        filePath: event.imageFile.path,
        isDeleted: true,
      );

      if (beforeImagePath != null) {
        bool isValid = await _appApis.comapreOnePlate(beforeImagePath);
        if (isValid) {
          emit(BeforeUploadImageSuccessState(image: event.imageFile));
        } else {
          emit(
            BeforeUploadImageErrorState(
              errorMessage:
                  AppLocalizations.of(event.context)!.weCouldntVerifyFood,
            ),
          );
        }
      } else {
        emit(
          BeforeUploadImageErrorState(
            errorMessage:
                "Failed to upload image. Please check your connection.",
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
      String? afterImagePath = await StorageService.uploadFile(
        mainPath: "Challenges",
        fileName: "${Services.uid}_after",
        filePath: event.imageFile.path,
        isDeleted: true,
      );

      if (afterImagePath != null) {
        String? beforeImagePath = await StorageService.getFileUrl(
          mainPath: "Challenges",
          fileName: Services.uid ?? "",
        );

        if (beforeImagePath != null) {
          bool isValid = await _appApis.compareTwoPlates(
            beforeImagePath,
            afterImagePath,
          );
          if (isValid) {
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
        } else {
          emit(
            AfterUploadImageErrorState(
              errorMessage:
                  "Failed to retrieve before image. Please upload it again.",
            ),
          );
        }
      } else {
        emit(
          AfterUploadImageErrorState(
            errorMessage:
                "Failed to upload after image. Please check your connection.",
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
    emit(ChallengeSubmissionLoadingState());
    try {
      String? beforeImagePath = await StorageService.getFileUrl(
        mainPath: "Challenges",
        fileName: Services.uid ?? "",
      );
      String? afterImagePath = await StorageService.getFileUrl(
        mainPath: "Challenges",
        fileName: "${Services.uid}_after",
      );

      if (beforeImagePath != null && afterImagePath != null) {
        bool isSuccessful = await _appApis.compareTwoPlates(
          beforeImagePath,
          afterImagePath,
        );
        if (isSuccessful) {
          int pointsEarned = 10;
          await Services.updateUserPoints(pointsEarned);
          emit(ChallengeSubmissionSuccessState(points: pointsEarned));
        } else {
          emit(
            ChallengeSubmissionErrorState(
              errorMessage:
                  "Challenge verification failed. The before and after images don't match the criteria.",
            ),
          );
        }
      } else {
        emit(
          ChallengeSubmissionErrorState(
            errorMessage:
                "Failed to retrieve images. Please upload them again.",
          ),
        );
      }
    } catch (e) {
      emit(
        ChallengeSubmissionErrorState(
          errorMessage: "An error occurred: ${e.toString()}",
        ),
      );
    }
  }
}
