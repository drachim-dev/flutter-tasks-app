import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> loginAnonymously();
  Future<UserEntity> loginViaGoogle();

  Future<UserEntity> getCurrentUser();
  Future<void> logout();
}

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  const FirebaseUserRepository(this.auth, this.googleSignIn);

  @override
  Future<UserEntity> loginAnonymously() async {
    final AuthResult authResult = await auth.signInAnonymously();
    return UserEntity.fromFirebaseUser(authResult.user);
  }

  @override
  Future<UserEntity> loginViaGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await auth.signInWithCredential(credential);
    return UserEntity.fromFirebaseUser(authResult.user);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final FirebaseUser firebaseUser = await auth.currentUser();
    return UserEntity.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }
}
