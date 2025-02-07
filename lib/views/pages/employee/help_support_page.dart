import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class HelpSupportPage extends StatefulWidget {
  final String? adminId;

  const HelpSupportPage({super.key, this.adminId});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final EmployeeService employeeService = EmployeeService(); // ✅ استدعاء `EmployeeService`
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    setState(() => _isLoading = true);

    await employeeService.submitComplaint(
      context: context,
      messageController: _messageController,
      adminId: widget.adminId,
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 20,
              color: AppColors().white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        backgroundColor: AppColors().orange,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: AppColors().orange,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'lib/assets/images/logo_white_navy_shadow.PNG',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'What Went Wrong?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors().orangelight,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 7,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                  border: InputBorder.none,
                  hintText: 'You can write your problem here...',
                  hintStyle: TextStyle(color: AppColors().grey3, fontSize: 14),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onPressed: _isLoading ? null : _submitMessage,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Submit',
                      style: TextStyle(
                        color: AppColors().orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
