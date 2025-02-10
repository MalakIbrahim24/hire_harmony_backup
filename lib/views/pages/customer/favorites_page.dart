import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/view_emp_profile_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // final CustomerServices _customerServices = CustomerServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorites',
          style: GoogleFonts.montserratAlternates(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: CustomerServices.instance.fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading favorites: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorites added yet!',
                style: GoogleFonts.montserratAlternates(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final favoriteId = favorite['uid'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    if (favoriteId != null && favoriteId is String) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewEmpProfilePage(
                            employeeId: favoriteId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This favorite item is invalid.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      favorite['img'] ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  title: Text(
                    favorite['name'] is String
                        ? favorite['name']
                        : 'Unnamed Employee',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewEmpProfilePage(
                                employeeId: favoriteId,
                              ),
                            ),
                          );
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
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (favoriteId != null && favoriteId is String) {
                        CustomerServices.instance.toggleFavorite(favoriteId);
                      }
                    },
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
