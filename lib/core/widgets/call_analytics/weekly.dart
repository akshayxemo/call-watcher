import 'package:flutter/material.dart';

class WeeklyAnalyticsWidget extends StatelessWidget {
  final int? totalCount;
  const WeeklyAnalyticsWidget({super.key, this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade700.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Weekly Logs", style: TextStyle(
              color: Colors.white,
            ),),
            Text("$totalCount", style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),)
          ],
        ),
      ),
    );
  }
}