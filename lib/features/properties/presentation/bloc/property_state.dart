import 'package:equatable/equatable.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertiesLoaded extends PropertyState {
  final List<Property> properties;

  const PropertiesLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class PropertyLoaded extends PropertyState {
  final Property property;

  const PropertyLoaded(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyAdded extends PropertyState {
  final Property property;

  const PropertyAdded(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyUpdated extends PropertyState {
  final Property property;

  const PropertyUpdated(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyDeleted extends PropertyState {
  final String propertyId;

  const PropertyDeleted(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class PropertyStatusUpdated extends PropertyState {
  final String propertyId;
  final String status;

  const PropertyStatusUpdated(this.propertyId, this.status);

  @override
  List<Object?> get props => [propertyId, status];
}

class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);

  @override
  List<Object?> get props => [message];
}
