import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch All Smart Bins
  Stream<QuerySnapshot> getAllBins() {
    return _db.collection('bins').snapshots();
  }

  // Fetch Notifications for Admin
  Stream<QuerySnapshot> getNotifications() {
    return _db.collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Fetch User Profile
  Stream<DocumentSnapshot> getUserProfile() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).snapshots();
  }
}
