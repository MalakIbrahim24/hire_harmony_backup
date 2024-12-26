import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllPopularServicesPage extends StatelessWidget {
  const ViewAllPopularServicesPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Popular Services',
          style: GoogleFonts.montserratAlternates(color: AppColors().white),
        ),
        backgroundColor: AppColors().orange,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPopularServicesWithEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No popular services found'));
          }
          final servicesWithEmployees = snapshot.data!;
          return ListView.builder(
            itemCount: servicesWithEmployees.length,
            itemBuilder: (context, index) {
              final service = servicesWithEmployees[index]['service']
                  as Map<String, dynamic>;
              final serviceDetails = servicesWithEmployees[index]
                  ['serviceDetails'] as Map<String, dynamic>;
              final employee = servicesWithEmployees[index]['employee']
                  as Map<String, dynamic>;

              final serviceName = service['name'] ?? 'Unknown Service';
              final serviceImg = serviceDetails['img'] ?? '';
              final employeeName = employee['name'] ?? 'Unknown Employee';

              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      serviceImg.isNotEmpty ? NetworkImage(serviceImg) : null,
                  backgroundColor: AppColors().navy,
                  child: serviceImg.isEmpty
                      ? const Icon(Icons.design_services, color: Colors.white)
                      : null,
                ),
                title: Text(
                  serviceName,
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors().navy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: Text(
                  'Offered by: $employeeName',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: AppColors().grey,
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
