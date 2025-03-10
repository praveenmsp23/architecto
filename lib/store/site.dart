import 'package:architecto/models/audit.dart';
import 'package:architecto/models/site.dart';
import 'package:architecto/utils/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SiteStore {
  final CollectionReference sites =
      FirebaseFirestore.instance.collection('sites');

  Future<Site?> getSite(String siteId) async {
    DocumentSnapshot doc = await sites.doc(siteId).get();
    if (doc.exists) {
      return Site.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  Future<Site> createSite(String name, String organization, String createdBy,
      [SiteLocation? location]) async {
    String siteId = generateId("sit");
    Site site = Site(
      name: name,
      location: SiteLocation.defaultSiteLocation(),
      organization: organization,
      audit: Audit.defaultAudit(createdBy),
    );

    await sites.doc(siteId).set(site.toFirestore());
    return site;
  }

  Future<void> updateSite(
      String siteId, String siteName, SiteLocation location) async {
    Site? site = await getSite(siteId);
    if (site == null) return null;
    await sites.doc(siteId).update({
      'siteName': siteName,
      'location': location.toFirestore(),
    });
  }

  Future<void> deleteSite(String siteId) async {
    await sites.doc(siteId).delete();
  }
}
