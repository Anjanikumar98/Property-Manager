// lib/features/notifications/domain/repositories/notification_repository.dart
import 'package:dartz/dartz.dart';
import 'package:property_manager/core/services/notification/notification.dart';
import 'package:property_manager/core/services/notification/notification_settings.dart';
import '../../../../core/errors/failures.dart';

/// Abstract repository interface for notification operations
///
/// This interface defines all the operations related to notifications
/// and notification settings that the domain layer can perform.
/// The actual implementation will be in the data layer.
abstract class NotificationRepository {
  // ========== Notification CRUD Operations ==========

  /// Retrieves all notifications from storage
  ///
  /// Returns:
  /// - Right: List of NotificationEntity on success
  /// - Left: Failure on error (database issues, etc.)
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Retrieves notifications by type
  ///
  /// [type] - The type of notifications to filter by
  /// Returns:
  /// - Right: List of NotificationEntity of specified type
  /// - Left: Failure on error
  Future<Either<Failure, List<NotificationEntity>>> getNotificationsByType(
    NotificationType type,
  );

  /// Retrieves only unread notifications
  ///
  /// Returns:
  /// - Right: List of unread NotificationEntity
  /// - Left: Failure on error
  Future<Either<Failure, List<NotificationEntity>>> getUnreadNotifications();

  /// Gets the count of unread notifications
  ///
  /// Returns:
  /// - Right: Integer count of unread notifications
  /// - Left: Failure on error
  Future<Either<Failure, int>> getUnreadCount();

  /// Creates a new notification and schedules it if needed
  ///
  /// [notification] - The notification entity to create
  /// Returns:
  /// - Right: Created NotificationEntity on success
  /// - Left: Failure on error (database issues, scheduling issues, etc.)
  Future<Either<Failure, NotificationEntity>> createNotification(
    NotificationEntity notification,
  );

  /// Updates an existing notification
  ///
  /// [notification] - The notification entity with updated data
  /// Returns:
  /// - Right: Updated NotificationEntity on success
  /// - Left: Failure on error (not found, database issues, etc.)
  Future<Either<Failure, NotificationEntity>> updateNotification(
    NotificationEntity notification,
  );

  /// Marks a specific notification as read
  ///
  /// [notificationId] - The ID of the notification to mark as read
  /// Returns:
  /// - Right: Updated NotificationEntity on success
  /// - Left: Failure on error (not found, database issues, etc.)
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId);

  /// Marks all notifications as read
  ///
  /// Returns:
  /// - Right: true on success
  /// - Left: Failure on error
  Future<Either<Failure, bool>> markAllAsRead();

  /// Deletes a specific notification
  ///
  /// [notificationId] - The ID of the notification to delete
  /// Also cancels any scheduled system notifications
  /// Returns:
  /// - Right: true on successful deletion
  /// - Left: Failure on error (not found, database issues, etc.)
  Future<Either<Failure, bool>> deleteNotification(String notificationId);

  /// Deletes all notifications
  ///
  /// Also cancels all scheduled system notifications
  /// Returns:
  /// - Right: true on successful deletion
  /// - Left: Failure on error
  Future<Either<Failure, bool>> deleteAllNotifications();

  // ========== Notification Settings Operations ==========

  /// Retrieves current notification settings
  ///
  /// Returns default settings if none exist
  /// Returns:
  /// - Right: NotificationSettings on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationSettings>> getNotificationSettings();

  /// Updates notification settings
  ///
  /// [settings] - The new notification settings to save
  /// This method should also update any scheduled notifications
  /// based on the new settings
  /// Returns:
  /// - Right: Updated NotificationSettings on success
  /// - Left: Failure on error (database issues, validation errors, etc.)
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  );

  /// Resets notification settings to default values
  ///
  /// Returns:
  /// - Right: Default NotificationSettings on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationSettings>> resetNotificationSettings();

  // ========== Automated Notification Scheduling ==========

  /// Schedules payment reminder notifications for all active leases
  ///
  /// This method should:
  /// 1. Query all active leases
  /// 2. Calculate payment due dates
  /// 3. Schedule notifications based on reminder settings
  /// 4. Cancel any existing payment reminders
  ///
  /// Returns:
  /// - Right: true on successful scheduling
  /// - Left: Failure on error (database issues, scheduling issues, etc.)
  Future<Either<Failure, bool>> schedulePaymentReminders();

  /// Schedules lease expiry alert notifications for all active leases
  ///
  /// This method should:
  /// 1. Query all active leases
  /// 2. Calculate expiry dates
  /// 3. Schedule notifications based on reminder settings
  /// 4. Cancel any existing lease expiry alerts
  ///
  /// Returns:
  /// - Right: true on successful scheduling
  /// - Left: Failure on error
  Future<Either<Failure, bool>> scheduleLeaseExpiryAlerts();

  /// Schedules maintenance reminder notifications
  ///
  /// For recurring maintenance tasks or overdue requests
  /// Returns:
  /// - Right: true on successful scheduling
  /// - Left: Failure on error
  Future<Either<Failure, bool>> scheduleMaintenanceReminders();

  /// Cancels all scheduled notifications of a specific type
  ///
  /// [type] - The type of notifications to cancel
  /// Returns:
  /// - Right: true on successful cancellation
  /// - Left: Failure on error
  Future<Either<Failure, bool>> cancelScheduledNotifications(
    NotificationType type,
  );

  /// Cancels all scheduled notifications
  ///
  /// Returns:
  /// - Right: true on successful cancellation
  /// - Left: Failure on error
  Future<Either<Failure, bool>> cancelAllScheduledNotifications();

  // ========== Specific Notification Creators ==========

  /// Creates and schedules a payment reminder notification
  ///
  /// [propertyId] - ID of the property
  /// [tenantId] - ID of the tenant
  /// [propertyName] - Name of the property for display
  /// [amount] - Payment amount
  /// [dueDate] - When payment is due
  /// [reminderDays] - How many days before due date to remind
  ///
  /// Returns:
  /// - Right: Created NotificationEntity on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationEntity>> createPaymentReminder({
    required String propertyId,
    required String tenantId,
    required String propertyName,
    required double amount,
    required DateTime dueDate,
    required int reminderDays,
  });

  /// Creates and schedules a lease expiry alert notification
  ///
  /// [propertyId] - ID of the property
  /// [tenantId] - ID of the tenant
  /// [leaseId] - ID of the lease
  /// [propertyName] - Name of the property for display
  /// [expiryDate] - When lease expires
  /// [reminderDays] - How many days before expiry to alert
  ///
  /// Returns:
  /// - Right: Created NotificationEntity on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationEntity>> createLeaseExpiryAlert({
    required String propertyId,
    required String tenantId,
    required String leaseId,
    required String propertyName,
    required DateTime expiryDate,
    required int reminderDays,
  });

  /// Creates a maintenance request notification (immediate)
  ///
  /// [propertyId] - ID of the property
  /// [tenantId] - ID of the tenant (optional, could be landlord-initiated)
  /// [requestId] - ID of the maintenance request
  /// [description] - Description of the maintenance issue
  /// [priority] - Priority level (low, medium, high, urgent)
  ///
  /// Returns:
  /// - Right: Created NotificationEntity on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationEntity>> createMaintenanceNotification({
    required String propertyId,
    String? tenantId,
    required String requestId,
    required String description,
    required String priority,
  });

  /// Creates a property update notification
  ///
  /// [propertyId] - ID of the property
  /// [title] - Title of the update
  /// [message] - Update message
  /// [affectedTenants] - List of tenant IDs to notify (empty = all)
  ///
  /// Returns:
  /// - Right: List of created NotificationEntity on success
  /// - Left: Failure on error
  Future<Either<Failure, List<NotificationEntity>>>
  createPropertyUpdateNotification({
    required String propertyId,
    required String title,
    required String message,
    List<String>? affectedTenants,
  });

  /// Creates a system alert notification
  ///
  /// [title] - Title of the alert
  /// [message] - Alert message
  /// [severity] - Severity level (info, warning, error, critical)
  ///
  /// Returns:
  /// - Right: Created NotificationEntity on success
  /// - Left: Failure on error
  Future<Either<Failure, NotificationEntity>> createSystemAlert({
    required String title,
    required String message,
    required String severity,
  });

  // ========== Analytics and Statistics ==========

  /// Gets notification statistics
  ///
  /// Returns counts by type, read/unread status, etc.
  /// Returns:
  /// - Right: Map with notification statistics
  /// - Left: Failure on error
  Future<Either<Failure, Map<String, dynamic>>> getNotificationStatistics();

  /// Gets notification history for a specific date range
  ///
  /// [startDate] - Start of date range
  /// [endDate] - End of date range
  /// [type] - Optional filter by notification type
  ///
  /// Returns:
  /// - Right: List of NotificationEntity in date range
  /// - Left: Failure on error
  Future<Either<Failure, List<NotificationEntity>>> getNotificationHistory({
    required DateTime startDate,
    required DateTime endDate,
    NotificationType? type,
  });
}
