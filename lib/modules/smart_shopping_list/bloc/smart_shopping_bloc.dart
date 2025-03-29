import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';

part 'smart_shopping_event.dart';
part 'smart_shopping_state.dart';

class SmartShoppingBloc extends Bloc<SmartShoppingEvent, SmartShoppingState> {
  final BuildContext context;
  SmartShoppingBloc(this.context) : super(SmartShoppingInitial()) {
    on<CreateNewSmartShoppingEvent>(_createNewSmartShoppingList);
    on<AddNewItemSmartShoppingEvent>(_addNewItemSmartShoppingList);
    on<MarkAsPurchasedSmartShoppingEvent>(_markAsPurchasedSmartShoppingList);
  }

  void _createNewSmartShoppingList(
    CreateNewSmartShoppingEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(CreateNewSmartShoppingListLoadingState());
      final listId = Collections.smartShopping.doc().id;
      await Collections.smartShopping
          .doc(listId)
          .set({
            'listId': listId,
            'listName': event.listName,
            'items': [],
            'createdAt': DateTime.now(),
            'uid': Services.uid,
          })
          .then((value) {
            emit(CreateNewSmartShoppingListSuccessState());
          })
          .catchError((e) {
            emit(
              CreateNewSmartShoppingListFailureState(
                errorMessage: e.toString(),
              ),
            );
          });
    } catch (e) {
      emit(CreateNewSmartShoppingListFailureState(errorMessage: e.toString()));
    }
  }

  void _addNewItemSmartShoppingList(
    AddNewItemSmartShoppingEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(NewItemAddedToListLoadingState());

      var docSnapshot = await Collections.smartShopping.doc(event.listId).get();
      log(docSnapshot.data().toString());
      if (!docSnapshot.exists) {
        emit(NewItemAddedToListFailureState(errorMessage: "List not found."));
        return;
      }
      List<dynamic> currentItems =
          ((docSnapshot.data() as Map<String, dynamic>?)?['items'] ?? [])
              as List<dynamic>;

      var newItem =
          Items(
            id: Items.generateRandomId(),
            name: event.itemName,
            unit: event.itemUnit,
            quantity: event.itemQuantity,
            status: 'AL',
          ).toMap();
      currentItems.add(newItem);
      await Collections.smartShopping.doc(event.listId).update({
        'items': currentItems,
      });
      emit(NewItemAddedToListSuccessState());
    } catch (e) {
      emit(NewItemAddedToListFailureState(errorMessage: e.toString()));
    }
  }

  void _markAsPurchasedSmartShoppingList(
    MarkAsPurchasedSmartShoppingEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(PurchasedItemLoadingState());
      var docSnapshot = await Collections.smartShopping.doc(event.listId).get();
      List<dynamic> currentItems =
          ((docSnapshot.data() as Map<String, dynamic>?)?['items'] ?? [])
              as List<dynamic>;
      bool isItemFound = false;
      for (var i = 0; i < currentItems.length; i++) {
        if (currentItems[i]['id'] == event.item.id) {
          currentItems[i]['status'] = 'PR';
          isItemFound = true;
          break;
        }
      }
      await Collections.smartShopping.doc(event.listId).update({
        'items': currentItems,
      });

      emit(PurchasedItemSuccessState(item: event.item));
      context.read<KitchenManagerBloc>().add(AddNewItemEvent(item: event.item));
    } catch (e) {
      emit(PurchasedItemFailureState(errorMessage: e.toString()));
    }
  }
}
