import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ChangeLocale>(_onChangeLocale);
    on<LogoutEvent>(_logout);
    on<DeleteProfileEvent>(_deleteProfile);
    on<CreateProfileEvent>(_createProfile);
    on<EditProfileEvent>(_editProfile);
  }

  static Locale getSavedLocale() {
    String languageCode = HiveHelper().getUserlanguage();
    return Locale(languageCode);
  }

  void _onChangeLocale(ChangeLocale event, Emitter<ProfileState> emit) {
    HiveHelper().putUserlanguage(event.languageCode);
    emit(state.copyWith(locale: Locale(event.languageCode)));
  }

  void _logout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(LogoutStateLoading(isLoading: true));
      await FirebaseAuth.instance.signOut();
      Services.uid = "";
      await HiveHelper.removeUID();
      await HiveHelper.removeIsGuest();

      emit(LogoutStateSuccess());
    } catch (e) {
      emit(LogoutStateError(errorMessage: e.toString()));
    }
  }

  void _deleteProfile(DeleteProfileEvent event, Emitter emit) async {
    emit(DeleteProfileLoadingState(isLoading: true));

    try {
      await Future.microtask(() => null);

      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.delete(Collections.users.doc(Services.uid));

      final foodSwapFuture =
          Collections.foodSwap.where('uid', isEqualTo: Services.uid).get();
      final smartShoppingFuture =
          Collections.smartShopping.where('uid', isEqualTo: Services.uid).get();
      final notificationsFuture =
          Collections.notifications.where('uid', isEqualTo: Services.uid).get();
      final donationsFuture =
          Collections.donations
              .where('raisedBy', isEqualTo: Services.uid)
              .get();

      final results = await Future.wait([
        foodSwapFuture,
        smartShoppingFuture,
        notificationsFuture,
        donationsFuture,
      ]);

      for (var i = 0; i < results.length; i++) {
        for (var doc in results[i].docs) {
          batch.delete(doc.reference);
        }
      }

      final realtimeDb = FirebaseDatabase.instance;
      final chatRef = realtimeDb.ref('chats');
      final chatSnapshot = await chatRef.get();

      if (chatSnapshot.exists) {
        Map<dynamic, dynamic> chats =
            chatSnapshot.value as Map<dynamic, dynamic>;
        List<Future> chatDeletions = [];

        chats.forEach((chatroomId, value) {
          if (chatroomId.toString().contains(Services.uid ?? "")) {
            chatDeletions.add(chatRef.child(chatroomId).remove());
          }
        });

        if (chatDeletions.isNotEmpty) {
          await Future.wait(chatDeletions);
        }
      }

      await batch.commit();

      await HiveHelper.removeUID();
      await HiveHelper.removeIsGuest();

      await FirebaseAuth.instance.currentUser?.delete();

      emit(DeleteProfileSuccessState());
    } catch (e) {
      print("Profile deletion error: ${e.toString()}");
      emit(DeleteProfileErrorState(errorMessage: e.toString()));
    }
  }

  void _createProfile(CreateProfileEvent event, Emitter emit) async {
    try {
      emit(CreateProfileLoadingState(isLoading: true));

      String uid = "";

      if (event.isEmailLogin) {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: event.userModel.email ?? "",
              password: event.password ?? "",
            );
        uid = userCredential.user?.uid ?? "";
      } else {
        uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      }
      final updatedUserModel = event.userModel.copyWith(uid: uid);
      await Collections.users.doc(uid).set(updatedUserModel.toJson());

      await HiveHelper.putUID(uid);

      emit(CreateProfileSuccessState());
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
              'zipCode': event.userModel.zipCode,
              'title': event.userModel.title,
              'firstName': event.userModel.firstName,
              'lastName': event.userModel.lastName,
              'email': event.userModel.email,
              'gender': event.userModel.gender,
              'dob': event.userModel.dob,
              'profileImage': event.userModel.profileImage,
            })
            .then((value) {
              add(ChangeLocale(languageCode: HiveHelper().getUserlanguage()));
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
