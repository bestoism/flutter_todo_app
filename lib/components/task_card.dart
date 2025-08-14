// Lokasi: lib/components/task_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

class TaskCard extends StatelessWidget {
  final TodoModel task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  String _buildCountdownString(Duration difference) {
    if (difference.isNegative) {
      return 'Telah lewat';
    }
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) return '$days hari lagi';
    if (hours > 0) return '$hours jam lagi';
    if (minutes > 0) return '$minutes menit lagi';
    return 'Segera';
  }

  @override
  Widget build(BuildContext context) {

    final Color cardColor;
    if (task.isCompleted) {
      cardColor = Colors.grey.shade400;
    } else {
      cardColor = task.color ?? Colors.blueAccent;
    }

    final String statusText = task.isCompleted ? 'completed' : 'todo';

    String formatTime(TimeOfDay? time) {
      if (time == null) return '';
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return DateFormat.jm().format(dt); 
    }

    DateTime? taskStartTime;
    if (task.startTime != null) {
      final now = DateTime.now();
      taskStartTime = DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
        task.startTime!.hour,
        task.startTime!.minute,
      );
    }
  

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor, 
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (task.note.isNotEmpty)
                    Text(
                      task.note,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${formatTime(task.startTime)} - ${formatTime(task.endTime)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  if (!task.isCompleted && taskStartTime != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          final difference = taskStartTime!.difference(DateTime.now());
                          return Row(
                            children: [
                              Icon(Icons.hourglass_empty, color: Colors.white.withOpacity(0.8), size: 16),
                              const SizedBox(width: 8),
                              Text(
                                _buildCountdownString(difference),
                                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                statusText.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}