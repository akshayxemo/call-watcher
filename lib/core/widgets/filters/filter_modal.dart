import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final Function({int? startDate, int? endDate}) getDataFn;
  final int? startDate;
  final int? endDate;
  const FilterModal({
    super.key,
    required this.getDataFn,
    this.endDate,
    this.startDate,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final _formKey = GlobalKey<FormState>();
  // Use TextEditingController if you want to access field values
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate != null
        ? DateTime.fromMicrosecondsSinceEpoch(widget.startDate!)
        : null;
    _endDate = widget.endDate != null
        ? DateTime.fromMicrosecondsSinceEpoch(widget.endDate!)
        : null;
  }

  Future<void> _pickDate({
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      // barrierColor: Colors.white,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // header background + selected date color
              onPrimary: Colors.white, // text color on primary
              onSurface: Colors.black, // default text color
            ),
            dialogBackgroundColor: Colors.white, // dialog background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            0, 0, 0, 0, 0, // 👈 start of day
          );
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            23, 59, 59, 999, // 👈 end of day
          );
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.day}/${date.month}/${date.year}";
  }

  void _submitForm() {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both dates")),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date cannot be before start date")),
      );
      return;
    }
    final int start = _startDate?.millisecondsSinceEpoch ?? 0;
    final int end = _endDate?.millisecondsSinceEpoch ?? 0;
    // ✅ Here you can send the dates to your backend, state management, etc.
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Submitted: $_startDate → $_endDate")),
    // );
    widget.getDataFn.call(startDate: start, endDate: end);
    Navigator.pop(context);
  }

  void _clearFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });

    widget.getDataFn.call(startDate: null, endDate: null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Filter Options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Start Date field
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Start Date",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.secondary,
                              ),
                            ),
                            focusColor: AppColors.secondary,
                            floatingLabelStyle: TextStyle(
                              color: AppColors.secondary,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              size: 16,
                            ),
                          ),
                          controller: TextEditingController(
                              text: _formatDate(_startDate)),
                          onTap: () => _pickDate(isStart: true),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // End Date field
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "End Date",
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              size: 16,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.secondary,
                              ),
                            ),
                            focusColor: AppColors.secondary,
                            floatingLabelStyle: TextStyle(
                              color: AppColors.secondary,
                            ),
                          ),
                          controller: TextEditingController(
                              text: _formatDate(_endDate)),
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            foregroundColor: AppColors.secondary,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            side: const BorderSide(
                              color: AppColors.secondary,
                            ),
                          ),
                          onPressed: _clearFilter,
                          child: const Text("Clear"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                          ),
                          onPressed: _submitForm,
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
