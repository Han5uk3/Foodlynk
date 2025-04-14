part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogoutEvent extends ProfileEvent {
  final CommunityBloc communityBloc;
  LogoutEvent({required this.communityBloc});
}

class DeleteProfileEvent extends ProfileEvent {}

class CreateProfileEvent extends ProfileEvent {
  final UserModel userModel;
  final String? password;
  final bool isEmailLogin;

  CreateProfileEvent({
    required this.userModel,
    required this.isEmailLogin,
    this.password,
  });

  @override
  List<Object?> get props => [userModel];
}

class EditProfileEvent extends ProfileEvent {
  final UserModel userModel;
  final bool preserveLocale;
  final String locale;
  EditProfileEvent({
    required this.userModel,
    this.preserveLocale = false,
    this.locale = 'en',
  });
  @override
  List<Object?> get props => [userModel];
}

class ChangeLocale extends ProfileEvent {
  final String languageCode;

  ChangeLocale({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}
