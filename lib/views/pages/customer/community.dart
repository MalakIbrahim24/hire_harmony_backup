import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

import 'view_emp_profile_page.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];

  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchAllEmployeeItems();
  }

  void _fetchAllEmployeeItems() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final employeesSnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    final List<Map<String, dynamic>> allItems = [];

    for (var employeeDoc in employeesSnapshot.docs) {
      final employeeData = employeeDoc.data();
      final employeeId = employeeDoc.id;

      final itemsSnapshot = await _firestore
          .collection('users')
          .doc(employeeId)
          .collection('items')
          .get();

      for (var itemDoc in itemsSnapshot.docs) {
        final itemData = itemDoc.data();
        allItems.add({
          'employeeId': employeeId,
          'employeeName': employeeData['name'] ?? 'Unknown Employee',
          'employeeImg':
              employeeData['img'] ?? 'https://via.placeholder.com/150',
          'itemId': itemDoc.id,
          'itemName': itemData['name'] ?? 'Unnamed Item',
          'itemImg': itemData['image'] ?? 'https://via.placeholder.com/150',
          'itemAbout': itemData['description'] ?? 'No description provided',
          'itemRating': itemData['rating'] ?? '0',
        });
      }
    }

    setState(() {
      _allItems = allItems;
      _filteredItems = allItems; // Initially show all items
      _isLoading = false; // Hide loading indicator
    });
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _allItems;
      });
      return;
    }

    final filtered = _allItems
        .where((item) =>
            item['itemName'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredItems = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Bartering',
          style: GoogleFonts.montserratAlternates(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors().orange,
                ),
                hintText: 'Search items...',
                hintStyle: GoogleFonts.montserratAlternates(
                  color: AppColors().grey2,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterItems,
            ),
          ),

          // Show loading indicator while fetching items
          if (_isLoading)
            const Expanded(
              child: Center(
                child: ShimmerPage(),
              ),
            )
          else if (_filteredItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No items found!'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the ViewEmpProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewEmpProfilePage(
                            employeeId: item['employeeId'], // Pass employeeId
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Image (Full Width)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              item['itemImg'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item Name
                                Text(
                                  item['itemName'],
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Item About
                                Text(
                                  item['itemAbout'],
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Owner Information
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(item['employeeImg']),
                                      radius: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Owner: ${item['employeeName']}',
                                          style:
                                              GoogleFonts.montserratAlternates(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors().orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
