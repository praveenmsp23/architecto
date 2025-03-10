import 'package:architecto/models/audit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String name;
  final String? about;
  final String? address;
  final Audit audit;

  const Organization({
    required this.name,
    this.about,
    this.address,
    required this.audit,
  });

  factory Organization.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Organization(
      name: data['name'] as String? ?? '',
      about: data['about'] as String?,
      address: data['address'] as String?,
      audit: Audit.fromFirestore(data),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'about': about,
        'address': address,
        ...audit.toFirestore(),
      };

  @override
  String toString() =>
      'Organization(name: $name, about: $about, address: $address)';
}
