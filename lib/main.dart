import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/firebase_options.dart';
import 'package:todos/todos_screen.dart';

final _auth = FirebaseAuth.instance;

final GoRouter _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) => snapshot.hasData
          ? const TodosScreen()
          : Scaffold(
            body: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.login,
                    size: 72,
                  ),
                  onPressed: () async => await _auth.signInAnonymously(),
                ),
              ),
          ),
    ),
  ),
]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
