import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class BestWorker extends StatelessWidget {
  const BestWorker({super.key});

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
    final Stream<List<Map<String, dynamic>>> bestWorkersStream =
        FirebaseFirestore.instance
            .collection('bestworker')
            .snapshots()
            .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'data': doc.data(),
        };
      }).toList();
    });

    return SizedBox(
      height: 200, // Increased height for larger circles
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: bestWorkersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No best workers found'));
          }
          final bestWorkers = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bestWorkers.length,
            itemBuilder: (context, index) {
              final bestWorker = bestWorkers[index];
              final bestWorkerId = bestWorker['id'];

              return FutureBuilder<Map<String, dynamic>>(
                future: fetchUserInfo(bestWorkerId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError ||
                      userSnapshot.data == null ||
                      userSnapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Error fetching user details'));
                  }

                  final userInfo = userSnapshot.data!;
                  final workerName = userInfo['name'] ?? 'Unknown Worker';
                  final workerImg = userInfo['img'] ?? '';
                  final workerServNum = bestWorker['data']['servNum'] ?? '0';

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors().white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors().navy),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50, // Adjust the radius for size
                            backgroundImage: workerImg.isNotEmpty
                                ? NetworkImage(workerImg)
                                : null, // Load image if URL is provided
                            backgroundColor:
                                AppColors().navy, // Background color
                            onBackgroundImageError: (error, stackTrace) {
                              // Handle image load errors
                            },
                            child: workerImg.isEmpty
                                ? Icon(
                                    Icons.person, // Fallback icon
                                    size: 50,
                                    color: AppColors().white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            workerName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserratAlternates(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors().navy,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Services: $workerServNum',
                            style: GoogleFonts.montserratAlternates(
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: AppColors().grey,
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
