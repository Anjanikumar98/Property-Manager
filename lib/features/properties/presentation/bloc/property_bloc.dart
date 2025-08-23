import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_manager/features/properties/domain/entities/property.dart';
import '../../domain/usecases/add_property.dart';
import '../../domain/usecases/get_properties.dart';
import '../../domain/usecases/update_property.dart';
import '../../domain/usecases/delete_property.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final AddProperty _addProperty;
  final GetProperties _getProperties;
  final UpdateProperty _updateProperty;
  final DeleteProperty _deleteProperty;

  PropertyBloc({
    required AddProperty addProperty,
    required GetProperties getProperties,
    required UpdateProperty updateProperty,
    required DeleteProperty deleteProperty,
  }) : _addProperty = addProperty,
       _getProperties = getProperties,
       _updateProperty = updateProperty,
       _deleteProperty = deleteProperty,
       super(PropertyInitial()) {
    on<GetPropertiesEvent>(_onGetProperties);
    on<AddPropertyEvent>(_onAddProperty);
    on<UpdatePropertyEvent>(_onUpdateProperty);
    on<DeletePropertyEvent>(_onDeleteProperty);
    on<GetPropertyEvent>(_onGetProperty);
    on<UpdatePropertyStatusEvent>(_onUpdatePropertyStatus);
    on<SearchPropertiesEvent>(_onSearchProperties);
  }

  Future<void> _onGetProperties(
    GetPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final result = await _getProperties();
      result.fold(
        (failure) => emit(PropertyError(failure.message)),
        (properties) => emit(PropertiesLoaded(properties)),
      );
    } catch (e) {
      emit(PropertyError('Failed to load properties: $e'));
    }
  }

  Future<void> _onAddProperty(
    AddPropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final result = await _addProperty(event.property);
      result.fold((failure) => emit(PropertyError(failure.message)), (
        property,
      ) {
        emit(PropertyAdded(property as Property));
        // Reload properties list
        add(GetPropertiesEvent());
      });
    } catch (e) {
      emit(PropertyError('Failed to add property: $e'));
    }
  }

  Future<void> _onUpdateProperty(
    UpdatePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());

    final result = await _updateProperty(event.property);

    result.fold(
      (failure) {
        emit(PropertyError(failure.message));
      },
      (property) {
        emit(PropertyUpdated(property as dynamic));
        add(GetPropertiesEvent());
      },
    );
  }

  Future<void> _onDeleteProperty(
    DeletePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final result = await _deleteProperty(event.propertyId);
      result.fold((failure) => emit(PropertyError(failure.message)), (_) {
        emit(PropertyDeleted(event.propertyId));
        // Reload properties list
        add(GetPropertiesEvent());
      });
    } catch (e) {
      emit(PropertyError('Failed to delete property: $e'));
    }
  }

  Future<void> _onGetProperty(
    GetPropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      // This would typically call a get single property use case
      // For now, we'll get all properties and filter
      final result = await _getProperties();
      result.fold((failure) => emit(PropertyError(failure.message)), (
        properties,
      ) {
        final property = properties.firstWhere(
          (p) => p.id == event.propertyId,
          orElse: () => throw Exception('Property not found'),
        );
        emit(PropertyLoaded(property));
      });
    } catch (e) {
      emit(PropertyError('Failed to load property: $e'));
    }
  }

  Future<void> _onUpdatePropertyStatus(
    UpdatePropertyStatusEvent event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      // Get current property data
      final result = await _getProperties();
      result.fold((failure) => emit(PropertyError(failure.message)), (
        properties,
      ) async {
        try {
          final property = properties.firstWhere(
            (p) => p.id == event.propertyId,
            orElse: () => throw Exception('Property not found'),
          );

          // Parse status string to enum
          PropertyStatus newStatus;
          switch (event.status.toLowerCase()) {
            case 'available':
              newStatus = PropertyStatus.available;
              break;
            case 'occupied':
              newStatus = PropertyStatus.occupied;
              break;
            case 'maintenance':
              newStatus = PropertyStatus.maintenance;
              break;
            case 'renovating':
              newStatus = PropertyStatus.renovating;
              break;
            default:
              newStatus = PropertyStatus.available;
          }

          // Create updated property with new status
          final updatedProperty = property.copyWith(
            status: newStatus,
            updatedAt: DateTime.now(),
          );

          final updateResult = await _updateProperty(updatedProperty);
          updateResult.fold((failure) => emit(PropertyError(failure.message)), (
            updatedProperty,
          ) {
            emit(PropertyStatusUpdated(event.propertyId, event.status));
            // Reload properties list
            add(GetPropertiesEvent());
          });
        } catch (e) {
          emit(PropertyError('Property not found'));
        }
      });
    } catch (e) {
      emit(PropertyError('Failed to update property status: $e'));
    }
  }

  Future<void> _onSearchProperties(
    SearchPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final result = await _getProperties();
      result.fold((failure) => emit(PropertyError(failure.message)), (
        properties,
      ) {
        List<Property> filteredProperties = properties;

        // Apply text search filter
        if (event.query.isNotEmpty) {
          filteredProperties =
              filteredProperties.where((property) {
                final name = property.name.toLowerCase();
                final address = property.address.toLowerCase();
                final type = property.type.displayName.toLowerCase();
                final query = event.query.toLowerCase();

                return name.contains(query) ||
                    address.contains(query) ||
                    type.contains(query);
              }).toList();
        }

        if (event.filterStatus != null &&
            event.filterStatus!.isNotEmpty &&
            event.filterStatus != 'All') {
          filteredProperties =
              filteredProperties.where((property) {
                return property.status.displayName.toLowerCase() ==
                    event.filterStatus!.toLowerCase();
              }).toList();
        }

        emit(PropertiesLoaded(filteredProperties));
      });
    } catch (e) {
      emit(PropertyError('Failed to search properties: $e'));
    }
  }
}
