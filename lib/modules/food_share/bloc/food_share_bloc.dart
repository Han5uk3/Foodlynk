import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

part 'food_share_event.dart';
part 'food_share_state.dart';

class FoodShareBloc extends Bloc<FoodShareEvent, FoodShareState> {
  FoodShareBloc() : super(FoodShareInitial()) {
    on<AddNewFoodDonationEvent>(_onAddNewFoodDonationEvent);
    on<AddNewBaneficiaryEvent>(_onAddNewBaneficiaryEvent);
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
}
