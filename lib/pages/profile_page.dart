// Lokasi: lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/pages/edit_profile_page.dart';
import 'package:todo_list_app/provider/auth_provider.dart';
import 'package:todo_list_app/provider/todo_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita butuh data dari kedua provider
    final authProvider = Provider.of<AuthProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Statistik tugas
    final totalTasks = todoProvider.tasks.length;
    final completedTasks = todoProvider.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // --- BAGIAN HEADER PROFIL ---
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 16),
              Text(user.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(user.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 12),
              Text(
                user.bio,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- BAGIAN STATISTIK TUGAS ---
          _buildSectionTitle('Statistics'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Tasks', totalTasks.toString()),
                  _buildStatItem('Completed', completedTasks.toString()),
                  _buildStatItem('Pending', (totalTasks - completedTasks).toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- BAGIAN PENGATURAN ---
          _buildSectionTitle('Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Joined On'),
                  subtitle: Text(DateFormat('d MMMM yyyy').format(user.joinDate)),
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('App Theme'),
                  trailing: DropdownButton<String>(
                    value: user.themeMode,
                    items: const [
                      DropdownMenuItem(value: 'system', child: Text('System')),
                      DropdownMenuItem(value: 'light', child: Text('Light')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        authProvider.updateTheme(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- TOMBOL LOGOUT ---
          ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context, authProvider),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey)),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              authProvider.logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}