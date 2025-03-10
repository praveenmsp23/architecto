import 'package:architecto/models/audit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SiteLocation {
  final double latitude;
  final double longitude;

  const SiteLocation({
    required this.latitude,
    required this.longitude,
  });

  factory SiteLocation.defaultSiteLocation() => const SiteLocation(
        latitude: 0.0,
        longitude: 0.0,
      );

  factory SiteLocation.fromFirestore(Map<String, dynamic> data) => SiteLocation(
        latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toFirestore() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() =>
      'SiteLocation(latitude: $latitude, longitude: $longitude)';
}

class Site {
  final String name;
  final SiteLocation location;
  final String organization;
  final Audit audit;

  const Site({
    required this.name,
    required this.location,
    required this.organization,
    required this.audit,
  });

  factory Site.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Site(
      name: data['name'] as String? ?? '',
      location: SiteLocation.fromFirestore(
          data['location'] as Map<String, dynamic>? ?? {}),
      organization: data['organization'] as String? ?? '',
      audit: Audit.fromFirestore(data),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'location': location.toFirestore(),
        'organization': organization,
        ...audit.toFirestore(),
      };

  @override
  String toString() =>
      'Site(name: $name, location: $location, organization: $organization)';
}
