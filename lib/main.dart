// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/user_model.dart'; // Import UserModel
import 'package:todo_list_app/pages/login_page.dart';
import 'package:todo_list_app/pages/main_screen.dart';
import 'package:todo_list_app/provider/auth_provider.dart';
import 'package:todo_list_app/provider/todo_provider.dart';

// Konstanta warna tetap sama
const Color kBackgroundColor = Color(0xFFF8F5F1);
const Color kPrimaryColor = Color(0xFF2D4059);
const Color kAccentColor = Color(0xFF4A90E2);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MultiProvider untuk mendaftarkan semua provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // GUNAKAN ChangeNotifierProxyProvider DI SINI
        // Ini membuat TodoProvider bergantung pada AuthProvider.
        // Berguna jika nanti tugas ingin dipisahkan per user.
        ChangeNotifierProxyProvider<AuthProvider, TodoProvider>(
          create: (_) => TodoProvider(),
          update:
              (_, auth, previousTodo) =>
                  previousTodo!..updateUser(auth.currentUser),
        ),
      ],
      // Bungkus MaterialApp dengan Consumer agar ia "mendengarkan" AuthProvider
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Helper function untuk mengubah string dari model menjadi enum ThemeMode
          ThemeMode getThemeMode(String? themeString) {
            switch (themeString) {
              case 'light':
                return ThemeMode.light;
              case 'dark':
                return ThemeMode.dark;
              default:
                return ThemeMode.system;
            }
          }

          return MaterialApp(
            title: 'TodoList App',
            // Tema terang
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: kBackgroundColor,
              primaryColor: kPrimaryColor,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: kPrimaryColor, // Warna teks utama
                displayColor: kPrimaryColor, // Warna teks judul besar
              ), // Warna teks judul besar
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: kPrimaryColor),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: kAccentColor,
              ),
            ),
            // Tema gelap
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              // Anda bisa kustomisasi warna tema gelap di sini
              scaffoldBackgroundColor: const Color(0xFF121212),
              primaryColor: Colors.tealAccent,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: Colors.white, // Warna teks utama
                displayColor: Colors.white, // Warna teks judul besar
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey.shade800,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.tealAccent,
              ),
            ),
            // TEMA DIPILIH SECARA DINAMIS DI SINI
            themeMode: getThemeMode(authProvider.currentUser?.themeMode),
            debugShowCheckedModeBanner: false,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

// Widget AuthWrapper tidak perlu diubah, sudah benar.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.currentUser != null) {
      return const MainScreen();
    } else {
      return const LoginPage();
    }
  }
}
