import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/cus_edit_profile_page.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  // المعرف الثابت للمستند في Firestore
  final String documentId = 'tAkdNFqswzMaxOPRC239';

  Future<Map<String, dynamic>?> fetchProfileData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('client')
          .doc(documentId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching profile data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Profile Info',
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
          IconButton(
            icon: Icon(Icons.edit, color: AppColors().orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CusEditProfilePage(),
                ),
              ).then((_) {
                // إعادة بناء الصفحة عند العودة
                // ignore: invalid_use_of_protected_member
                (context as Element).reassemble();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading data'));
          }

          final data = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/teacher.jpg'),
              ),
              const SizedBox(height: 10),
              Text(
                data['name'] ?? 'N/A',
                style: GoogleFonts.montserratAlternates(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: AppColors().navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
               data['email'] ?? 'N/A',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: AppColors().white,
                  shadowColor: AppColors().orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: AppColors().orange),
                        title: Text(data['name'] ?? 'N/A'),
                        subtitle: const Text('Full name'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.location_on, color: AppColors().orange),
                        title: Text(data['location'] ?? 'N/A'),
                        subtitle: const Text('Location'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.phone, color: AppColors().orange),
                        title: Text(data['phone_number'] ?? 'N/A'),
                        subtitle: const Text('Contact'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}