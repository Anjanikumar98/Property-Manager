// // lib/features/payments/presentation/pages/payment_history_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:property_manager/features/payments/data/models/payment_model.dart';
// import 'package:property_manager/features/payments/domain/entities/payment.dart';
// import 'package:property_manager/features/payments/presentation/bloc/payment_state.dart';
// import 'package:property_manager/features/payments/presentation/widgets/payment_filter_widget.dart';
// import 'package:property_manager/features/tenants/domain/entities/tenant.dart';
// import '../bloc/payment_bloc.dart';
// import '../../../../shared/widgets/loading_widget.dart';
// import '../../../../shared/widgets/error_widget.dart';
//
// class PaymentHistoryPage extends StatefulWidget {
//   const PaymentHistoryPage({Key? key}) : super(key: key);
//
//   @override
//   State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
// }
//
// class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
//   final ScrollController _scrollController = ScrollController();
//   String _searchQuery = '';
//   PaymentFilter _currentFilter = PaymentFilter();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPayments();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _loadPayments() {
//     // context.read<PaymentBloc>().add(
//     //   LoadPaymentHistoryEvent(
//     //     searchQuery: _searchQuery,
//     //     filter: _currentFilter,
//     //   ),
//     // );
//   }
//
//   void _onScroll() {
//     // if (_scrollController.position.pixels ==
//     //     _scrollController.position.maxScrollExtent) {
//     //   context.read<PaymentBloc>().add(LoadMorePaymentsEvent());
//     // }
//   }
//
//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//     _loadPayments();
//   }
//
//   void _onFilterChanged(PaymentFilter filter) {
//     setState(() {
//       _currentFilter = filter;
//     });
//     _loadPayments();
//   }
//
//   void _showFilterBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => PaymentFilterWidget(
//             currentFilter: _currentFilter,
//             onFilterChanged: _onFilterChanged,
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment History'),
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: _showFilterBottomSheet,
//             icon: const Icon(Icons.filter_list),
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               switch (value) {
//                 case 'export':
//                   _exportPayments();
//                   break;
//                 case 'refresh':
//                   _loadPayments();
//                   break;
//               }
//             },
//             itemBuilder:
//                 (context) => [
//                   const PopupMenuItem(
//                     value: 'export',
//                     child: Row(
//                       children: [
//                         Icon(Icons.download),
//                         SizedBox(width: 8),
//                         Text('Export'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'refresh',
//                     child: Row(
//                       children: [
//                         Icon(Icons.refresh),
//                         SizedBox(width: 8),
//                         Text('Refresh'),
//                       ],
//                     ),
//                   ),
//                 ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Theme.of(context).colorScheme.surface,
//             // child: PaymentSearchWidget(
//             //   onSearchChanged: _onSearchChanged,
//             //   initialQuery: _searchQuery,
//             // ),
//           ),
//
//           // Payment Summary
//           BlocBuilder<PaymentBloc, PaymentState>(
//             builder: (context, state) {
//               // if (state is PaymentHistoryLoaded) {
//               //   return PaymentSummaryWidget(
//               //     totalAmount: state.summary.totalAmount,
//               //     paidAmount: state.summary.paidAmount,
//               //     overdueAmount: state.summary.overdueAmount,
//               //     pendingAmount: state.summary.pendingAmount,
//               //   );
//               // }
//               return const SizedBox.shrink();
//             },
//           ),
//
//           const Divider(height: 1),
//
//           // Payment List
//           // Expanded(
//           //   child: BlocBuilder<PaymentBloc, PaymentState>(
//           //     builder: (context, state) {
//           //       if (state is PaymentLoading) {
//           //         return const LoadingWidget();
//           //       } else if (state is PaymentError) {
//           //         return CustomErrorWidget(
//           //           message: state.message,
//           //           onRetry: _loadPayments,
//           //         );
//           //       } else if (state is PaymentHistoryLoaded) {
//           //         if (state.payments.isEmpty) {
//           //           return _buildEmptyState();
//           //         }
//           //
//           //         return RefreshIndicator(
//           //           onRefresh: () async => _loadPayments(),
//           //           child: ListView.builder(
//           //             controller: _scrollController,
//           //             padding: const EdgeInsets.all(16),
//           //             itemCount:
//           //                 state.payments.length + (state.hasMore ? 1 : 0),
//           //             itemBuilder: (context, index) {
//           //               if (index == state.payments.length) {
//           //                 return const Center(
//           //                   child: Padding(
//           //                     padding: EdgeInsets.all(16),
//           //                     child: CircularProgressIndicator(),
//           //                   ),
//           //                 );
//           //               }
//           //
//           //               final payment = state.payments[index];
//           //               return PaymentHistoryCard(
//           //                 payment: payment,
//           //                 onTap: () => _navigateToPaymentDetail(payment.id),
//           //                 onReceiptTap: () => _generateReceipt(payment),
//           //               );
//           //             },
//           //           ),
//           //         );
//           //       }
//           //       return const SizedBox.shrink();
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.payment_outlined,
//             size: 64,
//             color: Theme.of(context).colorScheme.outline,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No payments found',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               color: Theme.of(context).colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Payments will appear here once recorded',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Theme.of(context).colorScheme.outline,
//             ),
//           ),
//           const SizedBox(height: 24),
//           FilledButton.icon(
//             onPressed: () => Navigator.pushNamed(context, '/record-payment'),
//             icon: const Icon(Icons.add),
//             label: const Text('Record Payment'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToPaymentDetail(String paymentId) {
//     Navigator.pushNamed(context, '/payment-detail', arguments: paymentId);
//   }
//
//   void _generateReceipt(PaymentModel payment) {
//     // context.read<PaymentBloc>().add(GenerateReceiptEvent(payment.id));
//   }
//
//   void _exportPayments() {
//     // context.read<PaymentBloc>().add(
//     //   ExportPaymentsEvent(searchQuery: _searchQuery, filter: _currentFilter),
//     // );
//   }
// }
//
// class PaymentFilter {
//   // final PaymentStatus? status;
//   final PaymentType? type;
//   final PaymentMethod? method;
//   final DateRange? dateRange;
//   final String? propertyId;
//   final String? tenantId;
//   final double? minAmount;
//   final double? maxAmount;
//
//   const PaymentFilter({
//     //   this.status,
//     this.type,
//     this.method,
//     this.dateRange,
//     this.propertyId,
//     this.tenantId,
//     this.minAmount,
//     this.maxAmount,
//   });
//
//   PaymentFilter copyWith({
//     //   PaymentStatus? status,
//     PaymentType? type,
//     PaymentMethod? method,
//     DateRange? dateRange,
//     String? propertyId,
//     String? tenantId,
//     double? minAmount,
//     double? maxAmount,
//   }) {
//     return PaymentFilter(
//       //   status: status ?? this.status,
//       type: type ?? this.type,
//       method: method ?? this.method,
//       dateRange: dateRange ?? this.dateRange,
//       propertyId: propertyId ?? this.propertyId,
//       tenantId: tenantId ?? this.tenantId,
//       minAmount: minAmount ?? this.minAmount,
//       maxAmount: maxAmount ?? this.maxAmount,
//     );
//   }
//
//   bool get hasActiveFilters =>
//       //  status != null ||
//       type != null ||
//       method != null ||
//       dateRange != null ||
//       propertyId != null ||
//       tenantId != null ||
//       minAmount != null ||
//       maxAmount != null;
// }
//
// class DateRange {
//   final DateTime startDate;
//   final DateTime endDate;
//
//   const DateRange({required this.startDate, required this.endDate});
// }
//
