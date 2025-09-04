// lib/features/tenants/presentation/widgets/tenant_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/core/utlis/validators.dart' show Validators;
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/usecases/add_tenant.dart';
import '../bloc/tenant_bloc.dart' as tenant_bloc;
import '../bloc/tenant_event.dart';
import '../bloc/tenant_event.dart'
    as tenant_bloc
    show AddTenantEvent, UpdateTenantEvent;

class TenantForm extends StatefulWidget {
  final Tenant? tenant;
  final List<Map<String, String>> availableProperties;

  const TenantForm({
    super.key,
    this.tenant,
    this.availableProperties = const [],
  });

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dateOfBirth;
  List<String> _selectedPropertyIds = [];
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.tenant != null) {
      _firstNameController.text = widget.tenant!.firstName;
      _lastNameController.text = widget.tenant!.lastName;
      _emailController.text = widget.tenant!.email;
      _phoneController.text = widget.tenant!.phone;
      _emergencyContactNameController.text =
          widget.tenant!.emergencyContactName ?? '';
      _emergencyContactPhoneController.text =
          widget.tenant!.emergencyContactPhone ?? '';
      _addressController.text = widget.tenant!.address ?? '';
      _occupationController.text = widget.tenant!.occupation ?? '';
      _monthlyIncomeController.text =
          widget.tenant!.monthlyIncome?.toString() ?? '';
      _idNumberController.text = widget.tenant!.idNumber ?? '';
      _notesController.text = widget.tenant!.notes ?? '';
      _dateOfBirth = widget.tenant!.dateOfBirth;
      _selectedPropertyIds = List.from(widget.tenant!.propertyIds);
      _isActive = widget.tenant!.isActive;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    _monthlyIncomeController.dispose();
    _idNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInformationSection(),
            const SizedBox(height: 24),
            _buildContactInformationSection(),
            const SizedBox(height: 24),
            _buildEmergencyContactSection(),
            const SizedBox(height: 24),
            _buildAdditionalInformationSection(),
            const SizedBox(height: 24),
            _buildPropertyAssignmentSection(),
            const SizedBox(height: 24),
            _buildStatusSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    validator:
                        (value) =>
                            Validators.validateRequired(value, 'First Name'),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    validator:
                        (value) =>
                            Validators.validateRequired(value, 'Last Name'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // DatePickerField(
            //   label: 'Date of Birth',
            //   selectedDate: _dateOfBirth,
            //   onDateSelected: (date) => setState(() => _dateOfBirth = date),
            //   prefixIcon: Icons.cake,
            // ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _idNumberController,
              labelText: 'ID Number',
              prefixIcon: const Icon(Icons.badge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInformationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              validator:
                  (value) => Validators.validateRequired(value, 'Phone Number'),
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _addressController,
              labelText: 'Address',
              maxLines: 3,
              prefixIcon: const Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Contact',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emergencyContactNameController,
              labelText: 'Emergency Contact Name',
              prefixIcon: const Icon(Icons.contact_emergency),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emergencyContactPhoneController,
              labelText: 'Emergency Contact Phone',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_in_talk),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInformationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _occupationController,
              labelText: 'Occupation',
              prefixIcon: const Icon(Icons.work),
            ),
            const SizedBox(height: 16),
            CurrencyInputField(
              controller: _monthlyIncomeController,
              labelText: 'Monthly Income',
              prefixIcon: const Icon(Icons.attach_money),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _notesController,
              labelText: 'Notes',
              maxLines: 4,
              prefixIcon: Icon(Icons.note),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyAssignmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Assignment',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.availableProperties.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'No properties available for assignment',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              Column(
                children:
                    widget.availableProperties.map((property) {
                      final propertyId = property['id']!;
                      final propertyName = property['name']!;
                      final isSelected = _selectedPropertyIds.contains(
                        propertyId,
                      );

                      return CheckboxListTile(
                        title: Text(propertyName),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedPropertyIds.add(propertyId);
                            } else {
                              _selectedPropertyIds.remove(propertyId);
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Tenant'),
              subtitle: Text(
                _isActive ? 'Tenant is currently active' : 'Tenant is inactive',
              ),
              value: _isActive,
              onChanged: (bool value) {
                setState(() => _isActive = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            type: ButtonType.secondary, // outlined button
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: widget.tenant == null ? 'Add Tenant' : 'Update Tenant',
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final tenant = Tenant(
        id: widget.tenant?.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        emergencyContactName:
            _emergencyContactNameController.text.trim().isEmpty
                ? null
                : _emergencyContactNameController.text.trim(),
        emergencyContactPhone:
            _emergencyContactPhoneController.text.trim().isEmpty
                ? null
                : _emergencyContactPhoneController.text.trim(),
        address:
            _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
        dateOfBirth: _dateOfBirth,
        occupation:
            _occupationController.text.trim().isEmpty
                ? null
                : _occupationController.text.trim(),
        monthlyIncome:
            _monthlyIncomeController.text.trim().isEmpty
                ? null
                : double.tryParse(_monthlyIncomeController.text.trim()),
        idNumber:
            _idNumberController.text.trim().isEmpty
                ? null
                : _idNumberController.text.trim(),
        notes:
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
        propertyIds: _selectedPropertyIds,
        //   isActive: _isActive,
        createdAt: widget.tenant?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.tenant == null) {
        // Adding a new tenant
        context.read<tenant_bloc.TenantBloc>().add(
          tenant_bloc.AddTenantEvent(
            tenant,
          ), // make sure the event class is AddTenantEvent
        );
      } else {
        // Updating an existing tenant
        context.read<tenant_bloc.TenantBloc>().add(
          tenant_bloc.UpdateTenantEvent(
            tenant,
          ), // make sure the event class is UpdateTenantEvent
        );
      }
    }
  }
}

