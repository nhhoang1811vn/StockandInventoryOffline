import 'package:flutter_native_contact_picker_plus/model/contact_model.dart';

/// Values taken from a phone contact, ready to fill a Supplier or Customer.
class ContactFields {
  const ContactFields({
    required this.name,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.description = '',
  });

  final String name;
  final String phone;
  final String email;
  final String address;
  final String description;
}

String _clean(String? value) => value?.trim() ?? '';

List<String> _nonEmpty(Iterable<String?>? values) =>
    (values ?? const <String?>[])
        .map(_clean)
        .where((v) => v.isNotEmpty)
        .toList();

/// Maps a picked contact to [ContactFields]. Returns null when the contact has
/// neither a name nor a company.
ContactFields? mapContact(Contact contact) {
  final company = _clean(contact.organizationInfo?.company);
  final jobTitle = _clean(contact.organizationInfo?.jobTitle);
  final fullName = _clean(contact.fullName);
  final name = fullName.isNotEmpty ? fullName : company;
  if (name.isEmpty) return null;

  final phones = _nonEmpty(contact.phoneNumbers);
  final selected = _clean(contact.selectedPhoneNumber);
  final phone =
      selected.isNotEmpty ? selected : (phones.isNotEmpty ? phones.first : '');

  final emails = _nonEmpty(contact.emailAddresses?.map((e) => e.email));

  String address = '';
  for (final a in contact.postalAddresses ?? const <PostalAddress>[]) {
    final parts =
        _nonEmpty([a.street, a.city, a.state, a.postalCode, a.country]);
    if (parts.isNotEmpty) {
      address = parts.join(', ');
      break;
    }
  }

  final orgParts = <String>[
    if (company.isNotEmpty && company != name) company,
    if (jobTitle.isNotEmpty) jobTitle,
  ];
  final description = <String>[
    if (orgParts.isNotEmpty) orgParts.join(' - '),
    ..._nonEmpty([contact.notes]),
    ...emails.skip(1),
    ...phones.where((p) => p != phone),
  ];

  return ContactFields(
    name: name,
    phone: phone,
    email: emails.isEmpty ? '' : emails.first,
    address: address,
    description: description.join('\n'),
  );
}
