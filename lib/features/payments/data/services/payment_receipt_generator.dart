// // lib/features/payments/data/services/payment_receipt_generator.dart
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:property_manager/features/payments/data/models/payment_model.dart';
// import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';
// import '../../../../core/services/file_service.dart';
// import '../../properties/domain/entities/property.dart';
// import '../../tenants/domain/entities/tenant.dart';
//
// class PaymentReceiptGenerator {
//   final FileService _fileService;
//   final CurrencyFormatter _currencyFormatter;
//   final DateUtils _dateUtils;
//
//   PaymentReceiptGenerator(
//     this._fileService,
//     this._currencyFormatter,
//     this._dateUtils,
//   );
//
//   // Generate payment receipt
//   Future<String> generateReceipt({
//     required PaymentModel payment,
//     required Property property,
//     required Tenant tenant,
//     String? landlordName,
//     String? landlordAddress,
//     String? landlordPhone,
//     String? companyLogo,
//   }) async {
//     final pdf = pw.Document();
//
//     // Add receipt page
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(40),
//         build: (pw.Context context) {
//           return _buildReceiptContent(
//             payment: payment,
//             property: property,
//             tenant: tenant,
//             landlordName: landlordName,
//             landlordAddress: landlordAddress,
//             landlordPhone: landlordPhone,
//           );
//         },
//       ),
//     );
//
//     // Save PDF to file
//     final fileName =
//         'receipt_${payment.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
//     final filePath = await _saveToFile(pdf, fileName);
//
//     // Update payment record with receipt path
//     await _updatePaymentReceiptPath(payment.id, filePath);
//
//     return filePath;
//   }
//
//   // Build receipt content
//   pw.Widget _buildReceiptContent({
//     required PaymentModel payment,
//     required Property property,
//     required Tenant tenant,
//     String? landlordName,
//     String? landlordAddress,
//     String? landlordPhone,
//   }) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         // Header
//         _buildReceiptHeader(landlordName, landlordAddress, landlordPhone),
//
//         pw.SizedBox(height: 30),
//
//         // Receipt title and number
//         pw.Center(
//           child: pw.Column(
//             children: [
//               pw.Text(
//                 'PAYMENT RECEIPT',
//                 style: pw.TextStyle(
//                   fontSize: 24,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Text(
//                 'Receipt #: ${payment.id}',
//                 style: pw.TextStyle(fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//
//         pw.SizedBox(height: 30),
//
//         // Payment details table
//         _buildPaymentDetailsTable(payment, property, tenant),
//
//         pw.SizedBox(height: 30),
//
//         // Payment breakdown
//         _buildPaymentBreakdown(payment),
//
//         pw.SizedBox(height: 30),
//
//         // Footer
//         _buildReceiptFooter(payment),
//       ],
//     );
//   }
//
//   // Build receipt header
//   pw.Widget _buildReceiptHeader(
//     String? landlordName,
//     String? landlordAddress,
//     String? landlordPhone,
//   ) {
//     return pw.Container(
//       width: double.infinity,
//       padding: const pw.EdgeInsets.all(20),
//       decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             landlordName ?? 'Property Management',
//             style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//           ),
//           if (landlordAddress != null) ...[
//             pw.SizedBox(height: 5),
//             pw.Text(landlordAddress, style: pw.TextStyle(fontSize: 12)),
//           ],
//           if (landlordPhone != null) ...[
//             pw.SizedBox(height: 5),
//             pw.Text('Phone: $landlordPhone', style: pw.TextStyle(fontSize: 12)),
//           ],
//         ],
//       ),
//     );
//   }
//
//   // Build payment details table
//   pw.Widget _buildPaymentDetailsTable(
//     PaymentModel payment,
//     Property property,
//     Tenant tenant,
//   ) {
//     return pw.Table(
//       border: pw.TableBorder.all(),
//       children: [
//         _buildTableRow(
//           'Received From:',
//           '${tenant.firstName} ${tenant.lastName}',
//         ),
//         _buildTableRow('Property:', property.address),
//         _buildTableRow(
//           'Payment Date:',
//           _dateUtils.formatDate(payment.paidDate ?? DateTime.now()),
//         ),
//         _buildTableRow('Period Covered:', _getPaymentPeriod(payment)),
//         _buildTableRow(
//           'Payment Method:',
//           _getPaymentMethodDisplay(payment.method),
//         ),
//         if (payment.transactionId != null)
//           _buildTableRow('Transaction ID:', payment.transactionId!),
//       ],
//     );
//   }
//
//   // Build table row
//   pw.TableRow _buildTableRow(String label, String value) {
//     return pw.TableRow(
//       children: [
//         pw.Container(
//           padding: const pw.EdgeInsets.all(8),
//           child: pw.Text(
//             label,
//             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//           ),
//         ),
//         pw.Container(
//           padding: const pw.EdgeInsets.all(8),
//           child: pw.Text(value),
//         ),
//       ],
//     );
//   }
//
//   // Build payment breakdown
//   pw.Widget _buildPaymentBreakdown(PaymentModel payment) {
//     return pw.Container(
//       width: double.infinity,
//       decoration: pw.BoxDecoration(border: pw.Border.all()),
//       child: pw.Column(
//         children: [
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(10),
//             decoration: pw.BoxDecoration(color: PdfColors.grey200),
//             child: pw.Text(
//               'PAYMENT BREAKDOWN',
//               style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//               textAlign: pw.TextAlign.center,
//             ),
//           ),
//           _buildBreakdownRow('Base Amount:', payment.amount),
//           if (payment.lateFee > 0)
//             _buildBreakdownRow('Late Fee:', payment.lateFee),
//           pw.Divider(thickness: 2),
//           _buildBreakdownRow(
//             'TOTAL AMOUNT PAID:',
//             payment.totalAmount,
//             isTotal: true,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Build breakdown row
//   pw.Widget _buildBreakdownRow(
//     String label,
//     double amount, {
//     bool isTotal = false,
//   }) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             label,
//             style: pw.TextStyle(
//               fontSize: isTotal ? 14 : 12,
//               fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
//             ),
//           ),
//           pw.Text(
//             _currencyFormatter.format(amount),
//             style: pw.TextStyle(
//               fontSize: isTotal ? 14 : 12,
//               fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Build receipt footer
//   pw.Widget _buildReceiptFooter(PaymentModel payment) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         if (payment.notes != null && payment.notes!.isNotEmpty) ...[
//           pw.Text(
//             'Notes:',
//             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//           ),
//           pw.SizedBox(height: 5),
//           pw.Text(payment.notes!),
//           pw.SizedBox(height: 20),
//         ],
//
//         pw.Text(
//           'Thank you for your payment!',
//           style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
//         ),
//
//         pw.SizedBox(height: 20),
//
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text('_' * 30),
//                 pw.SizedBox(height: 5),
//                 pw.Text('Landlord Signature'),
//               ],
//             ),
//             pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text('Date: ${_dateUtils.formatDate(DateTime.now())}'),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Get payment period string
//   String _getPaymentPeriod(PaymentModel payment) {
//     if (payment.type == PaymentType.rent) {
//       final month = _dateUtils.formatMonth(payment.dueDate);
//       return month;
//     }
//     return 'One-time payment';
//   }
//
//   // Get payment method display name
//   String _getPaymentMethodDisplay(PaymentMethod method) {
//     switch (method) {
//       case PaymentMethod.cash:
//         return 'Cash';
//       case PaymentMethod.check:
//         return 'Check';
//       case PaymentMethod.bankTransfer:
//         return 'Bank Transfer';
//       case PaymentMethod.onlinePayment:
//         return 'Online Payment';
//       case PaymentMethod.creditCard:
//         return 'Credit Card';
//       case PaymentMethod.debitCard:
//         return 'Debit Card';
//     }
//   }
//
//   // Save PDF to file
//   Future<String> _saveToFile(pw.Document pdf, String fileName) async {
//     final bytes = await pdf.save();
//     return await _fileService.saveFile(bytes, fileName, subfolder: 'receipts');
//   }
//
//   // Update payment record with receipt path
//   Future<void> _updatePaymentReceiptPath(
//     String paymentId,
//     String filePath,
//   ) async {
//     // Implementation depends on your database service
//     // This would update the payment record with the receipt file path
//   }
//
//   // Share receipt
//   Future<void> shareReceipt(String receiptPath) async {
//     final file = XFile(receiptPath);
//     await Share.shareXFiles([file], text: 'Payment Receipt');
//   }
//
//   // Email receipt
//   Future<void> emailReceipt({
//     required String receiptPath,
//     required String recipientEmail,
//     String? subject,
//     String? body,
//   }) async {
//     final file = XFile(receiptPath);
//     await Share.shareXFiles(
//       [file],
//       text: body ?? 'Please find your payment receipt attached.',
//       subject: subject ?? 'Payment Receipt',
//     );
//   }
//
//   // Generate receipt preview (for display in app)
//   Future<Uint8List> generateReceiptPreview({
//     required PaymentModel payment,
//     required Property property,
//     required Tenant tenant,
//     String? landlordName,
//   }) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(40),
//         build: (pw.Context context) {
//           return _buildReceiptContent(
//             payment: payment,
//             property: property,
//             tenant: tenant,
//             landlordName: landlordName,
//           );
//         },
//       ),
//     );
//
//     return await pdf.save();
//   }
//
//   // Batch generate receipts for multiple payments
//   Future<List<String>> batchGenerateReceipts({
//     required List<PaymentModel> payments,
//     required Map<String, Property> properties,
//     required Map<String, Tenant> tenants,
//     String? landlordName,
//     String? landlordAddress,
//     String? landlordPhone,
//   }) async {
//     final receiptPaths = <String>[];
//
//     for (final payment in payments) {
//       final property = properties[payment.propertyId];
//       final tenant = tenants[payment.tenantId];
//
//       if (property != null && tenant != null) {
//         final receiptPath = await generateReceipt(
//           payment: payment,
//           property: property,
//           tenant: tenant,
//           landlordName: landlordName,
//           landlordAddress: landlordAddress,
//           landlordPhone: landlordPhone,
//         );
//         receiptPaths.add(receiptPath);
//       }
//     }
//
//     return receiptPaths;
//   }
// }

