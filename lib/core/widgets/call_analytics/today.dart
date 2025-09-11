import 'package:flutter/material.dart';

class TodayAnalyticsWidget extends StatelessWidget {
  final int? totalCount;
  const TodayAnalyticsWidget({super.key, this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Today Logs", style: TextStyle(
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