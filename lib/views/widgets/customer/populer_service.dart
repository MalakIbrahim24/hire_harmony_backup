import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class PopulerService extends StatefulWidget {
  const PopulerService({super.key});

  @override
  State<PopulerService> createState() => _PopulerServiceState();
}

class _PopulerServiceState extends State<PopulerService> {
  Future<List<Map<String, dynamic>>> fetchPopularServicesWithEmployees() async {
    final popularServicesCollection =
        FirebaseFirestore.instance.collection('popularservices');
    final popularServicesSnapshot = await popularServicesCollection.get();

    final servicesWithEmployees = <Map<String, dynamic>>[];

    for (final serviceDoc in popularServicesSnapshot.docs) {
      final serviceId = serviceDoc.id;
      final serviceData = serviceDoc.data();

      // Fetch employees offering this service
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final usersSnapshot = await usersCollection.get();

      for (final userDoc in usersSnapshot.docs) {
        final userServicesCollection = userDoc.reference.collection('services');
        final serviceSnapshot =
            await userServicesCollection.doc(serviceId).get();

        if (serviceSnapshot.exists) {
          final serviceInfo = serviceSnapshot.data();
          servicesWithEmployees.add({
            'service': serviceData,
            'serviceDetails': serviceInfo,
            'employee': userDoc.data(),
          });
        }
      }
    }

    return servicesWithEmployees;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPopularServicesWithEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No popular services found'));
          }
          final popularServicesWithEmployees = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularServicesWithEmployees.length,
            itemBuilder: (context, index) {
              final service = popularServicesWithEmployees[index]['service']
                  as Map<String, dynamic>;
              final serviceDetails = popularServicesWithEmployees[index]
                  ['serviceDetails'] as Map<String, dynamic>;
              final employee = popularServicesWithEmployees[index]['employee']
                  as Map<String, dynamic>;

              final serviceName = service['name'] ?? 'Unknown Service';
              final serviceImg = serviceDetails['img'] ?? '';
              final employeeName = employee['name'] ?? 'Unknown Employee';

              return InkWell(
                onTap: () {
                  debugPrint('Selected Service: $serviceName by $employeeName');
                },
                child: Container(
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
                          radius: 40,
                          backgroundImage: serviceImg.isNotEmpty
                              ? NetworkImage(serviceImg)
                              : null,
                          backgroundColor: AppColors().navy,
                          child: serviceImg.isEmpty
                              ? const Icon(Icons.design_services,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          serviceName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors().navy,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'By: $employeeName',
                          textAlign: TextAlign.center,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
