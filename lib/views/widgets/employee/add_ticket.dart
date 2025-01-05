import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/tickets_page.dart';

class AddTicket extends StatelessWidget {
  const AddTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors().navy,

      appBar: AppBar(
        title: Text(
          'Add Ticket',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors().navy,
          ),
        ),
        backgroundColor: AppColors().white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
            const Text(
              'Add Your Ticket',
              style: TextStyle(color: Colors.white70),
            ),
             
              const SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: AppColors().white),
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const TextField(
                maxLines: 4,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  labelText: 'Problem Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                        fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().orange,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors().white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicketsPage(),
                    ),
                  );
                },
                child: Text(
                  'Show All Tickets',
                  style: TextStyle(color: AppColors().navy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}