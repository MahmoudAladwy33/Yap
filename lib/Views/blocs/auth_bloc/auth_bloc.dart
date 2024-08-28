import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is RegisterEvent) {
        emit(RegisterLoading());
        try {
          var auth = FirebaseAuth.instance;
          UserCredential user = await auth.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
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
    });
  }
}
