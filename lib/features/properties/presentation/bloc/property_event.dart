// lib/features/properties/presentation/bloc/property_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/property.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadProperties extends PropertyEvent {
  final String ownerId;

  const LoadProperties(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}

class AddPropertyEvent extends PropertyEvent {
  final Property property;

  const AddPropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class UpdatePropertyEvent extends PropertyEvent {
  final Property property;

  const UpdatePropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class DeletePropertyEvent extends PropertyEvent {
  final String propertyId;

  const DeletePropertyEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class FilterPropertiesByStatus extends PropertyEvent {
  final String ownerId;
  final PropertyStatus status;

  const FilterPropertiesByStatus(this.ownerId, this.status);

  @override
  List<Object?> get props => [ownerId, status];
}
