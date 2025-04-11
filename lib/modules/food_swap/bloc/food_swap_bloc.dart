import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

part 'food_swap_event.dart';
part 'food_swap_state.dart';

class FoodSwapBloc extends Bloc<FoodSwapEvent, FoodSwapState> {
  Random random = Random();
  FoodSwapBloc() : super(FoodSwapInitial()) {
    on<AddItemToFoodSwapEvent>(_addFoodToSwapList);
    on<UpdateItemInFoodSwapEvent>(_updateItemInFoodSwap);
    on<RemoveItemFromFoodSwapEvent>(_removeItemFromFoodSwap);
    on<RequestFoodSwapEvent>(_requestFoodSwap);
    on<AcceptedFoodSwapRequestEvent>(_acceptedFoodSwapRequest);
    on<DeclineFoodSwapEvent>(_declineFoodSwap);
  }

  void _addFoodToSwapList(
    AddItemToFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(FoodSwapLoading(isLoading: true));
      String? imageUrl;
      String foodswapId = Collections.foodSwap.doc().id;
      if (event.imageFile != null) {
        imageUrl = await StorageService.uploadFile(
          filePath: event.imageFile!.path,
          fileName:
              "swap_item_$foodswapId${DateTime.now().millisecondsSinceEpoch}",
        );
      }
      final updatedItem = {
        ...event.item.toMap(),
        'id': foodswapId,
        'status': 'P',
        'item_image': imageUrl,
        'uid': HiveHelper.getUID(),
      };
      await Collections.foodSwap
          .doc(foodswapId)
          .set(updatedItem)
          .then((value) {
            emit(FoodSwapSuccess());
          })
          .onError((error, stackTrace) {
            emit(FoodSwapError(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(FoodSwapError(errorMessage: e.toString()));
    }
  }

  void _updateItemInFoodSwap(
    UpdateItemInFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(FoodSwapLoading(isLoading: true));
      await Collections.foodSwap
          .doc(event.item.id)
          .update(event.item.toMap())
          .then((value) {
            emit(FoodSwapUpdateSuccessState());
          })
          .onError((error, stackTrace) {
            emit(FoodSwapUpdateError(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(FoodSwapUpdateError(errorMessage: e.toString()));
    }
  }

  void _removeItemFromFoodSwap(
    RemoveItemFromFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(DeleteFromFoodSwapLoadingState(isLoading: true));
      await Collections.foodSwap
          .doc(event.swapId)
          .delete()
          .then((value) {
            emit(DeleteFromFoodSwapSuccessState());
          })
          .onError((error, stackTrace) {
            emit(DeleteFromFoodSwapError(errorMessage: error.toString()));
          });
    } catch (e) {
      emit(DeleteFromFoodSwapError(errorMessage: e.toString()));
    }
  }

  void _acceptedFoodSwapRequest(
    AcceptedFoodSwapRequestEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    emit(RequestAcceptedLoadingState(isLoading: true));
    try {
      await Collections.foodSwap.doc(event.acceptedSwapItemId).update({
        'status': 'A',
      });
      await Collections.foodSwap.doc(event.swapId).update({'status': 'A'}).then(
        (value) {
          event.communityBloc?.add(
            InitializeChatRoomEvent(
              receiverUid: event.reciverUid,
              fcmToken: event.fcmToken,
              isFoodSwapped: true,
              isFromDonations: false,
              context: event.context
            ),
          );
        },
      );
    } catch (e) {
      emit(RequestAcceptedError(errorMessage: e.toString()));
    }
    emit(RequestAcceptedLoadingState(isLoading: false));
  }

  void _requestFoodSwap(
    RequestFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(RequestFoodSwapLoadingState(isLoading: true));

      final docSnapshot = await Collections.foodSwap.doc(event.swapId).get();

      if (docSnapshot.exists) {
        final currentRequests = List<Map<String, dynamic>>.from(
          ((docSnapshot.data() as Map<String, dynamic>?)?['requests']
                  as List<dynamic>? ??
              []),
        );

        final newRequest = {
          'reqId': random.nextInt(10000),
          'uid': event.uid ?? "",
          'swapedItemId': event.swapId ?? "",
          'acceptedSwapItemId': event.acceptedSwapItemId ?? '',
          'acceptedSwapItem': event.acceptedSwapItem ?? "",
          'pickupLocation': event.pickupLocation ?? "",
          'pickupDate': event.pickupDate?.toIso8601String() ?? "",
          'pickupTime': event.pickupTime?.toIso8601String() ?? "",
          'timestamp': DateTime.now().toIso8601String(),
        };

        currentRequests.add(newRequest);

        await Collections.foodSwap
            .doc(event.swapId)
            .update({'requests': currentRequests})
            .then((_) {
              emit(RequestFoodSwapSuccessState());
            })
            .onError((error, stackTrace) {
              emit(RequestFoodSwapError(errorMessage: error.toString()));
            });
      } else {
        emit(RequestFoodSwapError(errorMessage: "Document does not exist."));
      }
    } catch (e) {
      emit(RequestFoodSwapError(errorMessage: e.toString()));
    }
  }

  void _declineFoodSwap(
    DeclineFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    emit(FoodSwapRequestDeclinedLoadingState());
    try {
      final docRef = Collections.foodSwap.doc(event.swapId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> requestList = data['requests'] ?? [];
        requestList.removeWhere((req) => req['reqId'] == event.reqId);
        await docRef.update({'requests': requestList});
        emit(FoodSwapRequestDeclainedSuccessState());
      } else {
        emit(
          FoodSwapRequestDeclinedError(
            errorMessage: "Document does not exist.",
          ),
        );
      }
    } catch (e) {
      emit(FoodSwapRequestDeclinedError(errorMessage: e.toString()));
    }
  }
}
