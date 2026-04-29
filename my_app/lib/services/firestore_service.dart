import "package:cloud_firestore/cloud_firestore.dart";

// handles all Firestore interactions for the app
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // creates a new item document in Firestore
  Future<void> createItem(Map<String, dynamic> data) async {
    await _db.collection("items").add(data);
  }

  // fetches all items from Firestore
  Stream<QuerySnapshot> getItems() {
    return _db.collection("items").snapshots();
  }

  // updates an existing item document
  Future<void> updateItem(String id, Map<String, dynamic> data) async {
    await _db.collection("items").doc(id).update(data);
  }

  // deletes an item document
  Future<void> deleteItem(String id) async {
    await _db.collection("items").doc(id).delete();
  }
}