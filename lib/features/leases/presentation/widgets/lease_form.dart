// lib/features/leases/presentation/widgets/lease_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';
import '../../domain/entities/lease.dart';
import '../../data/models/lease_model.dart';

class LeaseForm extends StatefulWidget {
  final Lease? lease;
  final List<PropertyOption> properties;
  final List<TenantOption> tenants;
  final Function(Lease) onSubmit;
  final VoidCallback? onCancel;

  const LeaseForm({
    super.key,
    this.lease,
    required this.properties,
    required this.tenants,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<LeaseForm> createState() => _LeaseFormState();
}

class _LeaseFormState extends State<LeaseForm> {

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  late String? _selectedPropertyId;
  late String? _selectedTenantId;
  late LeaseType _selectedLeaseType;
  late RentFrequency _selectedRentFrequency;
  late DateTime _startDate;
  late DateTime _endDate;
  late TextEditingController _monthlyRentController;
  late TextEditingController _securityDepositController;
  late TextEditingController _noticePeriodController;
  late TextEditingController _specialTermsController;
  late TextEditingController _notesController;

  // Calculated fields
  int _totalDays = 0;
  double _totalRent = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.lease != null) {
      final lease = widget.lease!;
      _selectedPropertyId = lease.propertyId;
      _selectedTenantId = lease.tenantId;
      _selectedLeaseType = lease.leaseType;
      _selectedRentFrequency = lease.rentFrequency;
      _startDate = lease.startDate;
      _endDate = lease.endDate;
      _monthlyRentController = TextEditingController(
        text: lease.monthlyRent.toString(),
      );
      _securityDepositController = TextEditingController(
        text: lease.securityDeposit.toString(),
      );
      _noticePeriodController = TextEditingController(
        text: lease.noticePeriodDays.toString(),
      );
      _specialTermsController = TextEditingController(
        text: lease.specialTerms ?? '',
      );
      _notesController = TextEditingController(text: lease.notes ?? '');
    } else {
      _selectedPropertyId = null;
      _selectedTenantId = null;
      _selectedLeaseType = LeaseType.residential;
      _selectedRentFrequency = RentFrequency.monthly;
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 365));
      _monthlyRentController = TextEditingController();
      _securityDepositController = TextEditingController();
      _noticePeriodController = TextEditingController(text: '30');
      _specialTermsController = TextEditingController();
      _notesController = TextEditingController();
    }
    _calculateTotals();
  }

  void _calculateTotals() {
    _totalDays = _endDate.difference(_startDate).inDays;
    final monthlyRent = double.tryParse(_monthlyRentController.text) ?? 0.0;
    final months = (_totalDays / 30).ceil();
    _totalRent = monthlyRent * months;
  }

  @override
  void dispose() {
    _monthlyRentController.dispose();
    _securityDepositController.dispose();
    _noticePeriodController.dispose();
    _specialTermsController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInformation(),
                const SizedBox(height: 24),
                _buildPropertyAndTenant(),
                const SizedBox(height: 24),
                _buildLeaseDates(),
                const SizedBox(height: 24),
                _buildFinancialDetails(),
                const SizedBox(height: 24),
                _buildLeaseTerms(),
                const SizedBox(height: 24),
                _buildAdditionalDetails(),
                const SizedBox(height: 24),
                _buildSummary(),
                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<LeaseType>(
                    value: _selectedLeaseType,
                    decoration: const InputDecoration(
                      labelText: 'Lease Type',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        LeaseType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_formatLeaseType(type)),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLeaseType = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a lease type';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<RentFrequency>(
                    value: _selectedRentFrequency,
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
                      if (value != null) {
                        setState(() {
                          _selectedRentFrequency = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyAndTenant() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property & Tenant',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPropertyId,
              decoration: const InputDecoration(
                labelText: 'Select Property',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
              items:
                  widget.properties.map((property) {
                    return DropdownMenuItem(
                      value: property.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(property.name),
                          Text(
                            property.address,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPropertyId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a property';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTenantId,
              decoration: const InputDecoration(
                labelText: 'Select Tenant',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              items:
                  widget.tenants.map((tenant) {
                    return DropdownMenuItem(
                      value: tenant.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tenant.name),
                          Text(
                            tenant.email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTenantId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a tenant';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaseDates() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lease Period', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: 'Start Date',
                    firstDate: _startDate,
                    onDateSelected: (date) {
                      setState(() {
                        _startDate = date!;
                        if (_startDate.isAfter(_endDate)) {
                          _endDate = _startDate.add(const Duration(days: 365));
                        }
                        _calculateTotals();
                      });
                    },
                    validator: (date) {
                      if (date == null) return 'Please select start date';
                      if (date.isBefore(
                        DateTime.now().subtract(const Duration(days: 1)),
                      )) {
                        return 'Start date cannot be in the past';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DatePickerField(
                    label: 'End Date',
                    lastDate: _endDate,
                    onDateSelected: (date) {
                      setState(() {
                        _endDate = date!;
                        _calculateTotals();
                      });
                    },
                    validator: (date) {
                      if (date == null) return 'Please select end date';
                      if (date.isBefore(_startDate)) {
                        return 'End date must be after start date';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '$_totalDays days',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Months',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${(_totalDays / 30).ceil()}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CurrencyInputField(
                    controller: _monthlyRentController,
                    labelText: 'Monthly Rent',
                    onChanged: (value) {
                      setState(() {
                        _calculateTotals();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter monthly rent';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CurrencyInputField(
                    controller: _securityDepositController,
                    labelText: 'Security Deposit',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter security deposit';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount < 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Rent for Lease Period:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '₹${_totalRent.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaseTerms() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lease Terms', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _noticePeriodController,
              labelText: 'Notice Period (Days)',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notice period';
                }
                final days = int.tryParse(value);
                if (days == null || days < 0) {
                  return 'Please enter valid number of days';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _specialTermsController,
              labelText: 'Special Terms & Conditions',
              maxLines: 3,
              hintText:
                  'Enter any special terms or conditions for this lease...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes',
              maxLines: 3,
              hintText: 'Add any additional notes or comments...',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final property = widget.properties.firstWhere(
      (p) => p.id == _selectedPropertyId,
      orElse:
          () => PropertyOption(id: '', name: 'Select Property', address: ''),
    );
    final tenant = widget.tenants.firstWhere(
      (t) => t.id == _selectedTenantId,
      orElse: () => TenantOption(id: '', name: 'Select Tenant', email: ''),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lease Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Property', property.name),
            _buildSummaryRow('Tenant', tenant.name),
            _buildSummaryRow('Type', _formatLeaseType(_selectedLeaseType)),
            _buildSummaryRow(
              'Period',
              '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
            ),
            _buildSummaryRow('Duration', '$_totalDays days'),
            _buildSummaryRow('Monthly Rent', '₹${_monthlyRentController.text}'),
            _buildSummaryRow(
              'Security Deposit',
              '₹${_securityDepositController.text}',
            ),
            _buildSummaryRow('Total Rent', '₹${_totalRent.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.onCancel != null) ...[
          Expanded(
            child: CustomButton(
              text: 'Cancel',
              onPressed: widget.onCancel!,
              //  isOutlined: true,
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: CustomButton(
            text: widget.lease == null ? 'Create Lease' : 'Update Lease',
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final property = widget.properties.firstWhere(
      (p) => p.id == _selectedPropertyId!,
    );
    final tenant = widget.tenants.firstWhere((t) => t.id == _selectedTenantId!);

    final lease = LeaseModel.create(
      propertyId: _selectedPropertyId!,
      tenantId: _selectedTenantId!,
      propertyName: property.name,
      tenantName: tenant.name,
      leaseType: _selectedLeaseType,
      startDate: _startDate,
      endDate: _endDate,
      monthlyRent: double.parse(_monthlyRentController.text),
      securityDeposit: double.parse(_securityDepositController.text),
      rentFrequency: _selectedRentFrequency,
      noticePeriodDays: int.parse(_noticePeriodController.text),
      specialTerms:
          _specialTermsController.text.isEmpty
              ? null
              : _specialTermsController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    widget.onSubmit(lease);
  }

  String _formatLeaseType(LeaseType type) {
    switch (type) {
      case LeaseType.residential:
        return 'Residential';
      case LeaseType.commercial:
        return 'Commercial';
      case LeaseType.shortTerm:
        return 'Short Term';
      case LeaseType.longTerm:
        return 'Long Term';
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Helper classes for dropdowns
class PropertyOption {
  final String id;
  final String name;
  final String address;

  PropertyOption({required this.id, required this.name, required this.address});
}

class TenantOption {
  final String id;
  final String name;
  final String email;

  TenantOption({required this.id, required this.name, required this.email});
}

