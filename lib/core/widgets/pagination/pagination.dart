import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:flutter/material.dart';

class PaginationView extends StatelessWidget {
  final Function(int) onPrevious;
  final Function(int) onNext;
  final Function() onLast;
  final Function() onFirst;
  final int currentPage;
  final int totalPage;

  const PaginationView({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
    required this.onFirst,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            onPressed: currentPage < 2 ? null : () => onFirst(),
            icon: const Icon(
              Icons.keyboard_double_arrow_left_sharp,
            ),
            color: AppColors.secondary,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                currentPage < 2
                    ? Colors.grey.shade100
                    : Colors.blue.withOpacity(0.1),
              ),
            ),
            iconSize: 24,
          ),
          IconButton(
            onPressed: currentPage <= 1 ? null : () => onPrevious(currentPage),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            color: AppColors.secondary,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                currentPage <= 1 ? Colors.grey.shade100 :Colors.blue.withOpacity(0.1),
              ),
            ),
            iconSize: 16,
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "$currentPage  of  $totalPage",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: currentPage == totalPage ? null : () => onNext(currentPage),
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            color: AppColors.secondary,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                currentPage == totalPage ? Colors.grey.shade100 : Colors.blue.withOpacity(0.1),
              ),
            ),
            iconSize: 16,
          ),
          IconButton(
            onPressed: currentPage == totalPage ? null : () => onLast(),
            icon: const Icon(
              Icons.keyboard_double_arrow_right_sharp,
            ),
            color: AppColors.secondary,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                currentPage == totalPage
                    ? Colors.grey.shade100
                    : Colors.blue.withOpacity(0.1),
              ),
            ),
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
