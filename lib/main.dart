import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yap/Views/RegisterPage.dart';
import 'package:yap/Views/chat_page.dart';
import 'package:yap/Views/cubits/auth_cubit/auth_cubit.dart';
import 'package:yap/Views/cubits/chat_cubit/chat_cubit.dart';
import 'package:yap/Views/loginPage.dart';
import 'package:yap/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Yap());
}

class Yap extends StatelessWidget {
  const Yap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        )
      ],
      child: MaterialApp(
        routes: {
          RegisterPage.id: (context) => const RegisterPage(),
          ChatPage.id: (context) => const ChatPage(),
          LoginPage.id: (context) => const LoginPage(),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.id,
      ),
    );
  }
}
