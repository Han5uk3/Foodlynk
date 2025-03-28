part of 'challenge_bloc.dart';

sealed class ChallengeEvent extends Equatable {
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
  const UploadAfterImageEvent({required this.imageFile});
  @override
  List<Object> get props => [imageFile];
}

class RemoveBeforeImageEvent extends ChallengeEvent {
  @override
  List<Object> get props => [];
}

class SubmitChallengeEvent extends ChallengeEvent {
  @override
  List<Object> get props => [];
}
