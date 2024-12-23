import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusEditProfilePage extends StatefulWidget {
  const CusEditProfilePage({super.key});

  @override
  State<CusEditProfilePage> createState() => _CusEditProfilePageState();
}

class _CusEditProfilePageState extends State<CusEditProfilePage> {
  final String documentId = 'tAkdNFqswzMaxOPRC239';
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> fetchData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('client')
          .doc(documentId)
          .get();

      if (doc.exists) {
        setState(() {
          nameController.text = doc['name'] ?? '';
          locationController.text = doc['location'] ?? '';
          mobileController.text = doc['phone_number']?.toString() ?? '';
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تحميل البيانات')),
      );
    }
  }

  Future<void> updateData() async {
    try {
      await FirebaseFirestore.instance
          .collection('client')
          .doc(documentId)
          .set({
        'name': nameController.text,
        'location': locationController.text,
        'phone_number': mobileController.text,
      }, SetOptions(merge: true));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تحديث البيانات')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // تحميل البيانات عند فتح الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors().navy),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: updateData,
            child: Text(
              'Done',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors().orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/teacher.jpg'),
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, color: Colors.black, size: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Haneen',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: AppColors().navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'haneendaoud@gmail.com',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors().grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildTextField(
                      label: 'First Name',
                      hintText: 'First Name',
                      controller: nameController),
                  const SizedBox(height: 10),
                  buildTextField(
                      label: 'Email',
                      hintText: 'Email',
                      controller: emailController),
                  const SizedBox(height: 10),
                  buildTextField(
                      label: 'Location',
                      hintText: 'Location',
                      controller: locationController),
                  const SizedBox(height: 10),
                  buildTextField(
                      label: 'Mobile Number',
                      hintText: 'Mobile',
                      controller: mobileController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: 13,
                color: AppColors().grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors().grey3,
          ),
        ),
      ],
    );
  }
}
