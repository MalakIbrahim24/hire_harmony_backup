import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/models/service.dart';

class EmployeeServicesPage extends StatelessWidget {
  final String employeeId;
  final String employeeName;

  const EmployeeServicesPage({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$employeeName\'s Services',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors().navy,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColors().white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: StreamBuilder<List<Service>>(
        stream: FirestoreService.instance.getDataStream<Service>(
          collectionPath: 'users/$employeeId/services',
          builder: (data, documentId) => Service(
            id: documentId,
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            image: '',
          ),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No services found for $employeeName',
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().navy,
                ),
              ),
            );
          }

          final services = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        AppColors().navy.withValues(alpha:0.2), // Light navy border
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors().navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.description,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 14,
                          color: AppColors().navy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors().orange.withValues(alpha:0.8),
                            foregroundColor: AppColors().white,
                          ),
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Service'),
                                content: const Text(
                                    'Are you sure you want to delete this service?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              await FirestoreService.instance.deleteDataa(
                                documentPath:
                                    'users/$employeeId/services/${service.id}',
                                serviceName: service.name,
                                employeeId: employeeId,
                                employeeName: employeeName,
                              );

                              Fluttertoast.showToast(
                                msg: "Service deleted successfully",
                                textColor: AppColors().white,
                                backgroundColor:
                                    AppColors().orange.withValues(alpha:0.8),
                              );
                            }
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.montserratAlternates(
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
      ),
    );
  }
}
