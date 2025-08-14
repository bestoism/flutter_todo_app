// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/models/user_model.dart'; 
import 'package:todo_list_app/pages/login_page.dart';
import 'package:todo_list_app/pages/main_screen.dart';
import 'package:todo_list_app/provider/auth_provider.dart';
import 'package:todo_list_app/provider/todo_provider.dart';


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
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        ChangeNotifierProxyProvider<AuthProvider, TodoProvider>(
          create: (_) => TodoProvider(),
          update:
              (_, auth, previousTodo) =>
                  previousTodo!..updateUser(auth.currentUser),
        ),
      ],
      
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          
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
                bodyColor: kPrimaryColor, 
                displayColor: kPrimaryColor, 
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
              
              scaffoldBackgroundColor: const Color(0xFF121212),
              primaryColor: Colors.tealAccent,
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
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
            
            themeMode: getThemeMode(authProvider.currentUser?.themeMode),
            debugShowCheckedModeBanner: false,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}


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
