import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/views/widgets/employee/build_admin_card.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ **دالة لجلب بيانات الإداريين**
  Future<List<Map<String, dynamic>>> fetchAdmins() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .limit(10)
        .get();

    if (snapshot.docs.isEmpty) {
      debugPrint("❌ No admins found in Firestore");
    } else {
      debugPrint("✅ Admins fetched successfully: ${snapshot.docs.length}");
    }

    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "About App",
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 18),
            Text(
              "Developers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Admins",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),

            /// ✅ **استخدام `FutureBuilder` بدلاً من `StreamBuilder` لتقليل استهلاك Firebase**
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAdmins(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No admins found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final adminUsers = snapshot.data!;

                  return ListView.builder(
                    itemCount: adminUsers.length,
                    itemBuilder: (context, index) {
                      final adminData = adminUsers[index];

                      return buildAdminCard(
                        context,
                        name: adminData['name'] ?? 'Unknown Admin',
                        role: adminData['role'] ?? 'Admin',
                        image: adminData['img'] ??
                            'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg',
                        adminId: adminData['id'],
                        adminJob: adminData['job'] ?? 'New Admin',
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Image.asset(
                'lib/assets/images/logo_navy.PNG',
                width: 80,
                height: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "This program was developed by the developers of Orchida Soft Software Company",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
