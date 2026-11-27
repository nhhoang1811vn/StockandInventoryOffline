import 'package:flutter_native_contact_picker_plus/model/contact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/contact_import/contact_import_mapper.dart';

void main() {
  test('maps a full contact', () {
    final f = mapContact(Contact(
      fullName: 'Nguyen Van An',
      selectedPhoneNumber: '0901234567',
      phoneNumbers: ['0901234567'],
      emailAddresses: [EmailAddress(email: 'an@example.com')],
      postalAddresses: [PostalAddress(street: '12 Le Loi', city: 'HCM')],
      organizationInfo:
          OrganizationInfo(company: 'Cong ty ABC', jobTitle: 'Giam doc'),
      notes: 'Ghi chu',
    ))!;
    expect(f.name, 'Nguyen Van An');
    expect(f.phone, '0901234567');
    expect(f.email, 'an@example.com');
    expect(f.address, '12 Le Loi, HCM');
    expect(f.description, 'Cong ty ABC - Giam doc\nGhi chu');
  });

  test('falls back to company when name is blank', () {
    final f = mapContact(Contact(
      fullName: '  ',
      organizationInfo: OrganizationInfo(company: 'Cong ty ABC'),
    ))!;
    expect(f.name, 'Cong ty ABC');
    expect(f.description, '');
  });

  test('keeps job title when the company became the name', () {
    final f = mapContact(Contact(
      organizationInfo:
          OrganizationInfo(company: 'Cong ty ABC', jobTitle: 'Giam doc'),
    ))!;
    expect(f.name, 'Cong ty ABC');
    expect(f.description, 'Giam doc');
  });

  test('returns null when name and company are blank', () {
    expect(mapContact(Contact(fullName: ' ')), isNull);
    expect(
        mapContact(Contact(
            fullName: '', organizationInfo: OrganizationInfo(company: ' '))),
        isNull);
  });

  test('permission denied: only name and phone', () {
    final f = mapContact(Contact(
      fullName: 'An',
      selectedPhoneNumber: '0901',
      phoneNumbers: ['0901'],
      emailAddresses: [],
      postalAddresses: null,
      organizationInfo: null,
    ))!;
    expect(f.phone, '0901');
    expect(f.email, '');
    expect(f.address, '');
    expect(f.description, '');
  });

  test('address skips empty parts', () {
    final f = mapContact(Contact(
      fullName: 'An',
      postalAddresses: [
        PostalAddress(street: ' ', city: 'HCM', country: 'VN'),
      ],
    ))!;
    expect(f.address, 'HCM, VN');
  });

  test('extra emails go to description', () {
    final f = mapContact(Contact(
      fullName: 'An',
      emailAddresses: [
        EmailAddress(email: 'a@x.com'),
        EmailAddress(email: ' '),
        EmailAddress(email: 'b@x.com'),
      ],
    ))!;
    expect(f.email, 'a@x.com');
    expect(f.description, 'b@x.com');
  });

  test('iOS: first of phoneNumbers is phone, the rest go to description', () {
    final f = mapContact(Contact(
      fullName: 'An',
      selectedPhoneNumber: null,
      phoneNumbers: ['111', '222'],
    ))!;
    expect(f.phone, '111');
    expect(f.description, '222');
  });

  test('description order: company, notes, extra emails, extra phones', () {
    final f = mapContact(Contact(
      fullName: 'An',
      selectedPhoneNumber: '111',
      phoneNumbers: ['111', '222'],
      emailAddresses: [
        EmailAddress(email: 'a@x.com'),
        EmailAddress(email: 'b@x.com')
      ],
      organizationInfo: OrganizationInfo(company: 'ABC'),
      notes: 'note',
    ))!;
    expect(f.description, 'ABC\nnote\nb@x.com\n222');
  });
}
