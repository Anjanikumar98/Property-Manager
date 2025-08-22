// lib/features/properties/data/datasources/property_local_datasource.dart
import 'package:uuid/uuid.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/constants/database_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/property_model.dart';
import '../../domain/entities/property.dart';

abstract class PropertyLocalDataSource {
  Future<List<PropertyModel>> getProperties(String ownerId);
  Future<PropertyModel> getPropertyById(String id);
  Future<String> addProperty(PropertyModel property);
  Future<void> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);
  Future<List<PropertyModel>> getPropertiesByStatus(
    String ownerId,
    PropertyStatus status,
  );
}

class PropertyLocalDataSourceImpl implements PropertyLocalDataSource {
  final Uuid _uuid = const Uuid();

  @override
  Future<List<PropertyModel>> getProperties(String ownerId) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.propertiesTable,
        where: '${DatabaseConstants.propertyOwnerId} = ?',
        whereArgs: [ownerId],
        orderBy: '${DatabaseConstants.propertyCreatedAt} DESC',
      );

      return maps.map((map) => PropertyModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get properties: ${e.toString()}');
    }
  }

  @override
  Future<PropertyModel> getPropertyById(String id) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.propertiesTable,
        where: '${DatabaseConstants.propertyId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) {
        throw DatabaseException('Property not found');
      }

      return PropertyModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseException('Failed to get property: ${e.toString()}');
    }
  }

  @override
  Future<String> addProperty(PropertyModel property) async {
    try {
      final db = await DatabaseService.database;
      final String propertyId = _uuid.v4();

      final propertyWithId = PropertyModel(
        id: propertyId,
        name: property.name,
        address: property.address,
        city: property.city,
        state: property.state,
        zipCode: property.zipCode,
        type: property.type,
        bedrooms: property.bedrooms,
        bathrooms: property.bathrooms,
        squareFeet: property.squareFeet,
        monthlyRent: property.monthlyRent,
        securityDeposit: property.securityDeposit,
        amenities: property.amenities,
        description: property.description,
        imageUrls: property.imageUrls,
        createdAt: DateTime.now(),
        updatedAt: null,
        status: property.status,
        ownerId: property.ownerId,
      );

      await db.insert(
        DatabaseConstants.propertiesTable,
        propertyWithId.toMap(),
      );

      return propertyId;
    } catch (e) {
      throw DatabaseException('Failed to add property: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    try {
      final db = await DatabaseService.database;

      final updatedProperty = PropertyModel(
        id: property.id,
        name: property.name,
        address: property.address,
        city: property.city,
        state: property.state,
        zipCode: property.zipCode,
        type: property.type,
        bedrooms: property.bedrooms,
        bathrooms: property.bathrooms,
        squareFeet: property.squareFeet,
        monthlyRent: property.monthlyRent,
        securityDeposit: property.securityDeposit,
        amenities: property.amenities,
        description: property.description,
        imageUrls: property.imageUrls,
        createdAt: property.createdAt,
        updatedAt: DateTime.now(),
        status: property.status,
        ownerId: property.ownerId,
      );

      final result = await db.update(
        DatabaseConstants.propertiesTable,
        updatedProperty.toMap(),
        where: '${DatabaseConstants.propertyId} = ?',
        whereArgs: [property.id],
      );

      if (result == 0) {
        throw DatabaseException('Property not found');
      }
    } catch (e) {
      throw DatabaseException('Failed to update property: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      final db = await DatabaseService.database;

      final result = await db.delete(
        DatabaseConstants.propertiesTable,
        where: '${DatabaseConstants.propertyId} = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw DatabaseException('Property not found');
      }
    } catch (e) {
      throw DatabaseException('Failed to delete property: ${e.toString()}');
    }
  }

  @override
  Future<List<PropertyModel>> getPropertiesByStatus(
    String ownerId,
    PropertyStatus status,
  ) async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.propertiesTable,
        where:
            '${DatabaseConstants.propertyOwnerId} = ? AND ${DatabaseConstants.propertyStatus} = ?',
        whereArgs: [ownerId, status.index],
        orderBy: '${DatabaseConstants.propertyCreatedAt} DESC',
      );

      return maps.map((map) => PropertyModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException(
        'Failed to get properties by status: ${e.toString()}',
      );
    }
  }
}
