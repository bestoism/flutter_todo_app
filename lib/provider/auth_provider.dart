// Lokasi: lib/provider/auth_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  // State
  final List<UserModel> _users = [];
  UserModel? _currentUser;

  // Getter
  UserModel? get currentUser => _currentUser;

  AuthProvider() {
    // Saat provider dibuat, langsung coba muat data pengguna & login otomatis
    loadUsers();
  }

  // --- Fungsi Autentikasi ---

  Future<bool> register(String username, String email, String password) async {
    // Cek apakah email sudah terdaftar
    if (_users.any((user) => user.email.toLowerCase() == email.toLowerCase())) {
      return false; // Email sudah ada
    }
    
    final newUser = UserModel(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password, // Ingat: ini hanya simulasi
      joinDate: DateTime.now(),
    );
    _users.add(newUser);
    await saveUsers(); // Simpan daftar pengguna baru
    notifyListeners();
    return true; // Registrasi berhasil
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase() && user.password == password,
      );
      _currentUser = user;
      
      // Simpan ID user yang login untuk auto-login nanti
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', user.id);

      notifyListeners();
      return true; // Login berhasil
    } catch (e) {
      return false; // User tidak ditemukan atau password salah
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    // Hapus data sesi login
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    notifyListeners();
  }

  // --- Fungsi Persistensi & Auto-Login ---

  Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_users.map((user) => user.toJson()).toList());
    await prefs.setString('users_data', data);
  }

  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('users_data');
    _users.clear();
    if (data != null) {
      final decodedData = json.decode(data) as List;
      _users.addAll(decodedData.map((d) => UserModel.fromJson(d)));
    }
    // Tambahkan user default jika belum ada
    if (!_users.any((u) => u.email == 'reviewer@demo.com')) {
      _users.add(UserModel(
        id: const Uuid().v4(),
        username: 'besto',
        email: 'besto',
        password: 'besto', // Password default
        joinDate: DateTime.now(),
        bio: 'Akun demo untuk review',
        themeMode: 'system',
      ));
      await saveUsers();
    }
    // Setelah semua user dimuat, coba login otomatis
    await _tryAutoLogin();
    notifyListeners();
  }
  
  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('current_user_id');
    if (userId != null) {
      try {
        _currentUser = _users.firstWhere((user) => user.id == userId);
      } catch (e) {
        // User yang tersimpan tidak ditemukan di daftar, mungkin data korup
        _currentUser = null;
      }
    }
  }

  // --- Fungsi Edit Profil ---
  Future<void> updateProfile(String newUsername, String newBio) async {
    if (_currentUser != null) {
      try {
        final userInList = _users.firstWhere((user) => user.id == _currentUser!.id);

        _currentUser!.username = newUsername;
        _currentUser!.bio = newBio; // <-- Tambahkan ini

        userInList.username = newUsername;
        userInList.bio = newBio; // <-- Tambahkan ini

        await saveUsers();
        notifyListeners();
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  // Tambahkan fungsi baru ini untuk mengubah tema
  Future<void> updateTheme(String newThemeMode) async {
    if (_currentUser != null) {
      try {
        final userInList = _users.firstWhere((user) => user.id == _currentUser!.id);
        
        _currentUser!.themeMode = newThemeMode;
        userInList.themeMode = newThemeMode;

        await saveUsers();
        notifyListeners();
      } catch (e) {
        print('Error updating theme: $e');
      }
    }
  }
}