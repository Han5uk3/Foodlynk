part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Locale locale;

  const ProfileState({this.locale = const Locale('en')});

  ProfileState copyWith({Locale? locale}) {
    return ProfileState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}

class LogoutStateLoading extends ProfileState {
  final bool isLoading;
  const LogoutStateLoading({required this.isLoading});
  @override
  String toString() => 'LogoutStateLoading{isLoading: $isLoading}';
}

class LogoutStateSuccess extends ProfileState {}

class LogoutStateError extends ProfileState {
  final String errorMessage;
  const LogoutStateError({required this.errorMessage});
  @override
  String toString() => 'LogoutStateError{errorMessage: $errorMessage}';
}

class CreateProfileLoadingState extends ProfileState {
  final bool isLoading;
  const CreateProfileLoadingState({required this.isLoading});
  @override
  String toString() => 'CreateProfileLoadingState{isLoading: $isLoading}';
}

class CreateProfileSuccessState extends ProfileState {}

class CreateProfileErrorState extends ProfileState {
  final String errorMessage;
  const CreateProfileErrorState({required this.errorMessage});
  @override
  String toString() => 'CreateProfileErrorState{errorMessage: $errorMessage}';
}

class EditProfileLoadingState extends ProfileState {
  final bool isLoading;
  const EditProfileLoadingState({required this.isLoading});
  @override
  String toString() => 'EditProfileLoadingState{isLoading: $isLoading}';
}

class EditProfileSuccessState extends ProfileState {}

class EditProfileErrorState extends ProfileState {
  final String errorMessage;
  const EditProfileErrorState({required this.errorMessage});
  @override
  String toString() => 'EditProfileErrorState{errorMessage: $errorMessage}';
}

class DeleteProfileLoadingState extends ProfileState {
  final bool isLoading;
  const DeleteProfileLoadingState({required this.isLoading});
  @override
  String toString() => 'DeleteProfileLoadingState{isLoading: $isLoading}';
}

class DeleteProfileSuccessState extends ProfileState {}

class DeleteProfileErrorState extends ProfileState {
  final String errorMessage;
  const DeleteProfileErrorState({required this.errorMessage});
  @override
  String toString() => 'DeleteProfileErrorState{errorMessage: $errorMessage}';
}