import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';

part 'food_swap_event.dart';
part 'food_swap_state.dart';

class FoodSwapBloc extends Bloc<FoodSwapEvent, FoodSwapState> {
  FoodSwapBloc() : super(FoodSwapInitial()) {
    on<AddItemToFoodSwapEvent>(_addFoodToSwapList);
    on<UpdateItemInFoodSwapEvent>(_updateItemInFoodSwap);
    on<RemoveItemFromFoodSwapEvent>(_removeItemFromFoodSwap);
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
    }}
}
