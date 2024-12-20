import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/models/category.dart';
import 'package:hire_harmony/models/product.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late List<Product> filterProducts;
  String? selectedCategoryId = '';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: Category.dummyCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final dummyCategory = Category.dummyCategories[index];
          bool isSelected = selectedCategoryId == dummyCategory.id;
          return InkWell(
            onTap: () {
              setState(() {
                if (selectedCategoryId == dummyCategory.id &&
                    selectedCategoryId != null) {
                  selectedCategoryId = null;
                  filterProducts = dummyProducts;
                } else {
                  selectedCategoryId = dummyCategory.id;
                  filterProducts = dummyProducts
                      .where((product) =>
                          product.category.id == selectedCategoryId)
                      .toList();
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors().orange : AppColors().white,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors().navy, // Navy border when not selected
                  width: 1, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Card border radius
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 4), // Space between items
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      dummyCategory.imgUrl,
                      width: 50,
                      color: selectedCategoryId == dummyCategory.id
                          ? AppColors().white
                          : AppColors().navy,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dummyCategory.title,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: selectedCategoryId == dummyCategory.id
                              ? AppColors().white
                              : AppColors().navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
