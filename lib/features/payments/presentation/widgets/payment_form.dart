// lib/features/payments/presentation/widgets/payment_form.dart
import 'package:flutter/material.dart';
import 'package:property_manager/core/utlis/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';
import '../../domain/entities/payment.dart';

class PaymentFormWidget extends StatefulWidget {
  final Payment? initialPayment;
  final Function(Payment) onPaymentChanged;
  final bool showAdvancedOptions;

  const PaymentFormWidget({
    Key? key,
    this.initialPayment,
    required this.onPaymentChanged,
    this.showAdvancedOptions = false,
  }) : super(key: key);

  @override
  State<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState extends State<PaymentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceController = TextEditingController();

  PaymentType _selectedType = PaymentType.rent;
  PaymentStatus _selectedStatus = PaymentStatus.pending;
  DateTime _dueDate = DateTime.now();
  DateTime? _paidDate;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    if (widget.initialPayment != null) {
      _initializeFromPayment(widget.initialPayment!);
    }
  }

  void _initializeFromPayment(Payment payment) {
    _amountController.text = payment.amount.toStringAsFixed(2);
    _paidAmountController.text = payment.paidAmount.toStringAsFixed(2);
    _descriptionController.text = payment.description ?? '';
    _referenceController.text = payment.reference ?? '';
    _selectedType = payment.type;
    _selectedStatus = payment.status;
    _dueDate = payment.dueDate;
    _paidDate = payment.paidDate;
    _paymentMethod = payment.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeDropdown(),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CurrencyInputField(
                  controller: _amountController,
                  labelText: 'Amount Due',
                  validator: Validators.validateAmount,
                  onChanged: (_) => _notifyChange(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CurrencyInputField(
                  controller: _paidAmountController,
                  labelText: 'Amount Paid',
                  validator: (value) {
                    final paid = double.tryParse(value ?? '') ?? 0;
                    final due = double.tryParse(_amountController.text) ?? 0;
                    if (paid < 0) return 'Amount cannot be negative';
                    if (paid > due * 1.2) return 'Paid amount seems too high';
                    return null;
                  },
                  onChanged: (_) => _notifyChange(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  label: 'Due Date',
                  selectedDate: _dueDate,
                  onDateSelected: (date) {
                    setState(() {
                      _dueDate = date!;
                      _notifyChange();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DatePickerField(
                  label: 'Paid Date',
                  selectedDate: _paidDate,
                  onDateSelected: (date) {
                    setState(() {
                      _paidDate = date;
                      _notifyChange();
                    });
                  },
                  //  clearable: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: _referenceController,
            labelText: 'Reference',
            validator: Validators.validateRequired,
            onChanged: (_) => _notifyChange(),
          ),
          const SizedBox(height: 16),

          if (widget.showAdvancedOptions) ...[
            _buildPaymentMethodDropdown(),
            const SizedBox(height: 16),

            _buildStatusDropdown(),
            const SizedBox(height: 16),
          ],

          CustomTextField(
            controller: _descriptionController,
            labelText: 'Description',
            maxLines: 2,
            onChanged: (_) => _notifyChange(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<PaymentType>(
      value: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Payment Type',
        border: OutlineInputBorder(),
      ),
      items:
          PaymentType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(_getTypeDisplayName(type)),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
            _notifyChange();
          });
        }
      },
      validator: (value) => value == null ? 'Please select a type' : null,
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: _paymentMethod,
      decoration: const InputDecoration(
        labelText: 'Payment Method',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: null, child: Text('Select Method')),
        DropdownMenuItem(value: 'cash', child: Text('Cash')),
        DropdownMenuItem(value: 'check', child: Text('Check')),
        DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
        DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
        DropdownMenuItem(
          value: 'mobile_payment',
          child: Text('Mobile Payment'),
        ),
        DropdownMenuItem(value: 'other', child: Text('Other')),
      ],
      onChanged: (value) {
        setState(() {
          _paymentMethod = value;
          _notifyChange();
        });
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<PaymentStatus>(
      value: _selectedStatus,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      items:
          PaymentStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(_getStatusDisplayName(status)),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedStatus = value;
            _notifyChange();
          });
        }
      },
    );
  }

  String _getTypeDisplayName(PaymentType type) {
    switch (type) {
      case PaymentType.rent:
        return 'Rent';
      case PaymentType.deposit:
        return 'Security Deposit';
      case PaymentType.utilities:
        return 'Utilities';
      case PaymentType.maintenance:
        return 'Maintenance';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.other:
        return 'Other';
      case PaymentType.utility:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getStatusDisplayName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.overdue:
        return 'Overdue';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PaymentStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _notifyChange() {
    if (!mounted) return;

    // Only proceed if form is valid
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;

    // Create updated payment
    final payment = Payment(
      id: widget.initialPayment?.id ?? '',
      leaseId: widget.initialPayment?.leaseId ?? '',
      tenantId: widget.initialPayment?.tenantId ?? '',
      propertyId: widget.initialPayment?.propertyId ?? '',
      type: _selectedType,
      status: _selectedStatus,
      amount: amount,
      paidAmount: paidAmount,
      lateFee: widget.initialPayment?.lateFee ?? 0.0,
      dueDate: _dueDate,
      paidDate: _paidDate,
      createdAt: widget.initialPayment?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      description:
          _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
      reference: _referenceController.text.trim(),
      paymentMethod: _paymentMethod,
    );

    widget.onPaymentChanged(payment);
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    _descriptionController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}


