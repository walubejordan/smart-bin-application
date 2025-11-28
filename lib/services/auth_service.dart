import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Create Firestore document with default role 'user'
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': 'user',
      });
    } catch (e) {
      print("Error registering user: $e");
      rethrow;
    }
  }
}
