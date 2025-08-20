import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String? id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final PropertyType type;
  final int bedrooms;
  final int bathrooms;
  final double squareFeet;
  final double monthlyRent;
  final double securityDeposit;
  final List<String> amenities;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PropertyStatus status;
  final String ownerId;

  const Property({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.squareFeet,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.amenities,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    required this.ownerId,
  });

  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    PropertyType? type,
    int? bedrooms,
    int? bathrooms,
    double? squareFeet,
    double? monthlyRent,
    double? securityDeposit,
    List<String>? amenities,
    String? description,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    PropertyStatus? status,
    String? ownerId,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      type: type ?? this.type,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      squareFeet: squareFeet ?? this.squareFeet,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      amenities: amenities ?? this.amenities,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    city,
    state,
    zipCode,
    type,
    bedrooms,
    bathrooms,
    squareFeet,
    monthlyRent,
    securityDeposit,
    amenities,
    description,
    imageUrls,
    createdAt,
    updatedAt,
    status,
    ownerId,
  ];
}

enum PropertyType { apartment, house, condo, townhouse, studio, commercial }

enum PropertyStatus { available, occupied, maintenance, renovating }

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.house:
        return 'House';
      case PropertyType.condo:
        return 'Condo';
      case PropertyType.townhouse:
        return 'Townhouse';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.commercial:
        return 'Commercial';
    }
  }
}

extension PropertyStatusExtension on PropertyStatus {
  String get displayName {
    switch (this) {
      case PropertyStatus.available:
        return 'Available';
      case PropertyStatus.occupied:
        return 'Occupied';
      case PropertyStatus.maintenance:
        return 'Maintenance';
      case PropertyStatus.renovating:
        return 'Renovating';
    }
  }
}
