// lib/features/tenants/presentation/widgets/tenant_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/tenant.dart';

class TenantCard extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  const TenantCard({
    Key? key,
    required this.tenant,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.fullName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                tenant.email,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(),
                  const SizedBox(width: 8),
                  _buildPopupMenu(context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    tenant.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  if (tenant.occupation != null) ...[
                    Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tenant.occupation!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (tenant.address != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tenant.address!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
              if (tenant.propertyIds.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${tenant.propertyIds.length} ${tenant.propertyIds.length == 1 ? 'Property' : 'Properties'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (tenant.monthlyIncome != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Monthly Income: \$${tenant.monthlyIncome!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor:
          tenant.isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
      child: Text(
        tenant.firstName.isNotEmpty && tenant.lastName.isNotEmpty
            ? '${tenant.firstName[0]}${tenant.lastName[0]}'.toUpperCase()
            : 'T',
        style: TextStyle(
          color: tenant.isActive ? Colors.green[700] : Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            tenant.isActive
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tenant.isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: tenant.isActive ? Colors.green[700] : Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'toggle_status':
            onToggleStatus?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem<String>(
              value: 'toggle_status',
              child: ListTile(
                leading: Icon(tenant.isActive ? Icons.pause : Icons.play_arrow),
                title: Text(tenant.isActive ? 'Deactivate' : 'Activate'),
                contentPadding: const EdgeInsets.all(0),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
    );
  }
}
