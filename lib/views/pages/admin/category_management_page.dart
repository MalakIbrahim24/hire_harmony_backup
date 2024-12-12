import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
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
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/adManage.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(color: AppColors().navy.withOpacity(0.3)),
          Column(
            children: [
              const SizedBox(height: 120),
              Text(
                'Category Management',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 24,
                  color: AppColors().white,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar and Add Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by category name...',
                          hintStyle: GoogleFonts.montserratAlternates(
                            color: AppColors().white.withOpacity(0.8),
                          ),
                          filled: true,
                          fillColor: AppColors().navy.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors().white,
                          ),
                        ),
                        style: GoogleFonts.montserratAlternates(
                            color: AppColors().white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: AppColors().white,
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: Icon(Icons.add, color: AppColors().navy),
                        iconSize: 30,
                        onPressed: _showAddCategoryDialog,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Fetch and Display Categories
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirestoreService.instance.collectionStream(
                    path: 'categories',
                    builder: (data, documentId) => {
                      'id': documentId,
                      'name': data['name'] ?? 'Unnamed',
                      'description': data['description'] ?? '',
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
                          'No categories available',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().white,
                          ),
                        ),
                      );
                    }

                    final categories = snapshot.data!
                        .where((category) => category['name']
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();

                    if (categories.isEmpty) {
                      return Center(
                        child: Text(
                          'No categories match your search',
                          style: GoogleFonts.montserratAlternates(
                            color: AppColors().white,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors().navy.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              category['name'],
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors().navy,
                              ),
                            ),
                            subtitle: Text(
                              category['description'],
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 14,
                                color: AppColors().navy.withOpacity(0.7),
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
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController confirmCategoryController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Category',
          style: GoogleFonts.montserratAlternates(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmCategoryController,
              decoration: const InputDecoration(
                labelText: 'Confirm Category Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().navy,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final categoryName = categoryController.text.trim();
              final confirmCategoryName = confirmCategoryController.text.trim();

              if (categoryName.isEmpty || confirmCategoryName.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Please fill in both fields",
                  textColor: AppColors().white,
                  backgroundColor: AppColors().red.withOpacity(0.8),
                );
                return;
              }

              if (categoryName != confirmCategoryName) {
                Fluttertoast.showToast(
                  msg: "Category names do not match!",
                  textColor: AppColors().white,
                  backgroundColor: AppColors().red.withOpacity(0.8),
                );
                return;
              }

              await FirestoreService.instance.addData(
                collectionPath: 'categories',
                data: {'name': categoryName, 'description': ''},
              );

              Fluttertoast.showToast(
                msg: "Category added successfully",
                textColor: AppColors().white,
                backgroundColor: AppColors().orange.withOpacity(0.8),
              );

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
