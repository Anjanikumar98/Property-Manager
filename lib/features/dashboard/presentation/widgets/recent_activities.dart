import 'package:flutter/material.dart';
import 'package:property_manager/features/properties/presentation/widgets/currency_formatter.dart';

class RecentActivities extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivities({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          activities.isEmpty
              ? _buildEmptyState(context)
              : _buildActivitiesList(),
          if (activities.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildViewAllButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.history, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          'Recent Activities',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (activities.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${activities.length} recent',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No recent activities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.titleMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Activities will appear here as you manage your properties',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesList() {
    return Column(
      children:
          activities
              .take(10) // Show maximum 10 activities
              .map((activity) => _buildActivityItem(activity))
              .toList(),
    );
  }

  Widget _buildActivityItem(RecentActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getActivityBackgroundColor(activity.status),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getActivityBorderColor(activity.status),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivityIcon(activity),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      AppDateUtils.getRelativeTime(activity.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (activity.propertyName != null ||
                    activity.tenantName != null ||
                    activity.amount != null) ...[
                  const SizedBox(height: 8),
                  _buildActivityDetails(activity),
                ],
              ],
            ),
          ),
          _buildStatusIndicator(activity.status),
        ],
      ),
    );
  }

  Widget _buildActivityIcon(RecentActivity activity) {
    IconData icon;
    Color color;

    switch (activity.type) {
      case 'payment':
        icon = Icons.payment;
        color = Colors.green;
        break;
      case 'lease':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'maintenance':
        icon = Icons.build;
        color = Colors.orange;
        break;
      case 'tenant':
        icon = Icons.person;
        color = Colors.purple;
        break;
      case 'property':
        icon = Icons.home;
        color = Colors.teal;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildActivityDetails(RecentActivity activity) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (activity.propertyName != null)
          _buildDetailChip(Icons.home, activity.propertyName!, Colors.teal),
        if (activity.tenantName != null)
          _buildDetailChip(Icons.person, activity.tenantName!, Colors.purple),
        if (activity.amount != null)
          _buildDetailChip(
            Icons.attach_money,
            CurrencyFormatter.format(activity.amount!),
            Colors.green,
          ),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ActivityStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case ActivityStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case ActivityStatus.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case ActivityStatus.error:
        color = Colors.red;
        icon = Icons.error;
        break;
      case ActivityStatus.info:
        color = Colors.blue;
        icon = Icons.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Color _getActivityBackgroundColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.success:
        return Colors.green.withOpacity(0.05);
      case ActivityStatus.warning:
        return Colors.orange.withOpacity(0.05);
      case ActivityStatus.error:
        return Colors.red.withOpacity(0.05);
      case ActivityStatus.info:
        return Colors.blue.withOpacity(0.05);
    }
  }

  Color _getActivityBorderColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.success:
        return Colors.green.withOpacity(0.2);
      case ActivityStatus.warning:
        return Colors.orange.withOpacity(0.2);
      case ActivityStatus.error:
        return Colors.red.withOpacity(0.2);
      case ActivityStatus.info:
        return Colors.blue.withOpacity(0.2);
    }
  }

  Widget _buildViewAllButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/activities');
        },
        icon: const Icon(Icons.list_alt),
        label: const Text('View All Activities'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          foregroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// Data model classes
class RecentActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String? propertyName;
  final String? tenantName;
  final double? amount;
  final ActivityStatus status;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.propertyName,
    this.tenantName,
    this.amount,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      propertyName: json['propertyName'],
      tenantName: json['tenantName'],
      amount: json['amount']?.toDouble(),
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ActivityStatus.info,
      ),
    );
  }
}

enum ActivityStatus { success, warning, error, info }

// Utility class for date formatting
class AppDateUtils {
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
