import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/repository/users.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FilterModal extends StatefulWidget {
  final Function({int? startDate, int? endDate, Employee? user}) getDataFn;
  final int? startDate;
  final int? endDate;
  final Employee? user;
  const FilterModal({
    super.key,
    required this.getDataFn,
    this.endDate,
    this.startDate,
    this.user,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final _formKey = GlobalKey<FormState>();
  // Use TextEditingController if you want to access field values
  // Controllers
  TextEditingController _employeeCtrl = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  Employee?
      _selectedEmployee; // <- you have it if you want to pass userId later
  FocusNode? focusNode;
  FocusNode? _searchFocus;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate != null && widget.startDate != 0
        ? DateTime.fromMillisecondsSinceEpoch(widget.startDate!)
        : null;
    _endDate = widget.endDate != null && widget.endDate != 0
        ? DateTime.fromMillisecondsSinceEpoch(widget.endDate!)
        : null;
    _selectedEmployee = widget.user;
    _employeeCtrl = TextEditingController(
      text: widget.user?.name ?? '', // ✅ prefill if provided
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocus?.dispose(); // ✅ dispose what you own
    _employeeCtrl.dispose();
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
    if ((_startDate == null && _endDate != null) ||
        (_endDate == null && _startDate != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both dates")),
      );
      return;
    }

    if (_endDate != null &&
        _startDate != null &&
        _endDate!.isBefore(_startDate!)) {
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
    widget.getDataFn
        .call(startDate: start, endDate: end, user: _selectedEmployee);
    Navigator.pop(context);
  }

  void _clearFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedEmployee = null;
      _employeeCtrl.clear();
      _searchFocus?.unfocus();
    });

    widget.getDataFn.call(startDate: null, endDate: null, user: null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              16, // 👈 space for keyboard
        ),
        child: SingleChildScrollView(
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
                    // ================== EMPLOYEE SEARCH FIELD ==================
                    TypeAheadField<Employee>(
                      // direction: VerticalDirection
                      //     .up, // 👈 open suggestions above the field
                      // Smooth typing
                      debounceDuration: const Duration(milliseconds: 250),
                      controller: _employeeCtrl, // 👈 controller
                      focusNode: _searchFocus, // 👈 focus node
                      // How to build the input field
                      builder: (context, controller, focusNode) {
                        focusNode.addListener(() => setState(() {}));
                        // keep external reference synced
                        // _employeeCtrl = controller;
                        // _searchFocus = focusNode;
                        final hasFocus = focusNode.hasFocus;

                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: "Search employee",
                            hintText: "Type a name…",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: (hasFocus)
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      controller.clear();
                                      // 👇 this hides the keyboard and closes suggestions
                                      focusNode.unfocus();
                                      _selectedEmployee = null;
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.secondary),
                            ),
                          ),
                        );
                      },
                      // Fetch suggestions from your repository (SQLite under the hood)
                      suggestionsCallback: (search) async {
                        if (search.trim().isEmpty) return <Employee>[];
                        final repo = serviceLocator<UsersRepository>();
                        final list = await repo.getAllEmployees(
                          search: search,
                          page: 1,
                          limit: 10, // keep it light
                        );
                        // Ensure non-null list of Employee
                        return list.whereType<Employee>().toList();
                      },
                      // How each suggestion row looks
                      itemBuilder: (context, emp) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(emp.name != "" ? emp.name : 'Unknown'),
                          subtitle: emp.email != "" ? Text(emp.email) : null,
                        );
                      },
                      // Optional builders
                      emptyBuilder: (context) => const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No matches'),
                      ),
                      loadingBuilder: (context) => const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                      // When user taps a suggestion
                      onSelected: (emp) {
                        setState(() {
                          _selectedEmployee = emp;
                          _employeeCtrl.text = emp.name;
                          // ✅ write to the same controller that powers the TextField
                          _employeeCtrl.selection = TextSelection.collapsed(
                              offset: emp.name.length); // cursor at end
                          _searchFocus
                              ?.unfocus(); // hide keyboard + suggestions
                        });
                      },
                      // Style the popup
                      decorationBuilder: (context, child) => Material(
                        elevation: 4,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxHeight: 150), // 👈 cap height
                          child:
                              child, // suggestions list (scrollable when overflow)
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),
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
      ),
    );
  }
}
