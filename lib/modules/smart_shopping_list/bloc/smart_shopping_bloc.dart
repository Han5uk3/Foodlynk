import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

part 'smart_shopping_event.dart';
part 'smart_shopping_state.dart';

class SmartShoppingBloc extends Bloc<SmartShoppingEvent, SmartShoppingState> {
  final BuildContext context;
  SmartShoppingBloc(this.context) : super(SmartShoppingInitial()) {
    on<CreateNewSmartShoppingEvent>(_createNewSmartShoppingList);
    on<AddNewItemSmartShoppingEvent>(_addNewItemSmartShoppingList);
    on<MarkAsPurchasedSmartShoppingEvent>(_markAsPurchasedSmartShoppingList);
    on<MoveFromKitchenToSmartListEvent>(_moveToSmartShoppingList);
    on<UpdateSmartShopingListNameEvent>(_chnageNewListName);
    on<RemoveItemSmartShoppingEvent>(_removeItemSmartShoppingList);
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
      String? imageUrl;
      if (event.image != null) {
        imageUrl = await StorageService.uploadFile(
          filePath: event.image?.path ?? "",
          fileName: "smart_shopping_${event.item.id}",
        );
      }
      final updatedItem =
         imageUrl != null ? event.item.copyWith(image: imageUrl) : event.item;
      final docRef = Collections.smartShopping.doc(event.listId);
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() as Map<String, dynamic>?;
      final currentItems =
          (data!['items'] as List<dynamic>).map((item) {
            if (item['id'] == event.item.id) {
              return {
                ...item,
                'status': 'PR',
                if (imageUrl != null) 'item_image': imageUrl,
              };
            }
            return item;
          }).toList();
      await docRef.update({'items': currentItems});
      emit(PurchasedItemSuccessState(item: updatedItem));
      context.read<KitchenManagerBloc>().add(
        AddNewItemEvent(item: updatedItem, imageFile: event.image),
      );
    } catch (e) {
      log("Error in markAsPurchased: $e");
      emit(PurchasedItemFailureState(errorMessage: e.toString()));
    }
  }

  void _moveToSmartShoppingList(
    MoveFromKitchenToSmartListEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(MovingItemLoadingState());

      var docSnapshot = await Collections.smartShopping.doc(event.listId).get();
      if (docSnapshot.exists) {
        List<dynamic> currentItems =
            ((docSnapshot.data() as Map<String, dynamic>?)?['items'] ?? [])
                as List<dynamic>;
        var newItem = {
          'id': Items.generateRandomId(),
          'name': event.item.name,
          'quantity': event.item.quantity,
          'unit': event.item.unit,
          'status': 'AL',
        };
        currentItems.add(newItem);
        await Collections.smartShopping.doc(event.listId).update({
          'items': currentItems,
        });
        emit(MovingItemSuccessState(isFromParentSide: event.isFromParentSide));
      }
    } catch (e) {
      emit(MovingItemFailureState(errorMessage: e.toString()));
    }
  }

  void _chnageNewListName(
    UpdateSmartShopingListNameEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(ListNameChangedLoadingState());
      await Collections.smartShopping.doc(event.listId).update({
        'listName': event.newName,
      });
      emit(ListNameChangedSuccessState(listnewName: event.newName));
    } catch (e) {
      emit(ListNameChangedFailureState(errorMessage: e.toString()));
    }
  }

  void _removeItemSmartShoppingList(
    RemoveItemSmartShoppingEvent event,
    Emitter<SmartShoppingState> emit,
  ) async {
    try {
      emit(RemoveItemFromSmartListLoadingState());
      var docSnapshot = await Collections.smartShopping.doc(event.listId).get();
      List<dynamic> currentItems =
          ((docSnapshot.data() as Map<String, dynamic>?)?['items'] ?? [])
              as List<dynamic>;
      for (var i = 0; i < currentItems.length; i++) {
        if (currentItems[i]['id'] == event.itemId) {
          currentItems.removeAt(i);
          break;
        }
      }
      await Collections.smartShopping.doc(event.listId).update({
        'items': currentItems,
      });
      emit(RemoveItemFromSmartListSuccessState());
    } catch (e) {
      emit(RemoveItemFromSmartListFailureState(errorMessage: e.toString()));
    }
  }
}
