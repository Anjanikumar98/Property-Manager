// lib/features/properties/data/models/property_model.dart
import 'dart:convert';
import '../../domain/entities/property.dart';

class PropertyModel extends Property {
  const PropertyModel({
    super.id,
    required super.name,
    required super.address,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.type,
    required super.bedrooms,
    required super.bathrooms,
    required super.squareFeet,
    required super.monthlyRent,
    required super.securityDeposit,
    required super.amenities,
    required super.description,
    required super.imageUrls,
    required super.createdAt,
    super.updatedAt,
    required super.status,
    required super.ownerId,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      type: PropertyType.values.firstWhere(
        (e) => e.toString() == 'PropertyType.${json['type']}',
      ),
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      squareFeet: json['squareFeet'].toDouble(),
      monthlyRent: json['monthlyRent'].toDouble(),
      securityDeposit: json['securityDeposit'].toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      description: json['description'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      status: PropertyStatus.values.firstWhere(
        (e) => e.toString() == 'PropertyStatus.${json['status']}',
      ),
      ownerId: json['ownerId'],
    );
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      type: PropertyType.values[map['type']],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      squareFeet: map['squareFeet'].toDouble(),
      monthlyRent: map['monthlyRent'].toDouble(),
      securityDeposit: map['securityDeposit'].toDouble(),
      amenities:
          map['amenities'] != null
              ? (jsonDecode(map['amenities']) as List).cast<String>()
              : <String>[],
      description: map['description'],
      imageUrls:
          map['imageUrls'] != null
              ? (jsonDecode(map['imageUrls']) as List).cast<String>()
              : <String>[],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      status: PropertyStatus.values[map['status']],
      ownerId: map['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'type': type.toString().split('.').last,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'squareFeet': squareFeet,
      'monthlyRent': monthlyRent,
      'securityDeposit': securityDeposit,
      'amenities': amenities,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status.toString().split('.').last,
      'ownerId': ownerId,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'type': type.index,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'squareFeet': squareFeet,
      'monthlyRent': monthlyRent,
      'securityDeposit': securityDeposit,
      'amenities': jsonEncode(amenities),
      'description': description,
      'imageUrls': jsonEncode(imageUrls),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status.index,
      'ownerId': ownerId,
    };
  }

  factory PropertyModel.fromEntity(Property property) {
    return PropertyModel(
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
      updatedAt: property.updatedAt,
      status: property.status,
      ownerId: property.ownerId,
    );
  }
}

