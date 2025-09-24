import 'package:call_watcher/data/models/employee.dart';
import 'package:flutter/material.dart';

class UsersCard extends StatelessWidget {
  final Employee employee;
  const UsersCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(color: Colors.blue.shade700, width: 0.5)),
            child: Text(
              employee.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                // fontSize: 18,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 8),
              SelectableText(employee.email),
            ],
          ),
        ],
      ),
    );
  }
}
