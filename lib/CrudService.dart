import 'package:cloud_firestore/cloud_firestore.dart';

class CrudService {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    'items',
  );

  // CREATE
  Future<void> addItem(String name, String quantity) async {
    await items.add({
      'name': name,
      'quantity': quantity,
      'favorite': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // READ
  Stream<QuerySnapshot> getItems() {
    return items.orderBy('createdAt', descending: true).snapshots();
  }

  // UPDATE
  Future<void> updateItem(String id, String name, String quantity) async {
    await items.doc(id).update({'name': name, 'quantity': quantity});
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    await items.doc(id).delete();
  }

  // FAVORITES
  Future<void> toggleFavorite(String id, bool favorite) async {
    await items.doc(id).update({'favorite': !favorite});
  }
}