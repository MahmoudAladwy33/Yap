import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:yap/Views/RegisterPage.dart';
import 'package:yap/Views/chat_page.dart';
import 'package:yap/Views/cubits/auth_cubit/auth_cubit.dart';
import 'package:yap/Views/cubits/chat_cubit/chat_cubit.dart';
import 'package:yap/Widgets/Custom_text_field.dart';
import 'package:yap/Widgets/Custom_button.dart';
import 'package:yap/Widgets/Google_button.dart';
import 'package:yap/helper/consts.dart';
import 'package:yap/helper/show_snack_bar.dart';
import 'package:yap/helper/success_snack_bar.dart';

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessage();
          Navigator.pushNamed(context, ChatPage.id, arguments: Email);
          isLoading = false;
          successSnackBar(context);
        } else if (state is LoginFailure) {
          isLoading = false;
          showSnackBar(context, 'The email or password is incorrect');
        }
      },
      builder: (context, state) => ModalProgressHUD(
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
                        BlocProvider.of<AuthCubit>(context)
                            .loginUser(email: Email!, password: Password!);
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
                      BlocProvider.of<AuthCubit>(context).signInWithGoogle();
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
      ),
    );
  }
}
