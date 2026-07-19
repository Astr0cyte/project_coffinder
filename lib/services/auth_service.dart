// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   AuthService._();
//   static final AuthService instance = AuthService._();
//
//   final _auth = FirebaseAuth.instance;
//
//   User? get currentUser => _auth.currentUser;
//
//   bool get isGuest => _auth.currentUser?.isAnonymous ?? true;
//
//   Future<UserCredential> signIn(String email, String password) =>
//       _auth.signInWithEmailAndPassword(email: email, password: password);
//
//   Future<UserCredential> signInAsGuest() => _auth.signInAnonymously();
//
//   Future<UserCredential> register({
//     required String email,
//     required String password,
//     required String displayName,
//   }) async {
//     final cred = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     await cred.user?.updateDisplayName(displayName);
//     return cred;
//   }
//
//   Future<void> signOut() => _auth.signOut();
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isGuest => _auth.currentUser?.isAnonymous ?? true;

  Future<UserCredential> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );


    await UserService.instance.createUserIfNotExists(
      uid: cred.user!.uid,
      email: cred.user!.email ?? email,
      userName: cred.user!.displayName ?? '',
    );

    return cred;
  }

  Future<UserCredential> signInAsGuest() => _auth.signInAnonymously();

  Future<UserCredential> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(displayName);


    await UserService.instance.createUserIfNotExists(
      uid: cred.user!.uid,
      email: email,
      userName: displayName,
    );

    return cred;
  }

  Future<void> signOut() => _auth.signOut();
}