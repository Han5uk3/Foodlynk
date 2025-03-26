import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';

part 'food_swap_event.dart';
part 'food_swap_state.dart';

class FoodSwapBloc extends Bloc<FoodSwapEvent, FoodSwapState> {
  Random random = Random();
  FoodSwapBloc() : super(FoodSwapInitial()) {
    on<AddItemToFoodSwapEvent>(_addFoodToSwapList);
    on<UpdateItemInFoodSwapEvent>(_updateItemInFoodSwap);
    on<RemoveItemFromFoodSwapEvent>(_removeItemFromFoodSwap);
    on<AcceptFoodSwapEvent>(_acceptFoodSwap);
  }

  void _addFoodToSwapList(
    AddItemToFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(FoodSwapLoading(isLoading: true));
      String foodswapId = Collections.foodSwap.doc().id;
      final updatedItem = {
        ...event.item.toMap(),
        'id': foodswapId,
        'status': 'P',
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

  void _acceptFoodSwap(
    AcceptFoodSwapEvent event,
    Emitter<FoodSwapState> emit,
  ) async {
    try {
      emit(AcceptFoodSwapLoadingState(isLoading: true));

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
              emit(AcceptFoodSwapSuccessState());
            })
            .onError((error, stackTrace) {
              emit(AcceptFoodSwapError(errorMessage: error.toString()));
            });
      } else {
        emit(AcceptFoodSwapError(errorMessage: "Document does not exist."));
      }
    } catch (e) {
      emit(AcceptFoodSwapError(errorMessage: e.toString()));
    }
  }
}
