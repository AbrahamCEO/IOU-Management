import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  // Singleton pattern to ensure a single instance of ContactService
  static final ContactService _instance = ContactService._internal();

  factory ContactService() => _instance;

  ContactService._internal();

  Future<void> requestPermission() async {
    final permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      throw Exception('Contacts permission not granted');
    }
  }

  Future<List<Contact>> getContacts() async {
    await requestPermission();
    try {
      return await ContactsService.getContacts();
    } catch (e) {
      throw Exception('Error accessing contacts: $e');
    }
  }
}
