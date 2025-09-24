import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:call_watcher/core/widgets/pagination/pagination.dart';
import 'package:call_watcher/core/widgets/users/users_card.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/repository/users.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<StatefulWidget> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _searchControl = TextEditingController();
  bool _isLoading = true;
  int page = 1;
  int limit = 10;
  List<Employee?> employees = [];
  int totalCount = 0;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _getData(reload: true);
    _searchControl.addListener(() => setState(() {})); // rebuild on text change
    _searchFocus.addListener(() => setState(() {})); // rebuild on focus change
  }

  @override
  void dispose() {
    super.dispose();
    _searchControl.dispose();
    _searchFocus.dispose();
  }

  Future<void> _getData({bool reload = false}) async {
    if (reload) _searchControl.clear();

    if (mounted) {
      setState(() => _isLoading = true); // <-- was false
    }

    final response = await serviceLocator<UsersRepository>()
        .getAllEmployeesPaginatedResponse(
      limit: limit,
      page: page,
      search: reload ? null : _searchControl.text,
    );

    if (!mounted) return;

    setState(() {
      if (response != null) {
        employees = response.data;
        totalCount = response.totalPages; // ensure this is total items
      } else {
        employees = [];
        totalCount = 0;
      }
      _isLoading = false;
    });
  }

  void _onPageChanged(int newPage) {
    if (mounted) {
      setState(() {
        page = newPage;
      });
    }
    _getData(); // <-- fetch logs when page changes
  }

  void _clearSearch() {
    _searchControl.clear();
    _searchFocus.unfocus();
    _getData(reload: true); // reload unfiltered list
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _getData(reload: true),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Padding for whole scroll view
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          // Search box
                          TextField(
                            controller: _searchControl,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              labelText: "Search employee",
                              hintText: "Type a name…",
                              prefixIcon: const Icon(Icons.search),

                              // Suffix row with clear and GO button
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  if (_searchControl.text.isNotEmpty &&
                                      _searchFocus.hasFocus) ...[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: AppColors.primary,
                                        minimumSize: const Size(60, 36),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .unfocus(); // dismiss keyboard
                                        _getData(); // trigger search
                                      },
                                      child: const Text("GO"),
                                    ),
                                  ],
                                  if (_searchControl.text.isNotEmpty) ...[
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: _clearSearch,
                                    ),
                                  ],
                                ],
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.secondary),
                              ),
                            ),
                            onSubmitted: (_) =>
                                _getData(), // pressing enter also searches
                          ),

                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("$totalCount results found"),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),

                  if (totalCount == 0)
                    const Center(
                      child: Text("No Data Found"),
                    ),

                  if (totalCount > 0) ...[
                    // List items
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final emp = employees[index]!;
                            return UsersCard(employee: emp);
                          },
                          childCount: employees.length,
                        ),
                      ),
                    ),

                    // Bottom pagination – sticks to bottom if content is short
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PaginationView(
                              currentPage: page,
                              totalPage: (totalCount / limit).ceil(),
                              onFirst: () => _onPageChanged(1),
                              onLast: () =>
                                  _onPageChanged((totalCount / limit).ceil()),
                              onNext: (i) => _onPageChanged(i + 1),
                              onPrevious: (i) => _onPageChanged(i - 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
