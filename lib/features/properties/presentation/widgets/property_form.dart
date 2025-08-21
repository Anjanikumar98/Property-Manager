// lib/features/properties/presentation/widgets/property_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/property.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/currency_input_field.dart';
import 'property_image_picker.dart';

class PropertyForm extends StatefulWidget {
  final Property? property;
  final Function(Property) onSubmit;
  final bool isLoading;

  const PropertyForm({
    super.key,
    this.property,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _squareFeetController = TextEditingController();
  final _monthlyRentController = TextEditingController();
  final _securityDepositController = TextEditingController();
  final _descriptionController = TextEditingController();

  PropertyType _selectedType = PropertyType.apartment;
  PropertyStatus _selectedStatus = PropertyStatus.available;
  List<String> _selectedAmenities = [];
  List<String> _imageUrls = [];

  // Available amenities
  final List<String> _availableAmenities = [
    'Air Conditioning',
    'Heating',
    'Parking',
    'Swimming Pool',
    'Gym/Fitness Center',
    'Laundry Facilities',
    'Dishwasher',
    'Balcony/Patio',
    'Pet Friendly',
    'Security System',
    'Elevator',
    'Storage',
    'Garden/Yard',
    'Fireplace',
    'Walk-in Closet',
    'Hardwood Floors',
    'Internet/WiFi',
    'Cable TV',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.property != null) {
      final property = widget.property!;
      _nameController.text = property.name;
      _addressController.text = property.address;
      _cityController.text = property.city;
      _stateController.text = property.state;
      _zipCodeController.text = property.zipCode;
      _bedroomsController.text = property.bedrooms.toString();
      _bathroomsController.text = property.bathrooms.toString();
      _squareFeetController.text = property.squareFeet.toString();
      _monthlyRentController.text = property.monthlyRent.toString();
      _securityDepositController.text = property.securityDeposit.toString();
      _descriptionController.text = property.description;
      _selectedType = property.type;
      _selectedStatus = property.status;
      _selectedAmenities = List.from(property.amenities);
      _imageUrls = List.from(property.imageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _squareFeetController.dispose();
    _monthlyRentController.dispose();
    _securityDepositController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final property = Property(
        id: widget.property?.id,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        type: _selectedType,
        bedrooms: int.parse(_bedroomsController.text),
        bathrooms: int.parse(_bathroomsController.text),
        squareFeet: double.parse(_squareFeetController.text),
        monthlyRent: double.parse(_monthlyRentController.text),
        securityDeposit: double.parse(_securityDepositController.text),
        amenities: _selectedAmenities,
        description: _descriptionController.text.trim(),
        imageUrls: _imageUrls,
        createdAt: widget.property?.createdAt ?? DateTime.now(),
        updatedAt: widget.property != null ? DateTime.now() : null,
        status: _selectedStatus,
        ownerId:
            widget.property?.ownerId ??
            'current_user_id', // You'll need to get this from auth
      );

      widget.onSubmit(property);
    }
  }

  void _showAmenitiesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: const Text('Select Amenities'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _availableAmenities.length,
                      itemBuilder: (context, index) {
                        final amenity = _availableAmenities[index];
                        return CheckboxListTile(
                          title: Text(amenity),
                          value: _selectedAmenities.contains(amenity),
                          onChanged: (bool? value) {
                            setDialogState(() {
                              if (value == true) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Name
          CustomTextField(
            controller: _nameController,
            labelText: 'Property Name *',
            hintText: 'Enter property name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Property name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Address
          CustomTextField(
            controller: _addressController,
            labelText: 'Address *',
            hintText: 'Enter property address',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // City, State, Zip Code Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomTextField(
                  controller: _cityController,
                  labelText: 'City *',
                  hintText: 'City',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: _stateController,
                  labelText: 'State *',
                  hintText: 'ST',
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'State is required';
                    }
                    if (value.length != 2) {
                      return 'Invalid state';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: _zipCodeController,
                  labelText: 'Zip Code *',
                  hintText: '12345',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Zip code is required';
                    }
                    if (value.length != 5) {
                      return 'Invalid zip code';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Property Type
          DropdownButtonFormField<PropertyType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Property Type *',
              border: OutlineInputBorder(),
            ),
            items:
                PropertyType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Bedrooms and Bathrooms Row
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _bedroomsController,
                  labelText: 'Bedrooms *',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bedrooms is required';
                    }
                    final bedrooms = int.tryParse(value);
                    if (bedrooms == null || bedrooms < 0) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _bathroomsController,
                  labelText: 'Bathrooms *',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bathrooms is required';
                    }
                    final bathrooms = int.tryParse(value);
                    if (bathrooms == null || bathrooms < 0) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Square Feet
          CustomTextField(
            controller: _squareFeetController,
            labelText: 'Square Feet *',
            hintText: 'Enter square footage',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Square feet is required';
              }
              final sqft = double.tryParse(value);
              if (sqft == null || sqft <= 0) {
                return 'Invalid square feet';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Monthly Rent
          CurrencyInputField(
            controller: _monthlyRentController,
            labelText: 'Monthly Rent *',
            hintText: '0.00',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Monthly rent is required';
              }
              final rent = double.tryParse(value);
              if (rent == null || rent < 0) {
                return 'Invalid rent amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Security Deposit
          CurrencyInputField(
            controller: _securityDepositController,
            labelText: 'Security Deposit *',
            hintText: '0.00',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Security deposit is required';
              }
              final deposit = double.tryParse(value);
              if (deposit == null || deposit < 0) {
                return 'Invalid deposit amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Property Status
          DropdownButtonFormField<PropertyStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Property Status *',
              border: OutlineInputBorder(),
            ),
            items:
                PropertyStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStatus = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Amenities
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amenities',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: _showAmenitiesDialog,
                    child: const Text('Select Amenities'),
                  ),
                ],
              ),
              if (_selectedAmenities.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      _selectedAmenities.map((amenity) {
                        return Chip(
                          label: Text(amenity),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() => _selectedAmenities.remove(amenity));
                          },
                        );
                      }).toList(),
                )
              else
                Text(
                  'No amenities selected',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          CustomTextField(
            controller: _descriptionController,
            labelText: 'Description',
            hintText: 'Enter property description',
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Image Picker
          PropertyImagePicker(
            initialImages: _imageUrls,
            onImagesChanged: (images) {
              setState(() => _imageUrls = images);
            },
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              child:
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                        widget.property == null
                            ? 'Add Property'
                            : 'Update Property',
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
