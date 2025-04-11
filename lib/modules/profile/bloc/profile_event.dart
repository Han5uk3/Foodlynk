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
  final String title;
  final String firstName;
  final String profileImage;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final Timestamp dob;
  final String zipCode;
  final bool isEmailLogin;
  final String? password;

  CreateProfileEvent({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.isEmailLogin,
    required this.profileImage,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.dob,
    required this.zipCode,
    this.password,
  });

  @override
  List<Object?> get props => [
    title,
    firstName,
    profileImage,
    lastName,
    email,
    phoneNumber,
    address,
    gender,
    dob,
    zipCode,
  ];
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
