import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/add_ticket.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user's UID
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Tickets',
            style: GoogleFonts.montserratAlternates(
              fontSize: 22,
              color: AppColors().navy,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            dividerColor: AppColors().transparent,
            labelColor: AppColors().orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors().orange,
            labelStyle: const TextStyle(
              fontSize: 16, // Text size for selected tabs
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14, // Text size for unselected tabs
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'Unresolved'),
              Tab(text: 'Resolved'),
            ],
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
              child: TabBarView(
                children: [
                  // Unresolved Tickets
                  TicketsList(
                    userId: userId,
                    state: 'unresolved',
                  ),
                  // Resolved Tickets
                  TicketsList(
                    userId: userId,
                    state: 'resolved',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsList extends StatelessWidget {
  final String userId;
  final String state;

  const TicketsList({
    super.key,
    required this.userId,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ticketsSent')
          .where('uid', isEqualTo: userId)
          .where('state', isEqualTo: state) // Filter by state
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No ${state == 'resolved' ? 'resolved' : 'unresolved'} tickets found.',
            ),
          );
        }

        final tickets = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            final data = ticket.data() as Map<String, dynamic>;

            return TicketCard(
              description: data['description'] ?? 'No Description',
              response: data['response'] ?? 'No response yet',
            );
          },
        );
      },
    );
  }
}

class TicketCard extends StatelessWidget {
  final String description;
  final String response;

  const TicketCard({
    super.key,
    required this.description,
    required this.response,
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
              color: AppColors().white.withAlpha(180),
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            response,
            style: TextStyle(
              color: AppColors().white.withAlpha(180),
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
