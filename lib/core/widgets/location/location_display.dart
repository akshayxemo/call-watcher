import 'package:flutter/material.dart';

class LocationDisplay extends StatelessWidget {
  final String location;

  const LocationDisplay({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
