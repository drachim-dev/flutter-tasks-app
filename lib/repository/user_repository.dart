import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> loginAnonymously();

  Future<UserEntity> loginViaGoogle();

  Future<void> logout();
}

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  const FirebaseUserRepository(this.auth, this.googleSignIn);

  @override
  Future<UserEntity> loginAnonymously() async {
    final FirebaseUser firebaseUser = await auth.signInAnonymously();

    return UserEntity(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }

  @override
  Future<UserEntity> loginViaGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser = await auth.signInWithCredential(credential);

    return UserEntity(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }
}
