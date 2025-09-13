// // lib/features/payments/presentation/pages/payments_list_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../shared/widgets/custom_app_bar.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../../../shared/widgets/error_widget.dart';
// import '../../domain/entities/payment.dart';
// import '../bloc/payment_bloc.dart';
// import '../bloc/payment_event.dart';
// import '../bloc/payment_state.dart';
// import '../widgets/payment_card.dart';
// import '../widgets/payment_summary_card.dart';
// import 'record_payment_page.dart';
//
// class PaymentsListPage extends StatefulWidget {
//   final String? leaseId;
//   final String? tenantId;
//   final String? propertyId;
//
//   const PaymentsListPage({
//     Key? key,
//     this.leaseId,
//     this.tenantId,
//     this.propertyId,
//   }) : super(key: key);
//
//   @override
//   State<PaymentsListPage> createState() => _PaymentsListPageState();
// }
//
// class _PaymentsListPageState extends State<PaymentsListPage>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   PaymentStatus? _selectedStatus;
//   PaymentType? _selectedType;
//   bool _showSummary = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _loadPayments();
//
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         _onTabChanged(_tabController.index);
//       }
//     });
//   }
//
//   void _loadPayments() {
//     context.read<PaymentBloc>().add(
//       LoadPayments(
//         leaseId: widget.leaseId,
//         tenantId: widget.tenantId,
//         propertyId: widget.propertyId,
//         status: _selectedStatus,
//       ),
//     );
//   }
//
//   void _onTabChanged(int index) {
//     setState(() {
//       switch (index) {
//         case 0:
//           _selectedStatus = null;
//           break;
//         case 1:
//           _selectedStatus = PaymentStatus.pending;
//           break;
//         case 2:
//           _selectedStatus = PaymentStatus.overdue;
//           break;
//         case 3:
//           _selectedStatus = PaymentStatus.completed;
//           break;
//       }
//     });
//     _loadPayments();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Payments',
//         actions: [
//           IconButton(
//             icon: Icon(_showSummary ? Icons.visibility_off : Icons.visibility),
//             onPressed: () {
//               setState(() {
//                 _showSummary = !_showSummary;
//               });
//             },
//             tooltip: _showSummary ? 'Hide Summary' : 'Show Summary',
//           ),
//           PopupMenuButton<String>(
//             onSelected: _onMenuSelected,
//             itemBuilder:
//                 (context) => [
//                   const PopupMenuItem(
//                     value: 'calculate_late_fees',
//                     child: ListTile(
//                       leading: Icon(Icons.calculate),
//                       title: Text('Calculate Late Fees'),
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'generate_report',
//                     child: ListTile(
//                       leading: Icon(Icons.assessment),
//                       title: Text('Generate Report'),
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'export_data',
//                     child: ListTile(
//                       leading: Icon(Icons.download),
//                       title: Text('Export Data'),
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ],
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Pending'),
//             Tab(text: 'Overdue'),
//             Tab(text: 'Paid'),
//           ],
//         ),
//       ),
//       body: BlocConsumer<PaymentBloc, PaymentState>(
//         listener: (context, state) {
//           if (state is PaymentError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else if (state is LateFeesCalculated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Late fees calculated for ${state.updatedPayments.length} payments. '
//                   'Total fees added: \$${state.totalLateFeesAdded.toStringAsFixed(2)}',
//                 ),
//                 backgroundColor: Colors.green,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//             _loadPayments(); // Refresh the list
//           }
//         },
//         builder: (context, state) {
//           if (state is PaymentLoading) {
//             return const LoadingWidget();
//           } else if (state is PaymentError) {
//             return CustomErrorWidget(
//               message: state.message,
//               onRetry: _loadPayments,
//             );
//           } else if (state is PaymentLoaded) {
//             return _buildPaymentsList(state);
//           }
//
//           return const Center(child: Text('No payments data available'));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToAddPayment,
//         tooltip: 'Add Payment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildPaymentsList(PaymentLoaded state) {
//     return Column(
//       children: [
//         if (_showSummary)
//           PaymentSummaryCard(
//             totalDue: state.totalAmount,
//             totalPaid: state.totalPaid,
//             totalOverdue: state.totalOverdue,
//             overdueCount: state.overdueCount,
//             totalPayments: state.payments.length,
//           ),
//
//         if (state.payments.isEmpty)
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.payment_outlined,
//                     size: 64,
//                     color: Colors.grey[400],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _getEmptyStateMessage(),
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _navigateToAddPayment,
//                     child: const Text('Add First Payment'),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           Expanded(
//             child: ListView.builder(
//               itemCount: state.payments.length,
//               itemBuilder: (context, index) {
//                 final payment = state.payments[index];
//                 return PaymentCard(
//                   payment: payment,
//                   onTap: () => _navigateToPaymentDetail(payment),
//                   onEdit: () => _navigateToEditPayment(payment),
//                   onRecordPartialPayment:
//                       () => _showPartialPaymentDialog(payment),
//                   onDelete: () => _showDeleteConfirmation(payment),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   String _getEmptyStateMessage() {
//     switch (_selectedStatus) {
//       case PaymentStatus.pending:
//         return 'No pending payments found';
//       case PaymentStatus.overdue:
//         return 'No overdue payments found';
//       case PaymentStatus.completed:
//         return 'No completed payments found';
//       default:
//         return 'No payments found';
//     }
//   }
//
//   void _onMenuSelected(String value) {
//     switch (value) {
//       case 'calculate_late_fees':
//         _showCalculateLateFeeDialog();
//         break;
//       case 'generate_report':
//         _generateReport();
//         break;
//       case 'export_data':
//         _exportData();
//         break;
//     }
//   }
//
//   void _showCalculateLateFeeDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Calculate Late Fees'),
//             content: const Text(
//               'This will calculate and apply late fees to all overdue payments. '
//               'Are you sure you want to continue?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.read<PaymentBloc>().add(const CalculateLateFees());
//                 },
//                 child: const Text('Calculate'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   void _generateReport() {
//     // TODO: Implement report generation
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Report generation feature coming soon')),
//     );
//   }
//
//   void _exportData() {
//     // TODO: Implement data export
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Data export feature coming soon')),
//     );
//   }
//
//   void _navigateToAddPayment() async {
//     // final result = await Navigator.of(context).push(
//     //   MaterialPageRoute(
//     //     builder:
//     //         (context) => RecordPaymentPage(
//     //           leaseId: widget.leaseId,
//     //           tenantId: widget.tenantId,
//     //           propertyId: widget.propertyId,
//     //         ),
//     //   ),
//     // );
//     //
//     // if (result == true) {
//     //   _loadPayments();
//     // }
//   }
//
//   void _navigateToEditPayment(Payment payment) async {
//     // final result = await Navigator.of(context).push(
//     //   MaterialPageRoute(
//     //     builder: (context) => RecordPaymentPage(existingPayment: payment),
//     //   ),
//     // );
//     //
//     // if (result == true) {
//     //   _loadPayments();
//     // }
//   }
//
//   void _navigateToPaymentDetail(Payment payment) {
//     // TODO: Navigate to payment detail page
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Payment detail page coming soon')),
//     );
//   }
//
//   void _showPartialPaymentDialog(Payment payment) {
//     final amountController = TextEditingController();
//     final referenceController = TextEditingController();
//     String? paymentMethod;
//
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Record Partial Payment'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Remaining Amount: \$${payment.totalRemainingAmount.toStringAsFixed(2)}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//
//                 TextField(
//                   controller: amountController,
//                   decoration: const InputDecoration(
//                     labelText: 'Payment Amount',
//                     prefixText: '\$',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 TextField(
//                   controller: referenceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reference (Optional)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 DropdownButtonFormField<String>(
//                   value: paymentMethod,
//                   decoration: const InputDecoration(
//                     labelText: 'Payment Method',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'cash', child: Text('Cash')),
//                     DropdownMenuItem(value: 'check', child: Text('Check')),
//                     DropdownMenuItem(
//                       value: 'bank_transfer',
//                       child: Text('Bank Transfer'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'credit_card',
//                       child: Text('Credit Card'),
//                     ),
//                     DropdownMenuItem(
//                       value: 'mobile_payment',
//                       child: Text('Mobile Payment'),
//                     ),
//                   ],
//                   onChanged: (value) => paymentMethod = value,
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final amount = double.tryParse(amountController.text);
//                   if (amount == null || amount <= 0) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please enter a valid amount'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }
//
//                   if (amount > payment.totalRemainingAmount) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Amount exceeds remaining balance'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                     return;
//                   }
//
//                   Navigator.of(context).pop();
//
//                   context.read<PaymentBloc>().add(
//                     RecordPartialPayment(
//                       paymentId: payment.id,
//                       amount: amount,
//                       paymentMethod: paymentMethod,
//                       reference:
//                           referenceController.text.trim().isEmpty
//                               ? null
//                               : referenceController.text.trim(),
//                     ),
//                   );
//                 },
//                 child: const Text('Record Payment'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   void _showDeleteConfirmation(Payment payment) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Delete Payment'),
//             content: Text(
//               'Are you sure you want to delete this payment?\n\n'
//               'Amount: \$${payment.amount.toStringAsFixed(2)}\n'
//               'Type: ${payment.typeText}\n'
//               'Due Date: ${payment.dueDate.day}/${payment.dueDate.month}/${payment.dueDate.year}',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.read<PaymentBloc>().add(DeletePayment(payment.id));
//                   _loadPayments();
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
