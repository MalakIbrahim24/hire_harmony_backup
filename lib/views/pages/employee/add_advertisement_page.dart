import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AddAdvertisementPage extends StatefulWidget {
  const AddAdvertisementPage({super.key});

  @override
  State<AddAdvertisementPage> createState() => _AddAdvertisementPageState();
}

class _AddAdvertisementPageState extends State<AddAdvertisementPage> {
  final EmployeeService employeeService = EmployeeService(); // ✅ استدعاء الخدمة

  File? _selectedImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // ✅ استخدام `pickImage()` لاختيار الصورة
  Future<void> _pickImage() async {
    final image = await employeeService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // ✅ استخدام `uploadAdvertisement()` لرفع الإعلان
  Future<void> _uploadAdvertisement() async {
    await employeeService.uploadAdvertisement(
      context,
      _selectedImage,
      _titleController.text,
      _descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Add Advertisement"),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onPressed: _uploadAdvertisement,
                child: Text(
                  "Add Advertisement",
                  style: TextStyle(
                    color: AppColors().white,
                    fontWeight: FontWeight.bold,
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
