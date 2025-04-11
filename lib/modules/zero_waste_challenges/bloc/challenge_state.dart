part of 'challenge_bloc.dart';

abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object?> get props => [];
}

class ChallengeInitial extends ChallengeState {}

class BeforeUploadImageLoadingState extends ChallengeState {}

class BeforeUploadImageSuccessState extends ChallengeState {
  final File image;

  const BeforeUploadImageSuccessState({required this.image});

  @override
  List<Object> get props => [image];
}

class BeforeUploadImageErrorState extends ChallengeState {
  final String errorMessage;

  const BeforeUploadImageErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class AfterUploadImageLoadingState extends ChallengeState {}

class AfterUploadImageSuccessState extends ChallengeState {
  final File beforeImage;
  final File afterImage;

  const AfterUploadImageSuccessState({
    required this.beforeImage,
    required this.afterImage,
  });

  @override
  List<Object> get props => [beforeImage, afterImage];
}

class AfterUploadImageErrorState extends ChallengeState {
  final String errorMessage;

  const AfterUploadImageErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ChallengeSubmissionLoadingState extends ChallengeState {}

class ChallengeSubmissionSuccessState extends ChallengeState {
  final int points;

  const ChallengeSubmissionSuccessState({required this.points});

  @override
  List<Object> get props => [points];
}

class ChallengeSubmissionErrorState extends ChallengeState {
  final String errorMessage;

  const ChallengeSubmissionErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
