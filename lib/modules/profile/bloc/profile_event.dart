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

class CreateProfileEvent extends ProfileEvent {
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final Timestamp dob;
  final String nationality;
  final String country;
  final String state;
  final String city;
  final String zipCode;

  CreateProfileEvent({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.dob,
    required this.nationality,
    required this.country,
    required this.state,
    required this.city,
    required this.zipCode,
  });

  @override
  List<Object?> get props => [
    title,
    firstName,
    lastName,
    email,
    phoneNumber,
    address,
    gender,
    dob,
    nationality,
    country,
    state,
    city,
    zipCode,
  ];
}

class EditProfileEvent extends ProfileEvent {
  final UserModel userModel;
  EditProfileEvent({required this.userModel});
  @override
  List<Object?> get props => [userModel];
}
