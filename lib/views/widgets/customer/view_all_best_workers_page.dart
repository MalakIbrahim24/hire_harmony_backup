import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllBestWorkersPage extends StatelessWidget {
  const ViewAllBestWorkersPage({super.key});

  Future<Map<String, dynamic>> fetchUserInfo(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()!;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors().navy),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'All Best Workers',
                      style: GoogleFonts.montserratAlternates(
                        color: AppColors().navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer for symmetry
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bestworker').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No best workers found'));
          }
          final workers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final bestWorker = workers[index];
              final bestWorkerId = bestWorker.id;

              return FutureBuilder<Map<String, dynamic>>(
                future: fetchUserInfo(bestWorkerId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError ||
                      userSnapshot.data == null ||
                      userSnapshot.data!.isEmpty) {
                    return const ListTile(
                      leading: Icon(Icons.error),
                      title: Text('Error fetching user details'),
                    );
                  }

                  final userInfo = userSnapshot.data!;
                  final workerName = userInfo['name'] ?? 'Unknown Worker';
                  final workerImg = userInfo['img'] ?? '';
                  final workerServNum = bestWorker['servNum'] ?? '0';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: workerImg.isNotEmpty
                                ? NetworkImage(workerImg)
                                : null,
                            backgroundColor: AppColors().navy,
                            child: workerImg.isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workerName,
                                  style: GoogleFonts.montserratAlternates(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: AppColors().navy,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Services: $workerServNum',
                                  style: GoogleFonts.montserratAlternates(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors().grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Add view profile functionality here
                            },
                            child: Text(
                              'View Profile',
                              style: GoogleFonts.montserratAlternates(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors().white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
