import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';

part 'kitchen_manager_event.dart';
part 'kitchen_manager_state.dart';

class KitchenManagerBloc
    extends Bloc<KitchenManagerEvent, KitchenManagerState> {
  KitchenManagerBloc() : super(KitchenManagerInitial()) {
    on<AddNewItemEvent>(_addNewItem);
    on<RemoveItemEvent>(_removeItem);
  }

  void _addNewItem(
    AddNewItemEvent event,
    Emitter<KitchenManagerState> emit,
  ) async {
    try {
      emit(AddNewStateLoading(isLoading: true));
      final newItem = {
        'name': event.itemName,
        'quantity': event.quantity,
        'category': event.category,
        'unit': event.unitName,
        'expiredDate': event.expiredDate.toIso8601String(),
      };
      bool isAdded = await AppApis().createNewItem(
        newItem,
        HiveHelper.getUID(),
      );
      if (isAdded) {
        emit(AddNewStateSuccess());
      } else {
        emit(AddNewStateError(errorMessage: "You can't add new Item."));
      }
    } catch (e) {
      emit(AddNewStateError(errorMessage: e.toString()));
    }
  }

  void _removeItem(
    RemoveItemEvent event,
    Emitter<KitchenManagerState> emit,
  ) async {
    try {
      emit(RemoveItemStateLoading(isLoading: true));
      bool isRemoved = await AppApis().removeItem(
        HiveHelper.getUID(),
        event.itemId,
        event.beforeExpiry,
        event.itemCount,
      );
      if (isRemoved) {
        emit(RemoveItemStateSuccess());
      } else {
        emit(RemoveItemStateError(errorMessage: "You can't remove this Item."));
      }
    } catch (e) {
      emit(RemoveItemStateError(errorMessage: e.toString()));
    }
  }
}
