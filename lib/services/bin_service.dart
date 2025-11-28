import 'package:cloud_firestore/cloud_firestore.dart';

class BinService {
  final CollectionReference bins =
      FirebaseFirestore.instance.collection('bins');

  Future<void> addBin(String name, double lat, double lng) async {
    await bins.add({
      'name': name,
      'location': GeoPoint(lat, lng),
      'status': 'empty',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateBin(String id, String name, String status) async {
    await bins.doc(id).update({
      'name': name,
      'status': status,
    });
  }

  Future<void> deleteBin(String id) async {
    await bins.doc(id).delete();
  }

  Stream<QuerySnapshot> getBinsStream() {
    return bins.snapshots();
  }
}
