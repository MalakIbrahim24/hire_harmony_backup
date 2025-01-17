import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/add_ticket.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: const Text('Tickets'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().navy,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(
                'Add Ticket',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors().white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTicket(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('send ticket')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No tickets found.'));
                }

                final tickets = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    final data = ticket.data() as Map<String, dynamic>;

                    return TicketCard(
                      description: data['description'] ?? 'No Description',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String description;

  const TicketCard({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors().navy,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              color: AppColors().white,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'This ticket has been sent to the admin.',
            style: TextStyle(
              // ignore: deprecated_member_use
              color: AppColors().white.withOpacity(0.7),
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
