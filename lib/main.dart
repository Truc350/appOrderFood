import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD81F19)),
      ),
      // Thêm FutureBuilder để check session
      // Nếu đã login trước đó → vào thẳng HomePage
      // Nếu chưa → về LoginScreen như cũ
      home: FutureBuilder<bool>(
        future: AuthService.instance.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFD81F19)),
              ),
            );
          }
          if (snapshot.data == true) {
            return const HomePage();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}