import 'package:flutter/material.dart';
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
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'This ticket has been sent to the admin.',
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withAlpha(180),
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            response,
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withAlpha(180),
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
