import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Stream<List<Map<String, dynamic>>> categoryStream =
      FirestoreService.instance.getCategories(limit: 10);

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    // Fetch up to 10 categories
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: categoryStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            }
            final categories = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category =
                    categories[index]['data'] as Map<String, dynamic>;
                final categoryTitle = category['name'] ?? 'Unknown Title';

                return InkWell(
                  onTap: () {
                    debugPrint(
                        'Selected Category ID: ${categories[index]['id']}');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors().white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors().navy),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categoryTitle,
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors().navy,
                              fontWeight: FontWeight.w500,
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
        ));
  }
}
