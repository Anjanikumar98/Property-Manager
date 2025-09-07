// lib/features/leases/presentation/widgets/lease_termination_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/lease.dart';
import '../bloc/lease_bloc.dart';
import '../bloc/lease_event.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/date_picker_field.dart';

class LeaseTerminationDialog extends StatefulWidget {
  final Lease lease;

  const LeaseTerminationDialog({Key? key, required this.lease})
    : super(key: key);

  @override
  State<LeaseTerminationDialog> createState() => _LeaseTerminationDialogState();
}

class _LeaseTerminationDialogState extends State<LeaseTerminationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _terminationDateController;
  late TextEditingController _reasonController;
  late TextEditingController _notesController;

  DateTime? _terminationDate;
  TerminationReason _terminationReason = TerminationReason.mutualAgreement;
  bool _refundSecurityDeposit = true;
  double _deductions = 0.0;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Default termination date to today
    _terminationDate = DateTime.now();
    _terminationDateController = TextEditingController(
      text: _dateFormatter.format(_terminationDate!),
    );

    _reasonController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _terminationDateController.dispose();
    _reasonController.dispose();
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
                      _buildWarningCard(),
                      const SizedBox(height: 24),
                      _buildTerminationForm(),
                      const SizedBox(height: 24),
                      _buildFinancialSummary(),
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
        const Icon(Icons.stop_circle, color: Colors.orange, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terminate Lease',
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

  Widget _buildWarningCard() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Important Notice',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Terminating this lease will end the rental agreement. Please ensure you have followed proper notice requirements.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Termination Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Termination date
        DatePickerField(
          label: 'Termination Date',
          selectedDate: _terminationDate,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: widget.lease.endDate.add(const Duration(days: 30)),
          onDateSelected: (date) {
            setState(() {
              _terminationDate = date;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select termination date';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Termination reason
        DropdownButtonFormField<TerminationReason>(
          value: _terminationReason,
          decoration: const InputDecoration(
            labelText: 'Termination Reason',
            border: OutlineInputBorder(),
          ),
          items:
              TerminationReason.values.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(_formatTerminationReason(reason)),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _terminationReason = value!;
            });
          },
        ),
        const SizedBox(height: 16),

        // Detailed reason
        CustomTextField(
          controller: _reasonController,
          labelText: 'Detailed Reason',
          maxLines: 3,
          hintText: 'Provide specific details about the termination reason...',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide termination reason details';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Security deposit section
        const Text(
          'Security Deposit Handling',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Security deposit refund toggle
        SwitchListTile(
          title: const Text('Refund Security Deposit'),
          subtitle: Text(
            'Current deposit: \$${widget.lease.securityDeposit.toStringAsFixed(2)}',
          ),
          value: _refundSecurityDeposit,
          onChanged: (value) {
            setState(() {
              _refundSecurityDeposit = value;
              if (!value) _deductions = 0.0;
            });
          },
        ),

        if (_refundSecurityDeposit) ...[
          const SizedBox(height: 16),
          CustomTextField(
            labelText: 'Deductions (if any)',
            initialValue: _deductions.toString(),
            keyboardType: TextInputType.number,
            prefixText: '\$',
            onChanged: (value) {
              setState(() {
                _deductions = double.tryParse(value) ?? 0.0;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter deductions (or 0)';
              }
              final deduction = double.tryParse(value) ?? 0.0;
              if (deduction < 0 || deduction > widget.lease.securityDeposit) {
                return 'Deductions must be between \$0 and \$${widget.lease.securityDeposit.toStringAsFixed(2)}';
              }
              return null;
            },
          ),
        ],

        const SizedBox(height: 16),

        // Additional notes
        CustomTextField(
          controller: _notesController,
          labelText: 'Additional Notes (Optional)',
          maxLines: 3,
          hintText: 'Any additional information about the termination...',
        ),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    if (_terminationDate == null) return const SizedBox.shrink();

    final daysEarly = widget.lease.endDate.difference(_terminationDate!).inDays;
    final refundAmount =
        _refundSecurityDeposit
            ? widget.lease.securityDeposit - _deductions
            : 0.0;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Original End Date',
              _dateFormatter.format(widget.lease.endDate),
            ),
            _buildSummaryRow(
              'Termination Date',
              _dateFormatter.format(_terminationDate!),
            ),
            if (daysEarly > 0)
              _buildSummaryRow(
                'Early Termination',
                '$daysEarly days early',
                color: Colors.orange,
              ),
            _buildSummaryRow(
              'Security Deposit',
              '\$${widget.lease.securityDeposit.toStringAsFixed(2)}',
            ),
            if (_refundSecurityDeposit) ...[
              if (_deductions > 0)
                _buildSummaryRow(
                  'Deductions',
                  '-\$${_deductions.toStringAsFixed(2)}',
                  color: Colors.red,
                ),
              _buildSummaryRow(
                'Refund Amount',
                '\$${refundAmount.toStringAsFixed(2)}',
                color: Colors.green,
              ),
            ] else
              _buildSummaryRow(
                'Refund Amount',
                '\$0.00 (Not refunding)',
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
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
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
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
            text: 'Terminate Lease',
            onPressed: _handleTermination,
            backgroundColor: Colors.orange,
          ),
        ),
      ],
    );
  }

  void _handleTermination() {
    if (_formKey.currentState!.validate() && _terminationDate != null) {
      // Show confirmation dialog
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Termination'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Are you sure you want to terminate this lease?'),
                const SizedBox(height: 16),
                Text(
                  'Termination Date: ${_dateFormatter.format(_terminationDate!)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Reason: ${_formatTerminationReason(_terminationReason)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_refundSecurityDeposit)
                  Text(
                    'Security Deposit Refund: \$${(widget.lease.securityDeposit - _deductions).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close termination dialog

                  // Dispatch termination event
                  // context.read<LeaseBloc>().add(
                  //   TerminateLeaseEvent(
                  //     leaseId: widget.lease.id,
                  //     terminationDate: _terminationDate!,
                  //     reason: _terminationReason,
                  //     reasonDetails: _reasonController.text.trim(),
                  //     refundSecurityDeposit: _refundSecurityDeposit,
                  //     deductions: _deductions,
                  //     notes: _notesController.text.trim().isEmpty
                  //         ? null
                  //         : _notesController.text.trim(),
                  //   ),
                  // );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
                child: const Text('Terminate'),
              ),
            ],
          ),
    );
  }

  String _formatTerminationReason(TerminationReason reason) {
    switch (reason) {
      case TerminationReason.mutualAgreement:
        return 'Mutual Agreement';
      case TerminationReason.tenantBreach:
        return 'Tenant Breach of Contract';
      case TerminationReason.landlordBreach:
        return 'Landlord Breach of Contract';
      case TerminationReason.nonPayment:
        return 'Non-payment of Rent';
      case TerminationReason.propertyDamage:
        return 'Property Damage';
      case TerminationReason.endOfTerm:
        return 'Natural End of Term';
      case TerminationReason.other:
        return 'Other';
    }
  }
}

enum TerminationReason {
  mutualAgreement,
  tenantBreach,
  landlordBreach,
  nonPayment,
  propertyDamage,
  endOfTerm,
  other,
}



