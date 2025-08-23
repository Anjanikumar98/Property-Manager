import 'package:equatable/equatable.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class GetPropertiesEvent extends PropertyEvent {}

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

class GetPropertyEvent extends PropertyEvent {
  final String propertyId;

  const GetPropertyEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class UpdatePropertyStatusEvent extends PropertyEvent {
  final String propertyId;
  final String status;

  const UpdatePropertyStatusEvent(this.propertyId, this.status);

  @override
  List<Object?> get props => [propertyId, status];
}

class SearchPropertiesEvent extends PropertyEvent {
  final String query;
  final String? filterStatus;

  const SearchPropertiesEvent(this.query, {this.filterStatus});

  @override
  List<Object?> get props => [query, filterStatus];
}
