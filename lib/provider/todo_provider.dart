// Lokasi: lib/provider/todo_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/models/user_model.dart'; // <-- Pastikan import ini ada
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  // LIST UTAMA: Ini adalah sumber data yang sebenarnya dan yang disimpan.
  // Dibuat private agar tidak bisa diubah langsung dari luar.
  final List<TodoModel> _tasks = [];

  // LIST FILTER: Digunakan khusus untuk menampung hasil pencarian.
  List<TodoModel> _filteredTasks = [];
  bool _isSearching = false;

  // GETTER PUBLIK: UI akan mengakses daftar tugas melalui ini.
  // Secara cerdas akan memberikan list hasil pencarian jika sedang mencari,
  // atau list utama jika tidak.
  List<TodoModel> get tasks => _isSearching ? _filteredTasks : _tasks;

  // CONSTRUCTOR: Saat TodoProvider pertama kali dibuat,
  // ia akan langsung mencoba memuat data tugas yang tersimpan.
  TodoProvider() {
    loadTasks();
  }

  // =======================================================================
  // FUNGSI KONEKSI DENGAN AUTH PROVIDER
  // =======================================================================

  // <<< INI FUNGSI BARU YANG DITAMBAHKAN UNTUK MEMPERBAIKI ERROR >>>
  void updateUser(UserModel? user) {
    // Fungsi ini dipanggil oleh ChangeNotifierProxyProvider di main.dart.
    // Saat ini, kita tidak perlu melakukan apa-apa dengan data user di sini,
    // tapi fungsi ini harus ada untuk menghindari error kompilasi.
    // Nanti, ini bisa digunakan untuk memisahkan tugas per pengguna.
  }
  // <<< BATAS AKHIR FUNGSI BARU >>>

  // =======================================================================
  // FUNGSI CRUD (Create, Read, Update, Delete)
  // =======================================================================

  void _sortTasks() {
    _tasks.sort((a, b) {
      // Jika status 'isCompleted' berbeda
      if (a.isCompleted != b.isCompleted) {
        // Tugas yang belum selesai (isCompleted = false) akan ditempatkan sebelum yang sudah selesai.
        // false (0) akan datang sebelum true (1).
        return a.isCompleted ? 1 : -1;
      }
      // Jika status 'isCompleted' sama, urutkan berdasarkan tanggal (terbaru di atas)
      return b.date.compareTo(a.date);
    });
  }

  // CREATE: Fungsi untuk menambah tugas baru dengan semua detail dari desain.
  void addTask(
    String title,
    String note,
    DateTime date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Color? color,
  ) {
    final newTask = TodoModel(
      id: const Uuid().v4(), // Membuat ID unik
      title: title,
      note: note,
      date: date,
      startTime: startTime,
      endTime: endTime,
      color: color,
    );
    _tasks.insert(0, newTask); // Menambah di awal list agar muncul paling atas
    _saveAndNotify(); // Simpan perubahan dan perbarui UI
  }

  // UPDATE: Fungsi untuk mengedit tugas yang sudah ada.
  void editTask(
    String id,
    String newTitle,
    String newNote,
    DateTime newDate,
    TimeOfDay? newStartTime,
    TimeOfDay? newEndTime,
    Color? newColor,
  ) {
    try {
      // Cari task berdasarkan ID
      final task = _tasks.firstWhere((task) => task.id == id);
      // Perbarui semua propertinya
      task.title = newTitle;
      task.note = newNote;
      task.date = newDate;
      task.startTime = newStartTime;
      task.endTime = newEndTime;
      task.color = newColor;
      _saveAndNotify(); // Simpan perubahan dan perbarui UI
    } catch (e) {
      print('Error editing task: Task with id $id not found.');
    }
  }

  // UPDATE Status: Mengubah status tugas (selesai/belum).
  void toggleTaskStatus(String id) {
    try {
      final task = _tasks.firstWhere((task) => task.id == id);
      task.isCompleted = !task.isCompleted;
      _saveAndNotify(); // Simpan perubahan dan perbarui UI
    } catch (e) {
      print('Error toggling task status: Task with id $id not found.');
    }
  }

  // DELETE: Menghapus tugas dari daftar.
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveAndNotify(); // Simpan perubahan dan perbarui UI
  }

  // =======================================================================
  // FUNGSI PENCARIAN
  // =======================================================================

  void searchTasks(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _filteredTasks = [];
    } else {
      _isSearching = true;
      // Filter dari list utama (_tasks) berdasarkan judul atau catatan
      _filteredTasks =
          _tasks.where((task) {
            final titleMatch = task.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final noteMatch = task.note.toLowerCase().contains(
              query.toLowerCase(),
            );
            return titleMatch || noteMatch;
          }).toList();
    }
    // Hanya perbarui UI, tidak perlu menyimpan karena data asli tidak berubah
    notifyListeners();
  }

  // =======================================================================
  // FUNGSI PENYIMPANAN LOKAL (Shared Preferences)
  // =======================================================================

  // Helper function untuk menggabungkan save dan notify
  void _saveAndNotify() {
    _sortTasks(); // Panggil fungsi pengurutan di sini!
    saveTasks();
    notifyListeners();
  }

  // Menyimpan seluruh daftar tugas ke memori ponsel.
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Ubah List<TodoModel> menjadi List<Map<String, dynamic>>
    // 2. Ubah List<Map> menjadi sebuah string JSON
    final String encodedData = json.encode(
      _tasks.map((task) => task.toJson()).toList(),
    );
    // 3. Simpan string JSON ke shared_preferences
    await prefs.setString(
      'tasks_data_v2',
      encodedData,
    ); // Pakai key baru (v2) untuk menghindari error dari data lama
  }

  // Memuat daftar tugas dari memori ponsel.
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksData = prefs.getString('tasks_data_v2');

    if (tasksData != null) {
      final List<dynamic> decodedData = json.decode(tasksData);
      _tasks.clear();
      _tasks.addAll(
        decodedData.map((item) => TodoModel.fromJson(item)).toList(),
      );
      _sortTasks(); // Panggil pengurutan setelah memuat data
    }
    notifyListeners();
  }
}
