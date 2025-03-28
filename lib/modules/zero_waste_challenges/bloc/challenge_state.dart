part of 'challenge_bloc.dart';

sealed class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object> get props => [];
}

final class ChallengeInitial extends ChallengeState {}

final class BeforeUploadImageLoadingState extends ChallengeState {}

final class BeforeUploadImageSuccessState extends ChallengeState {
  final File image;
  const BeforeUploadImageSuccessState({required this.image});
  @override
  List<Object> get props => [image];
}

final class BeforeUploadImageErrorState extends ChallengeState {
  final String errorMessage;
  const BeforeUploadImageErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
