part of 'challenge_bloc.dart';

abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object> get props => [];
}

class UploadBeforeImageEvent extends ChallengeEvent {
  final File imageFile;

  const UploadBeforeImageEvent({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class UploadAfterImageEvent extends ChallengeEvent {
  final File imageFile;
  final File beforeImageFile;

  const UploadAfterImageEvent({
    required this.imageFile, 
    required this.beforeImageFile
  });

  @override
  List<Object> get props => [imageFile, beforeImageFile];
}

class RemoveBeforeImageEvent extends ChallengeEvent {}

class RemoveAfterImageEvent extends ChallengeEvent {}

class SubmitChallengeEvent extends ChallengeEvent {
  final File beforeImageFile;
  final File afterImageFile;

  const SubmitChallengeEvent({
    required this.beforeImageFile,
    required this.afterImageFile,
  });

  @override
  List<Object> get props => [beforeImageFile, afterImageFile];
}