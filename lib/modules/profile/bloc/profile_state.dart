part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class LogoutStateLoading extends ProfileState {
  final bool isLoading;
  LogoutStateLoading({required this.isLoading});
  @override
  String toString() => 'LogoutStateLoading{isLoading: $isLoading}';
}

class LogoutStateSuccess extends ProfileState {}

class LogoutStateError extends ProfileState {
  final String errorMessage;
  LogoutStateError({required this.errorMessage});
  @override
  String toString() => 'LogoutStateError{errorMessage: $errorMessage}';
}

class CreateProfileLoadingState extends ProfileState {
  final bool isLoading;
  CreateProfileLoadingState({required this.isLoading});
  @override
  String toString() => 'CreateProfileLoadingState{isLoading: $isLoading}';
}

class CreateProfileSuccessState extends ProfileState {}

class CreateProfileErrorState extends ProfileState {
  final String errorMessage;
  CreateProfileErrorState({required this.errorMessage});
  @override
  String toString() => 'CreateProfileErrorState{errorMessage: $errorMessage}';
}

class EditProfileLoadingState extends ProfileState {
  final bool isLoading;
  EditProfileLoadingState({required this.isLoading});
  @override
  String toString() => 'EditProfileLoadingState{isLoading: $isLoading}';
}

class EditProfileSuccessState extends ProfileState {}

class EditProfileErrorState extends ProfileState {
  final String errorMessage;
  EditProfileErrorState({required this.errorMessage});
  @override
  String toString() => 'EditProfileErrorState{errorMessage: $errorMessage}';
}
