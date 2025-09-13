// // lib/features/payments/presentation/pages/record_payment_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:property_manager/core/utlis/validators.dart';
// import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';
// import '../../../../shared/widgets/custom_app_bar.dart';
// import '../../../../shared/widgets/custom_button.dart';
// import '../../../../shared/widgets/custom_text_field.dart';
// import '../../../../shared/widgets/date_picker_field.dart';
// import '../../../../shared/widgets/currency_input_field.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../domain/entities/payment.dart';
// import '../../data/models/payment_model.dart';
// import '../bloc/payment_bloc.dart';
// import '../bloc/payment_event.dart';
// import '../bloc/payment_state.dart';
// import '../widgets/payment_form.dart';
// import '../widgets/payment_status_indicator.dart';
//
// class RecordPaymentPage extends StatefulWidget {
//   final String? leaseId;
//   final String? tenantId;
//   final String? propertyId;
//   final Payment? existingPayment;
//
//   const RecordPaymentPage({
//     Key? key,
//     this.leaseId,
//     this.tenantId,
//     this.propertyId,
//     this.existingPayment,
//   }) : super(key: key);
//
//   @override
//   State<RecordPaymentPage> createState() => _RecordPaymentPageState();
// }
//
// class _RecordPaymentPageState extends State<RecordPaymentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountController = TextEditingController();
//   final _paidAmountController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _referenceController = TextEditingController();
//
//   PaymentType _selectedType = PaymentType.rent;
//   PaymentStatus _selectedStatus = PaymentStatus.pending;
//   DateTime _dueDate = DateTime.now();
//   DateTime? _paidDate;
//   String? _paymentMethod;
//   bool _calculateLateFees = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeForm();
//   }
//
//   void _initializeForm() {
//     if (widget.existingPayment != null) {
//       final payment = widget.existingPayment!;
//       _amountController.text = payment.amount.toStringAsFixed(2);
//       _paidAmountController.text = payment.paidAmount.toStringAsFixed(2);
//       _descriptionController.text = payment.description ?? '';
//       _referenceController.text = payment.reference ?? '';
//       _selectedType = payment.type;
//       _selectedStatus = payment.status;
//       _dueDate = payment.dueDate;
//       _paidDate = payment.paidDate;
//       _paymentMethod = payment.paymentMethod;
//     } else {
//       // Generate reference for new payment
//       _referenceController.text = PaymentBusinessRules.generatePaymentReference(
//         propertyId: widget.propertyId ?? '',
//         type: _selectedType,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title:
//             widget.existingPayment != null ? 'Edit Payment' : 'Record Payment',
//         actions: [
//           if (widget.existingPayment != null)
//             IconButton(
//               icon: const Icon(Icons.calculate),
//               onPressed: _showLateFeeCalculation,
//               tooltip: 'Calculate Late Fees',
//             ),
//         ],
//       ),
//       body: BlocListener<PaymentBloc, PaymentState>(
//         listener: (context, state) {
//           if (state is PaymentRecorded || state is PaymentUpdated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   widget.existingPayment != null
//                       ? 'Payment updated successfully'
//                       : 'Payment recorded successfully',
//                 ),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.of(context).pop(true);
//           } else if (state is PaymentError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<PaymentBloc, PaymentState>(
//           builder: (context, state) {
//             if (state is PaymentLoading) {
//               return const LoadingWidget();
//             }
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (widget.existingPayment != null) ...[
//                       PaymentStatusIndicator(payment: widget.existingPayment!),
//                       const SizedBox(height: 16),
//                     ],
//
//                     _buildPaymentTypeSection(),
//                     const SizedBox(height: 16),
//
//                     _buildAmountSection(),
//                     const SizedBox(height: 16),
//
//                     _buildDateSection(),
//                     const SizedBox(height: 16),
//
//                     _buildPaymentDetailsSection(),
//                     const SizedBox(height: 16),
//
//                     _buildStatusSection(),
//                     const SizedBox(height: 24),
//
//                     _buildActionButtons(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentTypeSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Payment Type',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<PaymentType>(
//               value: _selectedType,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//               ),
//               items:
//                   PaymentType.values.map((type) {
//                     return DropdownMenuItem(
//                       value: type,
//                       child: Text(type.name.toUpperCase()),
//                     );
//                   }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     _selectedType = value;
//                     if (widget.existingPayment == null) {
//                       _referenceController
//                           .text = PaymentBusinessRules.generatePaymentReference(
//                         propertyId: widget.propertyId ?? '',
//                         type: value,
//                       );
//                     }
//                   });
//                 }
//               },
//               validator: (value) {
//                 if (value == null) return 'Please select a payment type';
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAmountSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Payment Amounts',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             CurrencyInputField(
//               controller: _amountController,
//               labelText: 'Total Amount Due',
//               hintText: '0.00',
//               validator: Validators.validateAmount,
//               onChanged: (_) => _calculateTotals(),
//             ),
//             const SizedBox(height: 12),
//
//             CurrencyInputField(
//               controller: _paidAmountController,
//               labelText: 'Amount Paid',
//               hintText: '0.00',
//               validator: (value) {
//                 final amount = double.tryParse(value ?? '');
//                 final totalDue = double.tryParse(_amountController.text) ?? 0.0;
//
//                 if (amount == null || amount < 0) {
//                   return 'Please enter a valid amount';
//                 }
//                 if (amount > totalDue * 1.5) {
//                   // Allow some overpayment
//                   return 'Paid amount seems too high';
//                 }
//                 return null;
//               },
//               onChanged: (_) => _calculateTotals(),
//             ),
//             const SizedBox(height: 8),
//
//             _buildPaymentCalculations(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentCalculations() {
//     final amount = double.tryParse(_amountController.text) ?? 0.0;
//     final paidAmount = double.tryParse(_paidAmountController.text) ?? 0.0;
//     final remainingAmount = amount - paidAmount;
//
//     // Calculate late fee if overdue
//     double lateFee = 0.0;
//     if (_calculateLateFees && DateTime.now().isAfter(_dueDate)) {
//       final daysOverdue = DateTime.now().difference(_dueDate).inDays;
//       lateFee = PaymentBusinessRules.calculateLateFee(
//         rentAmount: amount,
//         daysOverdue: daysOverdue,
//       );
//     }
//
//     final totalDue = amount + lateFee;
//     final totalRemaining = totalDue - paidAmount;
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Remaining Amount:'),
//               Text(
//                 CurrencyFormatter.format(remainingAmount),
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: remainingAmount > 0 ? Colors.red : Colors.green,
//                 ),
//               ),
//             ],
//           ),
//           if (lateFee > 0) ...[
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Late Fee:'),
//                 Text(
//                   CurrencyFormatter.format(lateFee),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Total Remaining:'),
//                 Text(
//                   CurrencyFormatter.format(totalRemaining),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Dates',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             DatePickerField(
//               label: 'Due Date',
//               selectedDate: _dueDate,
//               onDateSelected: (date) {
//                 setState(() {
//                   _dueDate = date!;
//                   _calculateTotals();
//                 });
//               },
//               validator: (date) {
//                 if (date == null) return 'Please select a due date';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//
//             DatePickerField(
//               label: 'Payment Date (Optional)',
//               selectedDate: _paidDate,
//               onDateSelected: (date) {
//                 setState(() {
//                   _paidDate = date;
//                 });
//               },
//               //    clearable: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentDetailsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Payment Details',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             CustomTextField(
//               controller: _referenceController,
//               labelText: 'Reference Number',
//               hintText: 'Enter reference number',
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a reference number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 12),
//
//             DropdownButtonFormField<String>(
//               value: _paymentMethod,
//               decoration: const InputDecoration(
//                 labelText: 'Payment Method',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'cash', child: Text('Cash')),
//                 DropdownMenuItem(value: 'check', child: Text('Check')),
//                 DropdownMenuItem(
//                   value: 'bank_transfer',
//                   child: Text('Bank Transfer'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'credit_card',
//                   child: Text('Credit Card'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'mobile_payment',
//                   child: Text('Mobile Payment'),
//                 ),
//                 DropdownMenuItem(value: 'other', child: Text('Other')),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _paymentMethod = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 12),
//
//             CustomTextField(
//               controller: _descriptionController,
//               labelText: 'Description (Optional)',
//               hintText: 'Enter payment description',
//               maxLines: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Status & Options',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             DropdownButtonFormField<PaymentStatus>(
//               value: _selectedStatus,
//               decoration: const InputDecoration(
//                 labelText: 'Payment Status',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//               ),
//               items:
//                   PaymentStatus.values.map((status) {
//                     return DropdownMenuItem(
//                       value: status,
//                       child: Text(status.name.toUpperCase()),
//                     );
//                   }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     _selectedStatus = value;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 12),
//
//             CheckboxListTile(
//               title: const Text('Calculate Late Fees Automatically'),
//               subtitle: const Text('Apply late fees for overdue payments'),
//               value: _calculateLateFees,
//               onChanged: (value) {
//                 setState(() {
//                   _calculateLateFees = value ?? false;
//                   _calculateTotals();
//                 });
//               },
//               controlAffinity: ListTileControlAffinity.leading,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: CustomButton(
//             text: 'Cancel',
//             onPressed: () => Navigator.of(context).pop(),
//             backgroundColor: Colors.grey,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: CustomButton(
//             text:
//                 widget.existingPayment != null
//                     ? 'Update Payment'
//                     : 'Record Payment',
//             onPressed: _submitPayment,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _calculateTotals() {
//     setState(() {
//       // This triggers a rebuild which updates the calculation display
//     });
//   }
//
//   void _submitPayment() {
//     if (_formKey.currentState!.validate()) {
//       final amount = double.parse(_amountController.text);
//       final paidAmount = double.parse(_paidAmountController.text);
//
//       // Calculate late fee
//       double lateFee = 0.0;
//       if (_calculateLateFees && DateTime.now().isAfter(_dueDate)) {
//         final daysOverdue = DateTime.now().difference(_dueDate).inDays;
//         lateFee = PaymentBusinessRules.calculateLateFee(
//           rentAmount: amount,
//           daysOverdue: daysOverdue,
//         );
//       }
//
//       // Calculate status
//       final status = PaymentBusinessRules.updatePaymentStatus(
//         amount: amount,
//         paidAmount: paidAmount,
//         lateFee: lateFee,
//         dueDate: _dueDate,
//       );
//
//       final payment = PaymentModel(
//         id:
//             widget.existingPayment?.id ??
//             DateTime.now().millisecondsSinceEpoch.toString(),
//         leaseId: widget.leaseId ?? widget.existingPayment?.leaseId ?? '',
//         tenantId: widget.tenantId ?? widget.existingPayment?.tenantId ?? '',
//         propertyId:
//             widget.propertyId ?? widget.existingPayment?.propertyId ?? '',
//         type: _selectedType,
//         status: status,
//         amount: amount,
//         paidAmount: paidAmount,
//         lateFee: lateFee,
//         dueDate: _dueDate,
//         paidDate: paidAmount > 0 ? (_paidDate ?? DateTime.now()) : null,
//         createdAt: widget.existingPayment?.createdAt ?? DateTime.now(),
//         updatedAt: DateTime.now(),
//         description:
//             _descriptionController.text.trim().isEmpty
//                 ? null
//                 : _descriptionController.text.trim(),
//         reference: _referenceController.text.trim(),
//         paymentMethod: _paymentMethod,
//       );
//
//       if (widget.existingPayment != null) {
//         context.read<PaymentBloc>().add(UpdatePayment(payment));
//       } else {
//         context.read<PaymentBloc>().add(RecordPayment(payment));
//       }
//     }
//   }
//
//   void _showLateFeeCalculation() {
//     final amount = double.tryParse(_amountController.text) ?? 0.0;
//     if (amount == 0) return;
//
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Late Fee Calculation'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Base Amount: ${CurrencyFormatter.format(amount)}'),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Days Overdue: ${DateTime.now().difference(_dueDate).inDays}',
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Late Fee Rate: ${PaymentBusinessRules.defaultLateFeePercentage}%',
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Maximum Late Fee: ${CurrencyFormatter.format(PaymentBusinessRules.defaultMaximumLateFee)}',
//                 ),
//                 const SizedBox(height: 12),
//                 const Divider(),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Calculated Late Fee: ${CurrencyFormatter.format(PaymentBusinessRules.calculateLateFee(rentAmount: amount, daysOverdue: DateTime.now().difference(_dueDate).inDays))}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     _paidAmountController.dispose();
//     _descriptionController.dispose();
//     _referenceController.dispose();
//     super.dispose();
//   }
// }
