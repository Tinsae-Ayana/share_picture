import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;

  uploadDate({required data, required collectionName, String? docName}) async {
    final docRef = _firestore.collection(collectionName).doc(docName);
    if (docName == null) {
      data['id'] = docRef.id;
    }
    await docRef.set(data);
  }

  upLoadDataSub(
      {required data,
      required collectionName,
      required subCollectionName,
      required docName}) async {
    final ref = _firestore
        .collection(collectionName)
        .doc(docName)
        .collection(subCollectionName)
        .doc();
    data['id'] = ref.id;
    await ref.set(data);
  }

  Future<Map<String, dynamic>?> getDataFromFire(
      {required collectionName, required docName}) async {
    final snapshot =
        await _firestore.collection(collectionName).doc(docName).get();
    return snapshot.data();
  }

  Future<List<Map<String, dynamic>>> getDataFromFireBycontent(
      {required collectionName, required lookingFor, required field}) async {
    final snap = await _firestore
        .collection(collectionName)
        .where(field, isEqualTo: lookingFor)
        .get();
    return snap.docs.map((e) => e.data()).toList();
  }

  Stream<Map<String, dynamic>> getDataFromADocumentinStream(
      {required docName, required collectionName}) {
    return _firestore
        .collection(collectionName)
        .doc(docName)
        .snapshots()
        .map((event) => event.data()!);
  }

  Stream<List<Map<String, dynamic>>> getRealTimeData(
      {required collectionName}) {
    return _firestore
        .collection(collectionName)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getRealTimeDataSub(
      {required collectionName, required subCollectionName, required docName}) {
    return _firestore
        .collection(collectionName)
        .doc(docName)
        .collection(subCollectionName)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  updataListValuesinFirebase(
      {required collectionName,
      required docName,
      required uid,
      required field,
      required isAdding}) async {
    if (isAdding) {
      await _firestore.collection(collectionName).doc(docName).update({
        field: FieldValue.arrayUnion([uid])
      });
    } else {
      await _firestore.collection(collectionName).doc(docName).update({
        field: FieldValue.arrayRemove([uid])
      });
    }
  }

  updateListValueInSub(
      {required collectionName,
      required docName,
      required subCollection,
      required docId,
      required field,
      required value,
      required isAdding}) async {
    if (isAdding) {
      _firestore
          .collection(collectionName)
          .doc(docName)
          .collection(subCollection)
          .doc(docId)
          .update({
        field: FieldValue.arrayUnion([value])
      });
    } else {
      _firestore
          .collection(collectionName)
          .doc(docName)
          .collection(subCollection)
          .doc(docId)
          .update({
        field: FieldValue.arrayRemove([value])
      });
    }
  }

  deleteDataInFirebase({required docId, required collectionName}) {
    _firestore.collection(collectionName).doc(docId).delete();
  }
}
