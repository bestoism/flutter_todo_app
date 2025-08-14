// Lokasi: lib/pages/add_edit_task_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../provider/todo_provider.dart';

class AddEditTaskPage extends StatefulWidget {
  final TodoModel? task;
  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // State untuk data baru
  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Color _selectedColor = Colors.blue; 

  final List<Color> _colorOptions = [
    Colors.blue.shade300,
    Colors.red.shade300,
    Colors.orange.shade300,
    Colors.teal.shade300,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Mode Edit
      _titleController.text = widget.task!.title;
      _noteController.text = widget.task!.note;
      _selectedDate = widget.task!.date;
      _startTime = widget.task!.startTime;
      _endTime = widget.task!.endTime;
      _selectedColor = widget.task!.color ?? Colors.blue;
    } else {
      // Mode Tambah
      _selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime({required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TodoProvider>(context, listen: false);
      if (widget.task == null) {
        provider.addTask(
          _titleController.text,
          _noteController.text,
          _selectedDate,
          _startTime,
          _endTime,
          _selectedColor,
        );
      } else {
        provider.editTask(
          widget.task!.id,
          _titleController.text,
          _noteController.text,
          _selectedDate,
          _startTime,
          _endTime,
          _selectedColor,
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatTime(TimeOfDay? time) => time?.format(context) ?? 'Pilih waktu';
    final isEditMode = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Title'),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Add content'),
                validator: (v) => v!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              _buildSectionTitle('Note'),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: 'Add content'),
                maxLines: 3,
              ),
              _buildSectionTitle('Date'),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('d MMMM yyyy').format(_selectedDate),
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _selectDate,
                  ),
                ),
                onTap: _selectDate,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Start Time'),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: formatTime(_startTime)),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectTime(isStartTime: true),
                            ),
                          ),
                          onTap: () => _selectTime(isStartTime: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('End Time'),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: formatTime(_endTime)),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectTime(isStartTime: false),
                            ),
                          ),
                          onTap: () => _selectTime(isStartTime: false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildSectionTitle('Color'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: _selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              Row(
                children: [
                  if (isEditMode)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final provider = Provider.of<TodoProvider>(context, listen: false);
                          provider.toggleTaskStatus(widget.task!.id);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: widget.task!.isCompleted ? Colors.grey : Colors.green,
                          side: BorderSide(color: widget.task!.isCompleted ? Colors.grey : Colors.green),
                        ),
                        child: Text(widget.task!.isCompleted ? 'Batal Selesai' : 'Tandai Selesai'),
                      ),
                    ),
                  if (isEditMode) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Create', style: TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}