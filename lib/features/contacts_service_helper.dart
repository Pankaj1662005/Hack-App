import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsServiceHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchAndUploadContacts() async {
    try {
      if (!await Permission.contacts.request().isGranted) {
        print("❌ Contacts permission denied");
        openAppSettings();
        return 0;
      }

      if (!await FlutterContacts.requestPermission()) {
        print("❌ Permission not granted by user");
        return 0;
      }

      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      print("✅ Fetched ${contacts.length} contacts");

      if (contacts.isEmpty) return 0;

      for (var contact in contacts) {
        await _uploadContactToFirestore(contact);
      }

      return contacts.length;
    } catch (e) {
      print("❌ Error fetching/uploading contacts: $e");
      return 0;
    }
  }

  Future<void> _uploadContactToFirestore(Contact contact) async {
    try {
      DocumentReference ref = _firestore.collection('users').doc(contact.id ?? contact.displayName);
      Map<String, dynamic> data = {
        'name': contact.displayName ?? "Unknown",
        'phones': contact.phones.isNotEmpty
            ? contact.phones.map((p) => p.number).toList()
            : ["No Number"],
        'emails': contact.emails.isNotEmpty
            ? contact.emails.map((e) => e.address).toList()
            : ["No Email"],
        'timestamp': FieldValue.serverTimestamp(),
      };
      await ref.set(data);
      print("✅ Uploaded: ${contact.displayName}");
    } catch (e) {
      print("❌ Error uploading ${contact.displayName}: $e");
    }
  }
}
