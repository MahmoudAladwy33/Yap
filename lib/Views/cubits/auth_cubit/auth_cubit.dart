import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());

    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(errMessage: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(LoginFailure(errMessage: "Sign in aborted by user"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(errMessage: e.toString()));
    }
  }

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      var auth = FirebaseAuth.instance;
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        emit(RegisterFailure(errMessage: 'The password is week.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'The account already exist'));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: e.toString()));
    }
  }
}
