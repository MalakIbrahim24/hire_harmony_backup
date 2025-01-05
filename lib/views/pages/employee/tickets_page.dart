import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/add_ticket.dart';


class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().navy,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: Text('Add Ticket',style:TextStyle(
            fontSize: 18,
            color: AppColors().white,
            fontWeight: FontWeight.bold,
          ),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const  AddTicket()),
                    );
                },
              ),
              const SizedBox(height: 16.0),
              const TicketCard(
                title: 'sami King',
                description: 'Install Pub And Agent (Task Description)',
                name: 'E-Khajon',
                daysAgo: '2 Days',
                status: 'Working',
                startDate: '05-03-2024',
              ),
              const SizedBox(height: 16.0),
              const TicketListItem(
                title: 'Ticket 1',
                description: 'Invalid Invoices (Task Description)',
                name: 'E-Khajon',
                daysAgo: '2 Days',
                status: 'Working',
                startDate: '05-03-2024',
              ),
              const Divider(),
              const TicketListItem(
                title: 'Ticket 2',
                description: '(Task Description)',
                name: 'E-Khajon',
                daysAgo: '2 Days',
                status: 'Working',
                startDate: '05-03-2024',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String title;
  final String description;
  final String name;
  final String daysAgo;
  final String status;
  final String startDate;

  const TicketCard({super.key, 
    required this.title,
    required this.description,
    required this.name,
    required this.daysAgo,
    required this.status,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
                color: AppColors().navy,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: AppColors().white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style:  TextStyle(
              color: AppColors().white,
            ),
          ),
          const SizedBox(height: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Name : ',
                    style: TextStyle(color: AppColors().white),
                  ),
                  Text(
                    name,
                    style: TextStyle(color: AppColors().white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Days Ago : ',
                    style:  TextStyle(color: AppColors().white),
                  ),
                  Text(
                    daysAgo,
                    style:  TextStyle(color: AppColors().white),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Status : ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'completed',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Start Date : ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    startDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TicketListItem extends StatelessWidget {
  final String title;
  final String description;
  final String name;
  final String daysAgo;
  final String status;
  final String startDate;

  const TicketListItem({super.key, 
    required this.title,
    required this.description,
    required this.name,
    required this.daysAgo,
    required this.status,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Name: $name'),
                    const SizedBox(width: 16.0),
                    Text('Days Ago: $daysAgo'),
                  ],
                ),
                 
                    Text('Status: $status'),
                    const SizedBox(width: 16.0),
                    Text('Start Date: $startDate'),
                
                
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}