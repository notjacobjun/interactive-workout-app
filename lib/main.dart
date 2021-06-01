import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interactive_workout_app/screens/awards_screen.dart';
import 'package:interactive_workout_app/screens/settings_screen.dart';
import 'package:interactive_workout_app/screens/social_screen.dart';
import 'package:interactive_workout_app/screens/workout_categories_screen.dart';
import 'package:interactive_workout_app/screens/home_screen.dart';
import 'package:interactive_workout_app/screens/login_screen.dart';
import 'package:interactive_workout_app/screens/registration_screen.dart';
import 'package:interactive_workout_app/screens/welcome_screen.dart';
import 'package:interactive_workout_app/services/authentication_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Flow Fitness',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.orange.shade900,
          accentColor: Colors.black,
          textTheme: TextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              decorationColor: Colors.white),
          fontFamily: "Quicksand",
        ),
        routes: {
          '/': (ctx) => AuthenticationWrapper(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          WorkoutCategoriesScreen.routeName: (ctx) => WorkoutCategoriesScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
          AwardsScreen.routeName: (ctx) => AwardsScreen(),
          SocialScreen.routeName: (ctx) => SocialScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // checks if a user is already logged in
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return HomeScreen();
    } else {
      return WelcomeScreen();
    }
  }
}