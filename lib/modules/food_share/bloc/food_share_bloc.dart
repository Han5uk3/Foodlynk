import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

part 'food_share_event.dart';
part 'food_share_state.dart';

class FoodShareBloc extends Bloc<FoodShareEvent, FoodShareState> {
  FoodShareBloc() : super(FoodShareInitial()) {
    on<AddNewFoodDonationEvent>(_onAddNewFoodDonationEvent);
    on<AddNewBaneficiaryEvent>(_onAddNewBaneficiaryEvent);
    on<IntrestedFoodShareEvent>(_intrestedFoodShareEvent);
    on<AcceptFoodShareRequest>(_onAcceptFoodShareRequest);
  }
  void _onAddNewFoodDonationEvent(
    AddNewFoodDonationEvent event,
    Emitter<FoodShareState> emit,
  ) async {
    try {
      emit(NewDonationLoadingState());
      String? imageURL;
      String donationId = Collections.donations.doc().id;
      if ((event.model.image?.isNotEmpty ?? false) ||
          event.model.image != null) {
        imageURL = await StorageService.uploadFile(
          filePath: event.model.image ?? "",
          fileName: "food_share_$donationId",
        );
      }
      DonationModel donation = DonationModel(
        id: donationId,
        foodName: event.model.foodName,
        image: imageURL,
        foodType: event.model.foodType,
        noOfServe: event.model.noOfServe,
        discription: event.model.discription,
        pickUpLocation: event.model.pickUpLocation,
        isAccpected: event.model.isAccpected,
        raisedBy: event.model.raisedBy,
        status: "P",
        type: "DONR",
        expiredDate: event.model.expiredDate,
        createdAt: DateTime.now(),
      );
      await Collections.donations
          .doc(donationId)
          .set(donation.toMap())
          .then((value) {
            emit(NewDonationSuccessState());
          })
          .onError((error, stackTrace) {
            emit(NewDonationFailedState(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(NewDonationFailedState(errorMessage: e.toString()));
    }
  }

  void _onAddNewBaneficiaryEvent(
    AddNewBaneficiaryEvent event,
    Emitter<FoodShareState> emit,
  ) async {
    emit(NewBenificiaryLoadingState());
    try {
      String? imageURL;
      String benificiaryId = Collections.donations.doc().id;
      if ((event.model.image?.isNotEmpty ?? false) ||
          event.model.image != null) {
        imageURL = await StorageService.uploadFile(
          filePath: event.model.image ?? "",
          fileName: "food_share_$benificiaryId",
        );
      }
      final benificiaryAdded = {
        'id': benificiaryId,
        'raisedBy': Services.uid,
        'foodType': event.model.foodType,
        'pickUpLocation': event.model.pickUpLocation,
        'status': 'P',
        'type': 'BENF',
        'contactName': event.model.contactName,
        'contactMobile': event.model.contactMobile,
        'contactContryCode': event.model.contactContryCode,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      };
      await Collections.donations
          .doc(benificiaryId)
          .set(benificiaryAdded)
          .then((value) {
            emit(NewBenificiarySuccessState());
          })
          .catchError((error) {
            emit(NewBenificiaryFailedState(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(NewBenificiaryFailedState(errorMessage: e.toString()));
    }
  }

  void _intrestedFoodShareEvent(
    IntrestedFoodShareEvent event,
    Emitter<FoodShareState> emit,
  ) async {
    try {
      // Check if this is adding or removing interest
      if (event.isInterested) {
        // Add interest
        final newRequest = {
          'foodItemId': event.id,
          'raisedUid': Services.uid,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await Collections.donations
            .doc(event.id)
            .update({
              'request': FieldValue.arrayUnion([newRequest]),
            })
            .then((_) {
              emit(
                RequestAddedSuccessState(isIntrested: true, itemId: event.id),
              );
            })
            .catchError((e) {
              emit(
                RequestAddedFailedState(
                  errorMessage: e.toString(),
                  itemId: event.id,
                ),
              );
            });
      } else {
        // Remove interest - need to fetch the current request first to get exact object to remove
        DocumentSnapshot doc = await Collections.donations.doc(event.id).get();

        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          List<dynamic> requests = data['request'] ?? [];

          // Find the request from this user
          Map<String, dynamic>? userRequest;
          for (var request in requests) {
            if (request['raisedUid'] == Services.uid) {
              userRequest = Map<String, dynamic>.from(request);
              break;
            }
          }

          if (userRequest != null) {
            // Remove the interest
            await Collections.donations
                .doc(event.id)
                .update({
                  'request': FieldValue.arrayRemove([userRequest]),
                })
                .then((_) {
                  emit(
                    RequestAddedSuccessState(
                      isIntrested: false,
                      itemId: event.id,
                    ),
                  );
                })
                .catchError((e) {
                  emit(
                    RequestAddedFailedState(
                      errorMessage: e.toString(),
                      itemId: event.id,
                    ),
                  );
                });
          } else {
            emit(
              RequestAddedFailedState(
                errorMessage: "Interest not found",
                itemId: event.id,
              ),
            );
          }
        } else {
          emit(
            RequestAddedFailedState(
              errorMessage: "Donation not found",
              itemId: event.id,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        RequestAddedFailedState(errorMessage: e.toString(), itemId: event.id),
      );
    }
  }

  void _onAcceptFoodShareRequest(
    AcceptFoodShareRequest event,
    Emitter<FoodShareState> emit,
  ) async {
    try {
      emit(AcceptRequestLoadingState());
      await Collections.donations
          .doc(event.reqId)
          .update({'status': 'A'})
          .then((value) {
            event.communityBloc?.add(
              InitializeChatRoomEvent(
                receiverUid: event.reciverUid,
                fcmToken: event.fcmToken,
                isFoodSwapped: false,
                isFoodShare: true,
              ),
            );
          })
          .onError((error, stackTrace) {
            emit(AcceptRequestFailedState(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(AcceptRequestFailedState(errorMessage: e.toString()));
    }
  }
}
