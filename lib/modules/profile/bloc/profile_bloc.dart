import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LogoutEvent>(_logout);
    on<CreateProfileEvent>(_createProfile);
    on<EditProfileEvent>(_editProfile);
  }

  void _logout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(LogoutStateLoading(isLoading: true));
      await FirebaseAuth.instance.signOut();
      await HiveHelper.removeUID();
      emit(LogoutStateSuccess());
    } catch (e) {
      emit(LogoutStateError(errorMessage: e.toString()));
    }
  }

  void _createProfile(CreateProfileEvent event, Emitter emit) async {
    try {
      emit(CreateProfileLoadingState(isLoading: true));
      final userData = UserModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        title: event.title,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phoneNumber,
        address: event.address,
        gender: event.gender,
        dob: event.dob,
        nationality: event.nationality,
        country: event.country,
        state: event.state,
        city: event.city,
        zipCode: event.zipCode,
        points: 0,
        createdAt: DateTime.now(),
      );
      try {
        await Collections.users
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userData.toFirestore())
            .then((value) async {
              await HiveHelper.putUID(FirebaseAuth.instance.currentUser!.uid);
              emit(CreateProfileSuccessState());
            });
      } catch (firestoreError) {
        emit(CreateProfileErrorState(errorMessage: firestoreError.toString()));
      }
    } catch (e) {
      emit(CreateProfileErrorState(errorMessage: e.toString()));
    }
  }

  void _editProfile(EditProfileEvent event, Emitter emit) async {
    try {
      emit(EditProfileLoadingState(isLoading: true));
      try {
        await Collections.users
            .doc(event.userModel.uid)
            .update({
              'address': event.userModel.address,
              'city': event.userModel.city,
              'country': event.userModel.country,
              'state': event.userModel.state,
              'zipCode': event.userModel.zipCode,
              'title': event.userModel.title,
              'firstName': event.userModel.firstName,
              'lastName': event.userModel.lastName,
              'phoneNumber': event.userModel.phoneNumber,
              'email': event.userModel.email,
              'gender': event.userModel.gender,
              'dob': event.userModel.dob,
              'nationality': event.userModel.nationality,
            })
            .then((value) {
              emit(EditProfileSuccessState());
            })
            .onError((error, stackTrace) {
              emit(EditProfileErrorState(errorMessage: error.toString()));
            });
      } catch (firestoreError) {
        emit(EditProfileErrorState(errorMessage: firestoreError.toString()));
      }
    } catch (e) {
      emit(EditProfileErrorState(errorMessage: e.toString()));
    }
  }
}
