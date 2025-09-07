// lib/features/leases/presentation/widgets/lease_renewal_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/lease.dart';
import '../bloc/lease_bloc.dart';
import '../bloc/lease_event.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';

class LeaseRenewalDialog extends StatefulWidget {
  final Lease lease;

  const LeaseRenewalDialog({Key? key, required this.lease}) : super(key: key);

  @override
  State<LeaseRenewalDialog> createState() => _LeaseRenewalDialogState();
}

class _LeaseRenewalDialogState extends State<LeaseRenewalDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newEndDateController;
  late TextEditingController _monthlyRentController;
  late TextEditingController _securityDepositController;
  late TextEditingController _renewalTermsController;
  late TextEditingController _notesController;

  DateTime? _newEndDate;
  late double _monthlyRent;
  late double _securityDeposit;
  late RentFrequency _rentFrequency;
  late int _noticePeriodDays;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Calculate suggested new end date (1 year from current end date)
    _newEndDate = widget.lease.endDate.add(const Duration(days: 365));
    _newEndDateController = TextEditingController(
      text: _dateFormatter.format(_newEndDate!),
    );

    // Initialize with current lease values
    _monthlyRent = widget.lease.monthlyRent;
    _monthlyRentController = TextEditingController(
      text: _monthlyRent.toStringAsFixed(2),
    );

    _securityDeposit = widget.lease.securityDeposit;
    _securityDepositController = TextEditingController(
      text: _securityDeposit.toStringAsFixed(2),
    );

    _rentFrequency = widget.lease.rentFrequency;
    _noticePeriodDays = widget.lease.noticePeriodDays;

    _renewalTermsController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _newEndDateController.dispose();
    _monthlyRentController.dispose();
    _securityDepositController.dispose();
    _renewalTermsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCurrentLeaseInfo(),
                      const SizedBox(height: 24),
                      _buildRenewalForm(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.refresh, color: Colors.green, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Renew Lease',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.lease.propertyName} - ${widget.lease.tenantName}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildCurrentLeaseInfo() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Lease Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'End Date',
                    _dateFormatter.format(widget.lease.endDate),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Monthly Rent',
                    '\$${widget.lease.monthlyRent.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Remaining Days',
                    '${widget.lease.remainingDays} days',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Security Deposit',
                    '\$${widget.lease.securityDeposit.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRenewalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renewal Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // New end date
        DatePickerField(
          //  controller: _newEndDateController,
          label: 'New End Date',
          firstDate: widget.lease.endDate.add(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
          onDateSelected: (date) {
            setState(() {
              _newEndDate = date;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select new end date';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Monthly rent
        CurrencyInputField(
          controller: _monthlyRentController,
          labelText: 'New Monthly Rent',
          onChanged: (value) {
            setState(() {
              _monthlyRent = double.tryParse(value) ?? 0.0;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter rent amount';
            }
            final rent = double.tryParse(value);
            if (rent == null || rent <= 0) {
              return 'Please enter a valid rent amount';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Security deposit
        CurrencyInputField(
          controller: _securityDepositController,
          labelText: 'Security Deposit',
          onChanged: (value) {
            setState(() {
              _securityDeposit = double.tryParse(value) ?? 0.0;
            });
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter security deposit amount';
            }
            final deposit = double.tryParse(value);
            if (deposit == null || deposit < 0) {
              return 'Please enter a valid security deposit amount';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Rent frequency
        DropdownButtonFormField<RentFrequency>(
          value: _rentFrequency,
          decoration: const InputDecoration(
            labelText: 'Rent Frequency',
            border: OutlineInputBorder(),
          ),
          items:
              RentFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(_formatRentFrequency(frequency)),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _rentFrequency = value!;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select rent frequency';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Notice period
        CustomTextField(
          labelText: 'Notice Period (Days)',
          initialValue: _noticePeriodDays.toString(),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _noticePeriodDays = int.tryParse(value) ?? 30;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter notice period';
            }
            final days = int.tryParse(value);
            if (days == null || days < 1) {
              return 'Please enter a valid number of days';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Renewal terms
        CustomTextField(
          controller: _renewalTermsController,
          labelText: 'Special Renewal Terms (Optional)',
          maxLines: 3,
          hintText: 'Any special terms or conditions for the renewal...',
        ),

        const SizedBox(height: 16),

        // Notes
        CustomTextField(
          controller: _notesController,
          labelText: 'Renewal Notes (Optional)',
          maxLines: 2,
          hintText: 'Additional notes about the renewal...',
        ),

        const SizedBox(height: 24),

        // Renewal summary
        _buildRenewalSummary(),
      ],
    );
  }

  Widget _buildRenewalSummary() {
    if (_newEndDate == null) return const SizedBox.shrink();

    final extensionDays = _newEndDate!.difference(widget.lease.endDate).inDays;
    final totalRentIncrease =
        (_monthlyRent - widget.lease.monthlyRent) * (extensionDays / 30).ceil();

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Renewal Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            _buildSummaryRow('Extension Period', '$extensionDays days'),
            _buildSummaryRow(
              'Rent Change',
              totalRentIncrease >= 0
                  ? '+\${totalRentIncrease.toStringAsFixed(2)}'
                  : '-\${(-totalRentIncrease).toStringAsFixed(2)}',
              isPositive: totalRentIncrease >= 0,
            ),
            _buildSummaryRow(
              'New Monthly Rent',
              '\${_monthlyRent.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'New End Date',
              _dateFormatter.format(_newEndDate!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool? isPositive}) {
    Color? valueColor;
    if (isPositive != null) {
      valueColor = isPositive ? Colors.green : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.grey,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: CustomButton(
            text: 'Renew Lease',
            onPressed: _handleRenewal,
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  void _handleRenewal() {
    if (_formKey.currentState!.validate() && _newEndDate != null) {
      // Create renewal event
      // context.read<LeaseBloc>().add(
      //   RenewLeaseEvent(
      //     leaseId: widget.lease.id,
      //     newEndDate: _newEndDate!,
      //     newMonthlyRent: _monthlyRent,
      //     newSecurityDeposit: _securityDeposit,
      //     rentFrequency: _rentFrequency,
      //     noticePeriodDays: _noticePeriodDays,
      //     renewalTerms:
      //         _renewalTermsController.text.trim().isEmpty
      //             ? null
      //             : _renewalTermsController.text.trim(),
      //     notes:
      //         _notesController.text.trim().isEmpty
      //             ? null
      //             : _notesController.text.trim(),
      //   ),
      // );
      Navigator.of(context).pop();
    }
  }

  String _formatRentFrequency(RentFrequency frequency) {
    switch (frequency) {
      case RentFrequency.monthly:
        return 'Monthly';
      case RentFrequency.quarterly:
        return 'Quarterly';
      case RentFrequency.biannual:
        return 'Bi-annual';
      case RentFrequency.annual:
        return 'Annual';
    }
  }
}
