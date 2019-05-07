import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseUser user;
  static FirebaseStorage storage;
  static DocumentSnapshot currentSnapshot;
  static String defaultImgUrl = 'https://firebasestorage.googleapis.com/v0/b/mallapp-project.appspot.com/o/default_img.jpg?alt=media&token=64e2fd87-6655-421b-bfd4-bd247d197f6a';

  AuthService();
}
