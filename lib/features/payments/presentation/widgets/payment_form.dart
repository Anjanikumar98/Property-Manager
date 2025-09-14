// lib/features/payments/presentation/widgets/payment_form.dart
import 'package:flutter/material.dart';
import 'package:property_manager/core/utlis/validators.dart';
import 'package:property_manager/features/tenants/domain/entities/tenant.dart'
    show PaymentMethod;
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
  PaymentMethod? _paymentMethod;

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

    // Convert string payment method to enum
    if (payment.paymentMethod != null) {
      _paymentMethod = _parsePaymentMethod(payment.paymentMethod!);
    }
  }

  PaymentMethod? _parsePaymentMethod(String methodString) {
    switch (methodString.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'check':
        return PaymentMethod.check;
      case 'bank_transfer':
      case 'banktransfer':
        return PaymentMethod.bankTransfer;
      case 'credit_card':
      case 'creditcard':
        return PaymentMethod.creditCard;
      case 'debit_card':
      case 'debitcard':
        return PaymentMethod.debitCard;
      case 'online_payment':
      case 'onlinepayment':
        return PaymentMethod.onlinePayment;
      case 'other':
        return PaymentMethod.other;
      default:
        return null;
    }
  }

  String? _paymentMethodToString(PaymentMethod? method) {
    if (method == null) return null;

    switch (method) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.check:
        return 'check';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.onlinePayment:
        return 'online_payment';
      case PaymentMethod.other:
        return 'other';
    }
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
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                        _notifyChange();
                      });
                    }
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

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
          PaymentType.values.where((type) => type != PaymentType.utilities).map(
            (type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_getTypeDisplayName(type)),
              );
            },
          ).toList(),
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
    return DropdownButtonFormField<PaymentMethod>(
      value: _paymentMethod,
      decoration: const InputDecoration(
        labelText: 'Payment Method',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<PaymentMethod>(
          value: null,
          child: Text('Select Method'),
        ),
        ...PaymentMethod.values.map((method) {
          return DropdownMenuItem<PaymentMethod>(
            value: method,
            child: Text(_getMethodDisplayName(method)),
          );
        }),
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
      case PaymentType.utility:
      case PaymentType.utilities:
        return 'Utilities';
      case PaymentType.maintenance:
        return 'Maintenance';
      case PaymentType.lateFee:
        return 'Late Fee';
      case PaymentType.other:
        return 'Other';
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
        return 'Paid';
      case PaymentStatus.partial:
        return 'Partial';
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
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.onlinePayment:
        return 'Online Payment';
      case PaymentMethod.other:
        return 'Other';
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
      paymentMethod: _paymentMethodToString(_paymentMethod),
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
