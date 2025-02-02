import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/add_item.dart';

class DisplayItems extends StatefulWidget {
  const DisplayItems({super.key});

  @override
  State<DisplayItems> createState() => _DisplayItemsState();
}

class _DisplayItemsState extends State<DisplayItems> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteItem(String itemId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item deleted successfully."),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Error deleting item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete item."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDelete(String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete this item? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteItem(itemId); // Delete item
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().white,
      appBar: AppBar(
        title: const Text("Items"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No items yet. Add one!"),
              );
            }

            final items = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemData = items[index].data() as Map<String, dynamic>;
                final itemId = items[index].id; // Get Firestore item ID

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AdvertisementCard(
                    image: itemData['image'] ?? '',
                    title: itemData['name'] ?? '',
                    description: itemData['description'] ?? '',
                    buttonText: "Learn More",
                    onDelete: () =>
                        _confirmDelete(itemId), // Pass delete function
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItem(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AdvertisementCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onDelete;

  const AdvertisementCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Stack(
              children: [
                Image.network(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey.shade700,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete, // Call delete function when pressed
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
