import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';

class DeletedAccountsPage extends StatefulWidget {
  const DeletedAccountsPage({super.key});

  @override
  State<DeletedAccountsPage> createState() => _DeletedAccountsPageState();
}

class _DeletedAccountsPageState extends State<DeletedAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deleted Accounts',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
          ),
        ),
        backgroundColor: AppColors().navy,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreService.instance.collectionStream(
          path: 'deleted_users',
          builder: (data, documentId) => {
            'id': documentId,
            'name': data['name'] ?? 'Unnamed',
            'email': data['email'] ?? 'No email',
            'deleted_at': data['deleted_at'] ?? '',
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().navy,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No deleted accounts found',
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().navy,
                ),
              ),
            );
          }

          final deletedAccounts = snapshot.data!;

          return ListView.builder(
            itemCount: deletedAccounts.length,
            itemBuilder: (context, index) {
              final account = deletedAccounts[index];
              final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                  .format(DateTime.parse(account['deleted_at']));

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors().navy.withOpacity(0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    account['name'],
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors().navy,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account['email'],
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 14,
                          color: AppColors().navy,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Deleted at: $formattedDate',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 12,
                          color: AppColors().grey,
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
