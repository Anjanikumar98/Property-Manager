// lib/features/payments/presentation/widgets/payment_search_widget.dart
import 'package:flutter/material.dart';
import 'dart:async';

class PaymentSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String? initialQuery;
  final List<String>? suggestions;

  const PaymentSearchWidget({
    Key? key,
    required this.onSearchChanged,
    this.initialQuery,
    this.suggestions,
  }) : super(key: key);

  @override
  State<PaymentSearchWidget> createState() => _PaymentSearchWidgetState();
}

class _PaymentSearchWidgetState extends State<PaymentSearchWidget> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  bool _showSuggestions = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions =
          _focusNode.hasFocus &&
          widget.suggestions != null &&
          widget.suggestions!.isNotEmpty;
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();
    widget.onSearchChanged(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search payments...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _controller.text.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),

        // Search suggestions
        if (_showSuggestions && widget.suggestions!.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.suggestions!.length,
              itemBuilder: (context, index) {
                final suggestion = widget.suggestions![index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 20),
                  title: Text(suggestion),
                  onTap: () => _onSuggestionTap(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}

// lib/features/payments/presentation/widgets/payment_quick_filters.dart
class PaymentQuickFilters extends StatelessWidget {
  final Function(String) onFilterTap;
  final String? activeFilter;

  const PaymentQuickFilters({
    Key? key,
    required this.onFilterTap,
    this.activeFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      QuickFilter(id: 'all', label: 'All', icon: Icons.all_inclusive),
      QuickFilter(
        id: 'overdue',
        label: 'Overdue',
        icon: Icons.warning,
        color: Colors.red,
      ),
      QuickFilter(
        id: 'pending',
        label: 'Pending',
        icon: Icons.schedule,
        color: Colors.orange,
      ),
      QuickFilter(
        id: 'paid',
        label: 'Paid',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      QuickFilter(
        id: 'thisMonth',
        label: 'This Month',
        icon: Icons.calendar_month,
      ),
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = activeFilter == filter.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 16,
                    color:
                        isActive
                            ? Theme.of(context).colorScheme.onPrimary
                            : filter.color ??
                                Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(filter.label),
                ],
              ),
              selected: isActive,
              onSelected: (_) => onFilterTap(filter.id),
              backgroundColor: filter.color?.withOpacity(0.1),
              selectedColor:
                  filter.color ?? Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}

class QuickFilter {
  final String id;
  final String label;
  final IconData icon;
  final Color? color;

  const QuickFilter({
    required this.id,
    required this.label,
    required this.icon,
    this.color,
  });
}

// lib/features/payments/presentation/widgets/payment_sort_widget.dart
class PaymentSortWidget extends StatelessWidget {
  final Function(PaymentSortOption) onSortChanged;
  final PaymentSortOption currentSort;

  const PaymentSortWidget({
    Key? key,
    required this.onSortChanged,
    required this.currentSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PaymentSortOption>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sort),
          const SizedBox(width: 4),
          Text(
            _getSortDisplayName(currentSort),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onSelected: onSortChanged,
      itemBuilder:
          (context) =>
              PaymentSortOption.values.map((option) {
                return PopupMenuItem<PaymentSortOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(_getSortIcon(option), size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_getSortDisplayName(option))),
                      if (option == currentSort)
                        Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                );
              }).toList(),
    );
  }

  String _getSortDisplayName(PaymentSortOption option) {
    switch (option) {
      case PaymentSortOption.dueDateDesc:
        return 'Due Date (Latest)';
      case PaymentSortOption.dueDateAsc:
        return 'Due Date (Earliest)';
      case PaymentSortOption.amountDesc:
        return 'Amount (High to Low)';
      case PaymentSortOption.amountAsc:
        return 'Amount (Low to High)';
      case PaymentSortOption.statusDesc:
        return 'Status';
      case PaymentSortOption.paidDateDesc:
        return 'Paid Date (Latest)';
    }
  }

  IconData _getSortIcon(PaymentSortOption option) {
    switch (option) {
      case PaymentSortOption.dueDateDesc:
      case PaymentSortOption.dueDateAsc:
        return Icons.date_range;
      case PaymentSortOption.amountDesc:
      case PaymentSortOption.amountAsc:
        return Icons.attach_money;
      case PaymentSortOption.statusDesc:
        return Icons.info;
      case PaymentSortOption.paidDateDesc:
        return Icons.payment;
    }
  }
}

enum PaymentSortOption {
  dueDateDesc,
  dueDateAsc,
  amountDesc,
  amountAsc,
  statusDesc,
  paidDateDesc,
}

// lib/features/payments/presentation/widgets/advanced_search_sheet.dart
class AdvancedSearchSheet extends StatefulWidget {
  final Function(AdvancedSearchCriteria) onSearchApplied;
  final AdvancedSearchCriteria? initialCriteria;

  const AdvancedSearchSheet({
    Key? key,
    required this.onSearchApplied,
    this.initialCriteria,
  }) : super(key: key);

  @override
  State<AdvancedSearchSheet> createState() => _AdvancedSearchSheetState();
}

class _AdvancedSearchSheetState extends State<AdvancedSearchSheet> {
  late AdvancedSearchCriteria _criteria;
  final _textController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria ?? AdvancedSearchCriteria();
    _textController.text = _criteria.text ?? '';
    _minAmountController.text = _criteria.minAmount?.toString() ?? '';
    _maxAmountController.text = _criteria.maxAmount?.toString() ?? '';
  }

  @override
  void dispose() {
    _textController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Advanced Search',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                TextButton(onPressed: _clearAll, child: const Text('Clear')),
              ],
            ),
          ),

          const Divider(height: 1),

          // Search Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text search
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Search text',
                      hintText: 'Enter keywords...',
                    ),
                    onChanged: (value) {
                      _criteria = _criteria.copyWith(
                        text: value.isEmpty ? null : value,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Amount range
                  Text(
                    'Amount Range',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min Amount',
                            prefixText: '\$',
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value);
                            _criteria = _criteria.copyWith(minAmount: amount);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _maxAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max Amount',
                            prefixText: '\$',
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value);
                            _criteria = _criteria.copyWith(maxAmount: amount);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Include fields
                  Text(
                    'Search In',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Transaction ID'),
                    value: _criteria.includeTransactionId,
                    onChanged: (value) {
                      setState(() {
                        _criteria = _criteria.copyWith(
                          includeTransactionId: value,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Notes'),
                    value: _criteria.includeNotes,
                    onChanged: (value) {
                      setState(() {
                        _criteria = _criteria.copyWith(includeNotes: value);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Tenant Name'),
                    value: _criteria.includeTenantName,
                    onChanged: (value) {
                      setState(() {
                        _criteria = _criteria.copyWith(
                          includeTenantName: value,
                        );
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Property Address'),
                    value: _criteria.includePropertyAddress,
                    onChanged: (value) {
                      setState(() {
                        _criteria = _criteria.copyWith(
                          includePropertyAddress: value,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onSearchApplied(_criteria);
                      Navigator.pop(context);
                    },
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _criteria = AdvancedSearchCriteria();
      _textController.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
    });
  }
}

class AdvancedSearchCriteria {
  final String? text;
  final double? minAmount;
  final double? maxAmount;
  final bool includeTransactionId;
  final bool includeNotes;
  final bool includeTenantName;
  final bool includePropertyAddress;

  const AdvancedSearchCriteria({
    this.text,
    this.minAmount,
    this.maxAmount,
    this.includeTransactionId = true,
    this.includeNotes = true,
    this.includeTenantName = false,
    this.includePropertyAddress = false,
  });

  AdvancedSearchCriteria copyWith({
    String? text,
    double? minAmount,
    double? maxAmount,
    bool? includeTransactionId,
    bool? includeNotes,
    bool? includeTenantName,
    bool? includePropertyAddress,
  }) {
    return AdvancedSearchCriteria(
      text: text ?? this.text,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      includeTransactionId: includeTransactionId ?? this.includeTransactionId,
      includeNotes: includeNotes ?? this.includeNotes,
      includeTenantName: includeTenantName ?? this.includeTenantName,
      includePropertyAddress:
          includePropertyAddress ?? this.includePropertyAddress,
    );
  }

  bool get hasAdvancedCriteria =>
      minAmount != null ||
      maxAmount != null ||
      !includeTransactionId ||
      !includeNotes ||
      includeTenantName ||
      includePropertyAddress;
}
