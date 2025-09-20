import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const AdminBottomNavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  final navItems = const [
    {'icon': Icons.home_outlined, 'label': "Home"},
    {'icon': Icons.person_2_outlined, 'label': "Users"},
    {'icon': Icons.leaderboard_outlined, 'label': "Analytics"},
  ];

  static const _indicatorHeight = 3.0;
  static const _barHeight = 60.0;
  static const _animDuration = Duration(milliseconds: 260);
  static const _animCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 80,
            )
          ],
        ),
        child: BottomAppBar(
          elevation: 0.0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: _barHeight,
          color: Colors.white,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemCount = navItems.length;
              final itemWidth = constraints.maxWidth / itemCount;
              final left = pageIndex * itemWidth;

              return Stack(
                children: [
                  // Row of tappable items
                  Row(
                    children: List.generate(itemCount, (i) {
                      final data = navItems[i];
                      final selected = i == pageIndex;
                      return _NavItem(
                        icon: data['icon'] as IconData,
                        label: data['label'] as String,
                        selected: selected,
                        onTap: () => onTap(i),
                      );
                    }).expand((w) sync* {
                      yield Expanded(child: w);
                      // spacing between items (optional)
                      // (We don't actually need SizedBox if using Expanded evenly)
                    }).toList(),
                  ),

                  // Sliding top indicator
                  Positioned(
                    top: 0,
                    child: AnimatedContainer(
                      duration: _animDuration,
                      curve: _animCurve,
                      // Make the container occupy the full width so we can animate via Transform
                      width: constraints.maxWidth,
                      height: _indicatorHeight,
                      // Use a translation to avoid re-layout thrash
                      transform: Matrix4.translationValues(left, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: itemWidth,
                          height: _indicatorHeight,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        selected ? AppColors.secondary : Colors.blueGrey.withOpacity(0.5);

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.secondary.withOpacity(0.12),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Smoothly animate icon color/size a touch
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              tween: Tween(begin: selected ? 0 : 1, end: selected ? 1 : 0),
              builder: (context, t, _) {
                final size = 22 + 2 * t; // 22 -> 24 when selected
                return Icon(icon, color: selectedColor, size: size);
              },
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: TextStyle(
                color: selectedColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
