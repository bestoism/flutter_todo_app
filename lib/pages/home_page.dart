// Lokasi: lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/components/task_card.dart';
import 'package:todo_list_app/pages/add_edit_task_page.dart';
import '../provider/todo_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final today = DateTime.now();
    
    // Filter tugas berdasarkan yang belum selesai dan sudah selesai
    final uncompletedTasks = todoProvider.tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = todoProvider.tasks.where((t) => t.isCompleted).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TodoList',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                todoProvider.searchTasks(value);
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM').format(today),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.calendar_today_outlined),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildCounter(context, 'To Do', uncompletedTasks.length),
                const SizedBox(width: 16),
                _buildCounter(context, 'Completed', completedTasks.length),
              ],
            ),
            const SizedBox(height: 20),
            
            if (todoProvider.tasks.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      Icon(Icons.check_box_outline_blank, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Tidak ada todo tersedia untuk hari ini',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todoProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = todoProvider.tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () {
                       // Navigasi ke halaman edit saat card di-tap
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTaskPage(task: task),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(BuildContext context, String title, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('$count',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}