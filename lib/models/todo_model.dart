// Lokasi: lib/models/todo_model.dart
import 'package:flutter/material.dart';

class TodoModel {
  final String id;
  String title;
  String note;
  DateTime date; 
  bool isCompleted;

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Color? color; 

  TodoModel({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    this.isCompleted = false,
    this.startTime,
    this.endTime,
    this.color,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'color': color?.value, // Simpan warna sebagai integer
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return TodoModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      color: json['color'] != null ? Color(json['color']) : null, 
    );
  }
}