// lib/features/properties/presentation/pages/add_property_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import '../widgets/property_form.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class AddPropertyPage extends StatelessWidget {
  final Property? property;

  const AddPropertyPage({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: property == null ? 'Add Property' : 'Edit Property',
      ),
      body: BlocListener<PropertyBloc, PropertyState>(
        listener: (context, state) {
          if (state is PropertyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PropertyAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Property added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PropertyUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Property updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<PropertyBloc, PropertyState>(
            builder: (context, state) {
              return PropertyForm(
                property: property,
                isLoading: state is PropertyLoading,
                onSubmit: (Property propertyToSubmit) {
                  if (property == null) {
                    // Adding new property
                    context.read<PropertyBloc>().add(
                      AddPropertyEvent(propertyToSubmit),
                    );
                  } else {
                    // Updating existing property
                    context.read<PropertyBloc>().add(
                      UpdatePropertyEvent(propertyToSubmit),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

