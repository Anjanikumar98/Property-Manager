// lib/features/properties/presentation/bloc/property_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_property.dart';
import '../../domain/usecases/get_properties.dart';
import '../../domain/usecases/update_property.dart';
import '../../domain/usecases/delete_property.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final AddProperty addProperty;
  final GetProperties getProperties;
  final UpdateProperty updateProperty;
  final DeleteProperty deleteProperty;

  PropertyBloc({
    required this.addProperty,
    required this.getProperties,
    required this.updateProperty,
    required this.deleteProperty,
  }) : super(PropertyInitial()) {
    on<LoadProperties>(_onLoadProperties);
    on<AddPropertyEvent>(_onAddProperty);
    on<UpdatePropertyEvent>(_onUpdateProperty);
    on<DeletePropertyEvent>(_onDeleteProperty);
    on<FilterPropertiesByStatus>(_onFilterPropertiesByStatus);
  }

  Future<void> _onLoadProperties(
    LoadProperties event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await getProperties(event.ownerId);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (properties) => emit(PropertyLoaded(properties)),
    );
  }

  Future<void> _onAddProperty(
    AddPropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await addProperty(event.property);

    result.fold((failure) => emit(PropertyError(failure.message)), (
      propertyId,
    ) {
      emit(PropertyAdded(propertyId));
      // Reload properties after adding
      add(LoadProperties(event.property.ownerId));
    });
  }

  Future<void> _onUpdateProperty(
    UpdatePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await updateProperty(event.property);

    result.fold((failure) => emit(PropertyError(failure.message)), (_) {
      emit(PropertyUpdated());
      add(LoadProperties(event.property.ownerId));
    });
  }

  Future<void> _onDeleteProperty(
    DeletePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await deleteProperty(event.propertyId);

    result.fold((failure) => emit(PropertyError(failure.message)), (_) {
      emit(PropertyDeleted());
      // TODO: Reload properties (needs ownerId tracking in state or event)
      // add(LoadProperties(ownerId));
    });
  }

  Future<void> _onFilterPropertiesByStatus(
    FilterPropertiesByStatus event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await getProperties(event.ownerId);

    result.fold((failure) => emit(PropertyError(failure.message)), (
      properties,
    ) {
      final filteredProperties =
          properties
              .where((property) => property.status == event.status)
              .toList();
      emit(PropertyLoaded(filteredProperties));
    });
  }
}
