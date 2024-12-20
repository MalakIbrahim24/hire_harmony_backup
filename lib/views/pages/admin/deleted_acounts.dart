import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/admin_service.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class DeletedAcounts extends StatefulWidget {
  final String uid;
  const DeletedAcounts({super.key, required this.uid});
  @override
  State<DeletedAcounts> createState() => _DeletedAcountsState();
}

class _DeletedAcountsState extends State<DeletedAcounts> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/images/notf.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Blur Filter
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: AppColors().navy.withValues(alpha: 0.3),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Text(
                'Deleted Accounts',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 24,
                  color: AppColors().white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Users',
                    labelStyle: GoogleFonts.montserratAlternates(
                      color: AppColors().white,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors().white),

                    // Default border
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors().white.withValues(
                            alpha: 0.5), // Navy border when not focused
                      ),
                    ),

                    // Focused border
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors().navy, // Navy border when focused
                        width: 2, // Thicker border for emphasis
                      ),
                    ),

                    // Error border (optional)
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors().red, // Red border when error occurs
                      ),
                    ),

                    // Focused error border (optional)
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors()
                            .red, // Red border when focused with error
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: AdminService.instance.getDeletedAccounts(widget.uid),
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
                          'No Deleted users',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().white,
                          ),
                        ),
                      );
                    }

                    final users = snapshot.data!
                        .where((user) => user['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors().navy.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              user['name'],
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors().navy,
                              ),
                            ),
                            subtitle: Text(
                              user['email'],
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 14,
                                color: AppColors().navy,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
