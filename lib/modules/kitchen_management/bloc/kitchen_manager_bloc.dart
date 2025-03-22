import 'dart:developer';

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
      log(e.toString());
      emit(AddNewStateError(errorMessage: e.toString()));
    }
  }
}
