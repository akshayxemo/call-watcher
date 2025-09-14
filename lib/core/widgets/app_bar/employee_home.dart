import 'package:call_watcher/data/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeeHomeAppBarTitle extends StatelessWidget {
  final Employee? employee;
  const EmployeeHomeAppBarTitle({
    super.key,
    this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.jpg'),
          radius: 20,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                employee?.name != null && employee!.name != ""
                    ? employee!.name
                    : 'John Doe',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                employee?.email != null && employee!.email != ""
                    ? employee!.email
                    : 'Employee',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
