import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final EmployeeService _employeeService = EmployeeService();
  File? _selectedImage;

  // ✅ اختيار الصورة
  Future<void> _pickImage() async {
    final pickedImage = await EmployeeService.instance.pickImage();
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  // ✅ رفع العنصر باستخدام EmployeeService
  Future<void> _uploadItem() async {
    await EmployeeService.instance.uploadItem(
      context: context,
      selectedImage: _selectedImage,
      title: _titleController.text,
      description: _descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage == null
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.tertiary,
                        child: const Icon(Icons.add_a_photo, size: 50),
                      )
                    : Image.file(
                        _selectedImage!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().orange,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onPressed: _uploadItem,
                child: Text(
                  "Add item",
                  style: TextStyle(
                    color: AppColors().white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
