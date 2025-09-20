import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  AdminBottomNavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  final navItems = [
    {'icon': Icons.home_outlined, 'label': "Home"},
    {'icon': Icons.person_2_outlined, 'label': "Users"},
    {'icon': Icons.leaderboard_outlined, 'label': "Analytics"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.grey.shade200, width: 1)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 80,
              )
            ]),
        child: BottomAppBar(
          elevation: 0.0,
          padding: const EdgeInsets.all(0),
          height: 70,
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  ...navItems.asMap().entries.map(
                        (entry) => navItem(
                          entry.value['icon'] as IconData,
                          pageIndex == entry.key,
                          onTap: () => onTap(entry.key),
                          label: entry.value['label'] as String,
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(
    IconData icon,
    bool selected, {
    Function()? onTap,
    String label = "",
  }) {
    final Color selectedColor =
        selected ? AppColors.secondary : Colors.blueGrey.withOpacity(0.4);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: selected
                  ? const BorderSide(color: AppColors.secondary, width: 3)
                  : BorderSide.none,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icon,
                color: selectedColor,
                size: 28,
              ),
              Text(
                label,
                style: TextStyle(
                  color: selectedColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
