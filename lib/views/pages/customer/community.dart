import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

import 'view_emp_profile_page.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  // final CustomerServices _customerServices = CustomerServices();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> items =
        await CustomerServices.instance.fetchAllEmployeeItems();

    setState(() {
      _allItems = items;
      _filteredItems = items;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = CustomerServices.instance.filterItems(query, _allItems);
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
              onChanged: _onSearchChanged,
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            const Expanded(
              child: Center(
                child: ShimmerPage(),
              ),
            )
          // No Items Found
          else if (_filteredItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No items found!'),
              ),
            )
          // Display List of Items
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to ViewEmpProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewEmpProfilePage(
                            employeeId: item['employeeId'],
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
