import 'package:diplom_main/Views/mainMenu.dart';
import 'package:diplom_main/auth/data/auth_repository_impl.dart';
import 'package:diplom_main/auth/data/firebase_auth_api.dart';
import 'package:diplom_main/auth/domain/auth_state/auth_cubit.dart';
import 'package:diplom_main/auth/ui/auth_screen.dart';
import 'package:diplom_main/auth/ui/register_screen.dart';
import 'package:diplom_main/auth/ui/user_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final applicationDocumentDir = await getApplicationDocumentsDirectory();

  HydratedBloc.storage =
  await HydratedStorage.build(storageDirectory: applicationDocumentDir);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  final api = AppFirebaseAuthApi();
  final authRepository = AuthRepositoryImpl(api);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const AuthScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),  // Главный экран (аутентификация)
        '/home': (context) => HomePage(),  // Домашний экран
        '/register': (context) => RegisterScreen(),  // Экран настроек
        '/profile': (context) => const UserScreen(),  // Экран настроек
      },
    );
  }
}
