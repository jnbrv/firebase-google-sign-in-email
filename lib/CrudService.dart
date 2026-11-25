import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CrudService {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    'items',
  );

  // CLOUDINARY CONFIGURATION
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'kd6tzxro',
    'flutter_unsigned',
    cache: false,
  );

  // UPLOAD IMAGE TO CLOUDINARY
  Future<String> uploadImage(XFile image) async {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        image.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  // CREATE
  Future<void> addItem(String name, String quantity, {String? imageUrl}) async {
    await items.add({
      'name': name,
      'quantity': quantity,
      'imageUrl': imageUrl,
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
