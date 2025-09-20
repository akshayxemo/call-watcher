import 'package:call_watcher/data/models/admin.dart';
import 'package:flutter/material.dart';

class AdminHomeAppBarTitle extends StatelessWidget {
  final Admin? admin;
  const AdminHomeAppBarTitle({
    super.key,
    this.admin,
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
                admin?.name != null && admin!.name != ""
                    ? admin!.name
                    : 'John Doe',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                admin?.email != null && admin!.email != ""
                    ? admin!.email
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
