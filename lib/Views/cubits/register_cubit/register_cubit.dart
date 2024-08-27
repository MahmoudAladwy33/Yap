import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

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
