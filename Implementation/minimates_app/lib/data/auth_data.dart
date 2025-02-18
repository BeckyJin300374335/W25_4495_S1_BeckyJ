import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/data/firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
  Future<void> logout();
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  Future<void> register(
      String email, String password, String passwordConfirm) async {
    if (passwordConfirm == password) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        Firestore().createUser(email.trim());
      });
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
