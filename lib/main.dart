import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:snowbill/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:snowbill/providers/snowball_provider.dart';
import 'package:snowbill/screens/sign_in_screen.dart';
import 'package:snowbill/screens/sign_up_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://xxxxxx.supabase.co',
      anonKey: 'xxxxxxx',
      debug: true // optional
      );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SnowballProvider()),
      ],
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/dashboard': (_) => const DashboardScreen(),
      },
    );
  }
}
