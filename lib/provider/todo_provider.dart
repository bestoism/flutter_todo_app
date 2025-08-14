// Lokasi: lib/provider/todo_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/models/user_model.dart'; 
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  
  final List<TodoModel> _tasks = [];

  
  List<TodoModel> _filteredTasks = [];
  bool _isSearching = false;

  
  List<TodoModel> get tasks => _isSearching ? _filteredTasks : _tasks;

  
  TodoProvider() {
    loadTasks();
  }

  // =======================================================================
  // FUNGSI KONEKSI DENGAN AUTH PROVIDER
  // =======================================================================

  
  void updateUser(UserModel? user) {
    
  }
  

  // =======================================================================
  // FUNGSI CRUD (Create, Read, Update, Delete)
  // =======================================================================

  void _sortTasks() {
    _tasks.sort((a, b) {
      
      if (a.isCompleted != b.isCompleted) {

        return a.isCompleted ? 1 : -1;
      }
      
      return b.date.compareTo(a.date);
    });
  }

  
  void addTask(
    String title,
    String note,
    DateTime date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Color? color,
  ) {
    final newTask = TodoModel(
      id: const Uuid().v4(), 
      title: title,
      note: note,
      date: date,
      startTime: startTime,
      endTime: endTime,
      color: color,
    );
    _tasks.insert(0, newTask); 
    _saveAndNotify(); 
  }

  
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
      
      final task = _tasks.firstWhere((task) => task.id == id);
      
      task.title = newTitle;
      task.note = newNote;
      task.date = newDate;
      task.startTime = newStartTime;
      task.endTime = newEndTime;
      task.color = newColor;
      _saveAndNotify(); 
    } catch (e) {
      print('Error editing task: Task with id $id not found.');
    }
  }

  
  void toggleTaskStatus(String id) {
    try {
      final task = _tasks.firstWhere((task) => task.id == id);
      task.isCompleted = !task.isCompleted;
      _saveAndNotify(); 
    } catch (e) {
      print('Error toggling task status: Task with id $id not found.');
    }
  }

  
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveAndNotify(); 
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
    
    notifyListeners();
  }

  // =======================================================================
  // FUNGSI PENYIMPANAN LOKAL (Shared Preferences)
  // =======================================================================

  
  void _saveAndNotify() {
    _sortTasks(); 
    saveTasks();
    notifyListeners();
  }

  
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    
    final String encodedData = json.encode(
      _tasks.map((task) => task.toJson()).toList(),
    );
    
    await prefs.setString(
      'tasks_data_v2',
      encodedData,
    ); 
  }

  
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksData = prefs.getString('tasks_data_v2');

    if (tasksData != null) {
      final List<dynamic> decodedData = json.decode(tasksData);
      _tasks.clear();
      _tasks.addAll(
        decodedData.map((item) => TodoModel.fromJson(item)).toList(),
      );
      _sortTasks(); 
    }
    notifyListeners();
  }
}
