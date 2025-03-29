import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';

part 'kitchen_manager_event.dart';
part 'kitchen_manager_state.dart';

class KitchenManagerBloc
    extends Bloc<KitchenManagerEvent, KitchenManagerState> {
  KitchenManagerBloc() : super(KitchenManagerInitial()) {
    on<AddNewItemEvent>(_addNewItem);
    on<RemoveItemEvent>(_removeItem);
  }

  // 🛒 Add New Item with optional ID
  Future<void> _addNewItem(
    AddNewItemEvent event,
    Emitter<KitchenManagerState> emit,
  ) async {
    try {
      emit(AddNewStateLoading(isLoading: true));

      // Use provided ID or generate a new one
      final itemId =
          event.item.id?.isNotEmpty == true
              ? event.item.id
              : Items.generateRandomId();

      final newItem = {
        'id': itemId,
        'name': event.item.name,
        'quantity': event.item.quantity,
        'category': event.item.category,
        'unit': event.item.unit,
        'expiredDate': event.item.expiredDate,
      };

      final userDocRef = Collections.users.doc(Services.uid);

      await Collections.firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (!userDoc.exists) {
          throw Exception("User not found");
        }

        // ✅ Parse the existing data properly
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<dynamic> kitchenItems = userData['kitchenItems'] ?? [];

        // Add the new item
        kitchenItems.add(newItem);

        // Update the item count
        final currentCount = userData['addedItemQuantityCount'] ?? 0;
        final newTotal = currentCount + event.item.quantity;

        // ✅ Update the Firestore document
        transaction.update(userDocRef, {
          'kitchenItems': kitchenItems,
          'addedItemQuantityCount': newTotal,
        });

        log("Item added: $newItem");
      });

      emit(AddNewStateSuccess());
    } catch (e) {
      log("Error adding item: $e");
      emit(AddNewStateError(errorMessage: e.toString()));
    }
  }

  // 🗑️ Remove Item
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

        // ✅ Remove the item by ID
        kitchenItems.removeWhere((item) => item['id'] == event.itemId);

        // Update the removed quantity count
        final currentQuantity = userData['noOfQuantityRemoved'] ?? 0;
        final newQuantity = currentQuantity + event.itemCount;

        // ✅ Update Firestore document
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
      log("Error removing item: $e");
      emit(RemoveItemStateError(errorMessage: e.toString()));
    }
  }
}
