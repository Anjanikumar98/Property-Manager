// lib/features/payments/presentation/widgets/payment_filter_widget.dart
import 'package:flutter/material.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart'
    show PaymentMethod;
import '../../domain/entities/payment.dart';
import '../pages/payment_history_page.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';

class PaymentFilterWidget extends StatefulWidget {
  final PaymentFilter currentFilter;
  final Function(PaymentFilter) onFilterChanged;

  const PaymentFilterWidget({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<PaymentFilterWidget> createState() => _PaymentFilterWidgetState();
}

class _PaymentFilterWidgetState extends State<PaymentFilterWidget> {
  late PaymentFilter _tempFilter;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.currentFilter;
    _minAmountController.text = _tempFilter.minAmount?.toString() ?? '';
    _maxAmountController.text = _tempFilter.maxAmount?.toString() ?? '';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
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
                  'Filter Payments',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Status
                  _buildSectionTitle('Payment Status'),
                  _buildStatusFilter(),
                  const SizedBox(height: 24),

                  // Payment Type
                  _buildSectionTitle('Payment Type'),
                  _buildTypeFilter(),
                  const SizedBox(height: 24),

                  // Payment Method
                  _buildSectionTitle('Payment Method'),
                  _buildMethodFilter(),
                  const SizedBox(height: 24),

                  // Date Range
                  _buildSectionTitle('Date Range'),
                  _buildDateRangeFilter(),
                  const SizedBox(height: 24),

                  // Amount Range
                  _buildSectionTitle('Amount Range'),
                  _buildAmountRangeFilter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
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
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          PaymentStatus.values.map((status) {
            // Skip internal status values that shouldn't be filtered by users
            if (status == PaymentStatus.partiallyPaid ||
                status == PaymentStatus.completed) {
              return const SizedBox.shrink();
            }

            final isSelected = _tempFilter.status == status;
            return FilterChip(
              label: Text(_getStatusDisplayName(status)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(
                    status: selected ? status : null,
                  );
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildTypeFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          PaymentType.values.map((type) {
            // Skip duplicate values
            if (type == PaymentType.utilities) {
              return const SizedBox.shrink();
            }

            final isSelected = _tempFilter.type == type;
            return FilterChip(
              label: Text(_getTypeDisplayName(type)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(
                    type: selected ? type : null,
                  );
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildMethodFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          PaymentMethod.values.map((method) {
            final isSelected = _tempFilter.method == method;
            return FilterChip(
              label: Text(_getMethodDisplayName(method)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _tempFilter = _tempFilter.copyWith(
                    method: selected ? method : null,
                  );
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DatePickerField(
                label: 'From Date',
                selectedDate: _tempFilter.dateRange?.startDate,
                onDateSelected: (date) {
                  if (date != null) {
                    setState(() {
                      final endDate = _tempFilter.dateRange?.endDate ?? date;
                      _tempFilter = _tempFilter.copyWith(
                        dateRange: DateRange(
                          startDate: date,
                          endDate: endDate.isBefore(date) ? date : endDate,
                        ),
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DatePickerField(
                label: 'To Date',
                selectedDate: _tempFilter.dateRange?.endDate,
                onDateSelected: (date) {
                  if (date != null) {
                    setState(() {
                      final startDate =
                          _tempFilter.dateRange?.startDate ?? date;
                      _tempFilter = _tempFilter.copyWith(
                        dateRange: DateRange(
                          startDate: startDate.isAfter(date) ? date : startDate,
                          endDate: date,
                        ),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('This Month'),
              selected: _isThisMonthSelected(),
              onSelected: (selected) => _setDateRangePreset('thisMonth'),
            ),
            FilterChip(
              label: const Text('Last Month'),
              selected: _isLastMonthSelected(),
              onSelected: (selected) => _setDateRangePreset('lastMonth'),
            ),
            FilterChip(
              label: const Text('This Year'),
              selected: _isThisYearSelected(),
              onSelected: (selected) => _setDateRangePreset('thisYear'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountRangeFilter() {
    return Row(
      children: [
        Expanded(
          child: CurrencyInputField(
            controller: _minAmountController,
            labelText: 'Min Amount',
            onChanged: (value) {
              final amount = double.tryParse(value);
              _tempFilter = _tempFilter.copyWith(minAmount: amount);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CurrencyInputField(
            controller: _maxAmountController,
            labelText: 'Max Amount',
            onChanged: (value) {
              final amount = double.tryParse(value);
              _tempFilter = _tempFilter.copyWith(maxAmount: amount);
            },
          ),
        ),
      ],
    );
  }

  bool _isThisMonthSelected() {
    if (_tempFilter.dateRange == null) return false;
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final thisMonthEnd = DateTime(now.year, now.month + 1, 0);

    return _tempFilter.dateRange!.startDate.isAtSameMomentAs(thisMonthStart) &&
        _tempFilter.dateRange!.endDate.isAtSameMomentAs(thisMonthEnd);
  }

  bool _isLastMonthSelected() {
    if (_tempFilter.dateRange == null) return false;
    final now = DateTime.now();
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);

    return _tempFilter.dateRange!.startDate.isAtSameMomentAs(lastMonthStart) &&
        _tempFilter.dateRange!.endDate.isAtSameMomentAs(lastMonthEnd);
  }

  bool _isThisYearSelected() {
    if (_tempFilter.dateRange == null) return false;
    final now = DateTime.now();
    final thisYearStart = DateTime(now.year, 1, 1);
    final thisYearEnd = DateTime(now.year, 12, 31);

    return _tempFilter.dateRange!.startDate.isAtSameMomentAs(thisYearStart) &&
        _tempFilter.dateRange!.endDate.isAtSameMomentAs(thisYearEnd);
  }

  void _setDateRangePreset(String preset) {
    final now = DateTime.now();
    DateRange? range;

    switch (preset) {
      case 'thisMonth':
        range = DateRange(
          startDate: DateTime(now.year, now.month, 1),
          endDate: DateTime(now.year, now.month + 1, 0),
        );
        break;
      case 'lastMonth':
        range = DateRange(
          startDate: DateTime(now.year, now.month - 1, 1),
          endDate: DateTime(now.year, now.month, 0),
        );
        break;
      case 'thisYear':
        range = DateRange(
          startDate: DateTime(now.year, 1, 1),
          endDate: DateTime(now.year, 12, 31),
        );
        break;
    }

    if (range != null) {
      setState(() {
        _tempFilter = _tempFilter.copyWith(dateRange: range);
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilter = const PaymentFilter();
      _minAmountController.clear();
      _maxAmountController.clear();
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(_tempFilter);
    Navigator.pop(context);
  }

  String _getStatusDisplayName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.overdue:
        return 'Overdue';
      case PaymentStatus.partial:
        return 'Partial';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
    }
  }

  String _getTypeDisplayName(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return 'Rent';
      case PaymentType.deposit:
        return 'Deposit';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.maintenance:
        return 'Maintenance';
      case PaymentType.utility:
        return 'Utility';
      case PaymentType.other:
        return 'Other';
      case PaymentType.utilities:
        return 'Utilities';
    }
  }

  String _getMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.onlinePayment:
        return 'Online Payment';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}
