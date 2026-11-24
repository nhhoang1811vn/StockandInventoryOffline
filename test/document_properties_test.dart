import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/settings/document_properties/bloc/document_properties_cubit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('dp_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  void expectAllTrue(DocumentPropertiesSettings s) {
    expect(s.showImage, isTrue);
    expect(s.showDocumentNo, isTrue);
    expect(s.showDateTime, isTrue);
    expect(s.showDescription, isTrue);
  }

  group('storage', () {
    test('defaults are all true when nothing saved', () {
      expectAllTrue(AppSettings.getDocumentPropertiesSettings(storeId: 1));
    });

    test('values are isolated per store', () {
      AppSettings.setDocumentPropertiesSettings(
        DocumentPropertiesSettings(showDateTime: false),
        storeId: 1,
      );
      expect(AppSettings.getDocumentPropertiesSettings(storeId: 1).showDateTime,
          isFalse);
      expectAllTrue(AppSettings.getDocumentPropertiesSettings(storeId: 2));
    });

    test('does not mix with Good properties of the same store', () {
      AppSettings.setDocumentPropertiesSettings(
        DocumentPropertiesSettings(showDescription: false),
        storeId: 1,
      );
      expect(AppSettings.getGoodPropertiesSettings(storeId: 1).showDescription,
          isTrue);
    });

    test('corrupt json and store -1 fall back to defaults', () async {
      await prefs.setString('DocumentPropertiesSettings_3', '{not json');
      expectAllTrue(AppSettings.getDocumentPropertiesSettings(storeId: 3));
      expect(AppSettings.getSelectedStoreId(), -1);
      expectAllTrue(AppSettings.getDocumentPropertiesSettings());
    });

    test('setting bumps its revision notifier', () {
      final before = AppSettings.documentPropertiesRevision.value;
      AppSettings.setDocumentPropertiesSettings(
        DocumentPropertiesSettings(showDocumentNo: false),
        storeId: 1,
      );
      expect(AppSettings.documentPropertiesRevision.value, before + 1);
    });
  });

  group('cubit', () {
    setUp(() => AppSettings.setSelectedStoreId(11));

    test('init with nothing saved shows all four', () {
      final cubit = DocumentPropertiesCubit()..init();
      expect(cubit.state.showImage, isTrue);
      expect(cubit.state.showDocumentNo, isTrue);
      expect(cubit.state.showDateTime, isTrue);
      expect(cubit.state.showDescription, isTrue);
    });

    test('turning date off saves only it for the selected store', () {
      final cubit = DocumentPropertiesCubit()..init();
      cubit.onShowDateTimeChanged(false);
      final saved = AppSettings.getDocumentPropertiesSettings(storeId: 11);
      expect(saved.showDateTime, isFalse);
      expect(saved.showDocumentNo, isTrue);
      expect(saved.showDescription, isTrue);
      final fresh = DocumentPropertiesCubit()..init();
      expect(fresh.state.showDateTime, isFalse);
    });
  });

  group('image toggle', () {
    test('is saved per store without touching the others', () {
      AppSettings.setSelectedStoreId(21);
      final cubit = DocumentPropertiesCubit()..init();
      cubit.onShowImageChanged(false);
      final saved = AppSettings.getDocumentPropertiesSettings(storeId: 21);
      expect(saved.showImage, isFalse);
      expect(saved.showDocumentNo, isTrue);
      expect(saved.showDateTime, isTrue);
      expect(saved.showDescription, isTrue);
      expect(AppSettings.getDocumentPropertiesSettings(storeId: 22).showImage,
          isTrue);
    });

    test('old saved json without showImage defaults it to true', () async {
      SharedPreferences.setMockInitialValues({
        'DocumentPropertiesSettings_5': '{"showDocumentNo":false}',
      });
      final p = await SharedPreferences.getInstance();
      await AppSettings.initialize(PrefStorage(prefs: p));
      final s = AppSettings.getDocumentPropertiesSettings(storeId: 5);
      expect(s.showDocumentNo, isFalse);
      expect(s.showImage, isTrue);
    });
  });

  group('displayName', () {
    String tr(String k) => 'T:$k';
    final doc = Document()
      ..name = 'No 7'
      ..type = DocumentType.outgoing;

    test('uses the Document no when it is shown', () {
      expect(DocumentPropertiesSettings().displayName(doc, tr), 'No 7');
    });

    test('falls back to the Document type label when Document no is hidden',
        () {
      final p = DocumentPropertiesSettings(showDocumentNo: false);
      expect(p.displayName(doc, tr), 'T:outgoing');
      expect(
          p.displayName(doc..type = DocumentType.incoming, tr), 'T:incoming');
    });
  });
}
