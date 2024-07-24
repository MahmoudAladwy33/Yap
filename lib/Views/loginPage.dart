import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yap/Views/RegisterPage.dart';
import 'package:yap/Views/chat_page.dart';
import 'package:yap/Widgets/Custom_text_field.dart';
import 'package:yap/Widgets/Custom_button.dart';
import 'package:yap/Widgets/Google_button.dart';
import 'package:yap/helper/consts.dart';
import 'package:yap/helper/show_snack_bar.dart';
import 'package:yap/helper/success_snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = 'LoginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? Email;

  String? Password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Yap',
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: 50,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Connect easily with friends and family anytime, anywhere',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      'Sign in to continue!',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomFormTextField(
                  onChanged: (data) {
                    Email = data;
                  },
                  txt: 'Email',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFormTextField(
                  obscureText: true,
                  onChanged: (data) {
                    Password = data;
                  },
                  txt: 'Password',
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        successSnackBar(context);
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: Email);
                      } catch (e) {
                        showSnackBar(
                            context, 'The email or password is incorrect');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                  txt: 'Sign in',
                ),
                const SizedBox(
                  height: 15,
                ),
                GoogleButton(
                  txt: 'Sign in with Google',
                  onTap: () async {
                    try {
                      await signInWithGoogle();
                      successSnackBar(context);
                      Navigator.pushNamed(context, ChatPage.id,
                          arguments: 'id');
                    } catch (e) {
                      showSnackBar(context, 'Ther is an Error , try again');
                      log(e.toString());
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: Email!, password: Password!);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
