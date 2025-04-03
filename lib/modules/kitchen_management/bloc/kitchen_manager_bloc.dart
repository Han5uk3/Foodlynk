import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/kitchen_manager.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/storage_services.dart';

part 'kitchen_manager_event.dart';
part 'kitchen_manager_state.dart';

class KitchenManagerBloc
    extends Bloc<KitchenManagerEvent, KitchenManagerState> {
  KitchenManagerBloc() : super(KitchenManagerInitial()) {
    on<AddNewItemEvent>(_addNewItem);
    on<RemoveItemEvent>(_removeItem);
  }

  Future<void> _addNewItem(
    AddNewItemEvent event,
    Emitter<KitchenManagerState> emit,
  ) async {
    String? imageUrl;
    try {
      emit(AddNewStateLoading(isLoading: true));

      final itemId =
          event.item.id?.isNotEmpty == true
              ? event.item.id
              : Items.generateRandomId();
      if (event.imageFile?.path != null) {
        imageUrl = await StorageService.uploadFile(
          mainPath: 'kitchen-images',
          fileName: 'kitchen-images_$itemId',
          filePath: event.imageFile?.path ?? "",
          isDeleted: false,
        );
      }

      final newItem = {
        'id': itemId,
        'name': event.item.name,
        'quantity': event.item.quantity,
        'category': event.item.category,
        'unit': event.item.unit,
        'item_image': imageUrl ?? "",
        'expiredDate': event.item.expiredDate,
      };

      final userDocRef = Collections.users.doc(Services.uid);

      await Collections.firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (!userDoc.exists) {
          throw Exception("User not found");
        }

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> kitchenItems = userData['kitchenItems'] ?? [];
        kitchenItems.add(newItem);

        final currentCount = userData['addedItemQuantityCount'] ?? 0;
        final newTotal = currentCount + event.item.quantity;

        transaction.update(userDocRef, {
          'kitchenItems': kitchenItems,
          'addedItemQuantityCount': newTotal,
        });
      });

      emit(AddNewStateSuccess());
    } catch (e) {
      emit(AddNewStateError(errorMessage: e.toString()));
    }
  }

  Future<void> _removeItem(
    RemoveItemEvent event,
    Emitter<KitchenManagerState> emit,
  ) async {
    try {
      emit(RemoveItemStateLoading(isLoading: true));

      final userDocRef = Collections.users.doc(Services.uid);

      await Collections.firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (!userDoc.exists) {
          throw Exception("User not found");
        }

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> kitchenItems = userData['kitchenItems'] ?? [];
        final itemToRemove = kitchenItems.firstWhere(
          (item) => item['id'] == event.itemId,
          orElse: () => null,
        );
        kitchenItems.removeWhere((item) => item['id'] == event.itemId);
        int quantityToAdd = 0;
        if (itemToRemove != null) {
          final expiredDate = itemToRemove['expiredDate'];
          final item = Items(
            expiredDate: expiredDate,
            id: itemToRemove['id'],
            name: itemToRemove['name'] ?? '',
          );
          if (itemRemovedBeforeExpiry(item)) {
            quantityToAdd = event.itemCount;
          }
        }
        final currentQuantity = userData['noOfQuantityRemoved'] ?? 0;
        final newQuantity = currentQuantity + quantityToAdd;
        transaction.update(userDocRef, {
          'kitchenItems': kitchenItems,
          'noOfQuantityRemoved': newQuantity,
        });
      });
      emit(
        RemoveItemStateSuccess(
          insideParentPage: event.inSideParentPage ?? false,
        ),
      );
    } catch (e) {
      emit(RemoveItemStateError(errorMessage: e.toString()));
    }
  }
}
