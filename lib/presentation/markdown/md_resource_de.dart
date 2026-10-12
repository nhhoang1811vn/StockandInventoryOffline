import 'package:good_manager/presentation/markdown/md_bundle.dart';

class MarkdownResourceDE {
  static const bundle = MarkdownBundle(
    whatNews: """
### Version 1.0.92 - 12. Okt. 2026
* Eingangs- und Ausgangssummen auf der Belegkarte der Startseite.
* Zusammenfassungsleiste bei Artikeln, Verlauf, Belegen, Zahlungen, Filialen, Lieferanten und Kunden.
* Beleg- und Zahlungszusammenfassung folgt dem gewählten Tab.
* Lieferant nutzt ein LKW-Symbol. Kunde nutzt ein Personen-Symbol.
* Hilfe und Versionshinweise gibt es in jeder App-Sprache.

### Version 1.0.91 - 08. Okt. 2026
* Excel-Import und -Export im Inventarmenü.
* Lange-Druck-Aktionen für letzte Belege auf der Startseite.
* Lange-Druck-Aktionen für Suchergebnisse.
* Kategorien heißen in den Einstellungen jetzt Zahlungskategorien.

### Version 1.0.90 - 06. Okt. 2026
* Startseite, Inventar, Zahlungen, Berichte und Einstellungen aktualisiert.
* Fotos für Filialen, Gruppen, Kunden und Lieferanten.
* Listen, Leerzustände und Einführung aktualisiert.
* Übersetzungen verbessert.
* Gemeldete Fehler behoben.

### Version 1.0.80 - 23. Apr. 2026
* Gemeldete Fehler behoben.
* Anleitung für den Wechsel zur Online-Version.
* Oberfläche überarbeitet.

### Version 1.0.75 - 16. Apr. 2026
* Gemeldete Fehler behoben.
* Neue Währung.
* Doppelte Barcodes bei Artikeln behoben.

### Version 1.0.70 - 06. Feb. 2026
* Gemeldete Fehler behoben.
* Neue Währung.
* Datensynchronisierung aktualisiert.
* Logo aktualisiert (für die Online-Version).

### Version 1.0.65 - 20. Sep. 2025
* Gemeldete Fehler behoben.
* Neuer Bericht: Artikelinfo.

### Version 1.0.60 - 09. Sep. 2025
* Anmeldung mit Apple-Konto behoben.
* Gemeldete Fehler behoben.
* Design, Sprache und Währung in den Einstellungen.
* Logo und Dateien beim Speichern eines Artikels aktualisiert.
* Anmeldung aktualisiert.
* Oberfläche aktualisiert.

### Version 1.0.45 - 12. Juli 2025
* Gemeldete Fehler behoben.

### Version 1.0.40 - 25. Juli 2025
* Barcode-Scan unter Android behoben.
* Hinweis auf niedrigen Bestand beim Start behoben.
* Gemeldete Fehler behoben.
* App-Sprache im Menü.
* Oberfläche aktualisiert.

### Version 1.0.30 - 30. Mai 2025
* Gemeldete Fehler behoben.
* Mindestmenge.
* Firmeninformationen.
* Dunkles Design und Codesperre.
* Nachbestellbericht.

### Version 1.0.25 - 14. Apr. 2025
* Gemeldete Fehler behoben.
* Zahlungen.
* Geldbörsen.
* 5 Berichtsarten.

### Version 1.0.8 - 06. Dez. 2024
* Gemeldete Fehler behoben.
* Listeneinstellungen bei Artikeln.
* Suche bei Artikeln aktualisiert.
* Schnelle Synchronisierung.

### Version 1.0.7 - 27. Sep. 2024
* Gemeldete Fehler behoben.
* iOS-Unterstützung.

### Version 1.0.6 - 07. Juli 2024
* Gemeldete Fehler behoben.
* Schnelles Anlegen eines Belegs beim Speichern eines Artikels.
* Artikelhistorie.

### Version 1.0.5 - 14. Juni 2024
* Anmeldung und Registrierung.
* Nutzerdaten werden in der Cloud gespeichert.
* Gemeldete Fehler behoben.

### Version 1.0.4 - 18. Apr. 2024
* Scrollen in der Berichtsdetailansicht behoben.

### Version 1.0.3 - 15. Apr. 2024
* Datumsbereich für Berichte.
* Gruppe auswählen behoben.

### Version 1.0.2 - 12. Apr. 2024
* Windows-Unterstützung.
* Bericht Artikelliste.
* PDF- und CSV-Export.
* Sicherung und Wiederherstellung.

### Version 1.0.1 - 04. Apr. 2024
* Belegmenge von Ganzzahl auf Dezimalzahl umgestellt.
* Ton und Vibration beim Scannen eines Barcodes.
* Aktualisierung auf Material 3.

### Version 1.0.0
* Erste Version.
""",
    helpDocuments: """
## Belege

Belege erfassen Waren, die in eine Filiale hinein- oder herausgehen.

### Eingang
- Legen Sie einen Eingangsbeleg an, wenn Waren in der Filiale **ankommen**.
- Die Mengen im Beleg werden zum Bestand **addiert**.

### Ausgang
- Legen Sie einen Ausgangsbeleg an, wenn Waren die Filiale **verlassen** (zum Beispiel ein Verkauf).
- Die Mengen im Beleg werden vom Bestand **abgezogen**.

### Artikel hinzufügen
- Wählen Sie Artikel aus dem Katalog, oder
- **Scannen Sie einen Barcode** mit der Kamera.

### Stapelscan
- Scannen Sie Barcodes nacheinander. Jeder Scan **fügt den Artikel hinzu und erhöht die Menge um 1**.
- Oder geben Sie die Menge nach jedem Scan **manuell** ein.
- Den Modus wählen Sie in den **Einstellungen**.

### Automatisch anlegen
- Ein **neuer Artikel** in einem Eingangsbeleg (mit vollständigen Angaben) wird im **Katalog gespeichert**.
- Einem Ausgangsbeleg können Sie keinen neuen Artikel hinzufügen. Der Artikel muss bereits im Bestand sein.

### Löschen
- **Tippen Sie lange** auf einen Beleg oder eine Zeile, um ihn zu löschen.

> Das Löschen eines Belegs ändert den Bestand. Sie können nur den **neuesten** Beleg löschen. Das Löschen eines älteren Belegs kann die Mengen verfälschen.

### Filtern und sortieren
- Nutzen Sie die Leiste, um Belege zu **filtern** oder zu **sortieren**.
""",
    helpGoods: """
## Artikel

Der Bildschirm Artikel ist der Katalog aller Waren in der Filiale, einschließlich des aktuellen Bestands.

Fügen Sie Artikel aus dieser Liste einem Beleg hinzu. Hat ein Artikel einen Barcode, scannen Sie ihn mit der Kamera, um ihn schnell hinzuzufügen.

> Die Bestandsmenge lässt sich nicht von Hand ändern. Sie wird aus den Belegen berechnet.

### Aktionen
- Tippen Sie beim Bearbeiten eines Artikels auf die **Kamera** neben dem Barcode, um zu scannen.
- **Tippen Sie lange** auf einen Artikel, um ihn zu löschen.
- Nutzen Sie die Leiste zum **Suchen** oder **Sortieren**.

### Automatisch anlegen
- Der Katalog muss nicht zuerst vollständig sein.
- Legen Sie einen Eingangsbeleg an und erfassen Sie einen neuen Artikel. Er wird automatisch im **Katalog gespeichert**.
- Beim nächsten Mal können Sie ihn per Barcode hinzufügen.
""",
    helpStores: """
## Filialen

Mit Filialen trennen Sie den Bestand nach Ort (Laden, Lager und so weiter).

### Bestand je Filiale
- Jede Filiale hat ihren **eigenen Bestand**.
- Jeder Beleg gehört zu **einer Filiale**.

### Filiale wechseln
- Tippen Sie auf der **Startseite** auf den Namen oder das Bild der Filiale, um die aktuelle Filiale zu wechseln.

### Hinzufügen und verwalten
- Öffnen Sie **Filialen** in den Einstellungen, um eine Filiale hinzuzufügen, zu bearbeiten oder zu löschen.

### Grenzen
- Die kostenlose Version unterstützt bis zu **2 Filialen**.
- Mit **Stock Premium** sind es mehr. Das Abo enthält **7 Tage kostenlos zum Testen**.
""",
    helpSupplierCustomers: """
## Lieferanten und Kunden

Bewahren Sie Lieferanten- und Kundendaten an einem Ort auf. Erfassen Sie sie von Hand oder **importieren Sie sie aus den Kontakten**.

### Einem Beleg zuordnen
- Tippen Sie bei einem **Eingangsbeleg** auf **Lieferant**.
- Tippen Sie bei einem **Ausgangsbeleg** auf **Kunde**.

### Einträge verwalten
- **Tippen Sie lange** auf einen Lieferanten oder Kunden, um:
  - Zugehörige Belege anzuzeigen
  - Den Eintrag zu löschen
""",
    helpPayments: """
## Zahlungen

Zahlungen erfassen Geld, das in eine Geldbörse hinein- oder herausfließt.

### Eingang
- Erfassen Sie, wenn Sie **Geld von einem Kunden erhalten**.
- Meist mit einem **Ausgangsbeleg** verknüpft.
- Verfolgt eingehendes Geld.

### Ausgang
- Erfassen Sie, wenn Sie einen **Lieferanten bezahlen**.
- Meist mit einem **Eingangsbeleg** verknüpft.
- Verfolgt ausgehendes Geld.

### Zahlung hinzufügen
- Öffnen Sie **Zahlungen**, oder fügen Sie eine Zahlung aus einem Beleg hinzu.
- Wählen Sie **Eingang** oder **Ausgang**.
- Geben Sie **Betrag**, **Datum**, Person und optional Notizen ein.
- Verknüpfen Sie bei Bedarf einen **Beleg**.

### Verknüpfte Belege
- Eine verknüpfte Zahlung zeigt, wofür das Geld ist.
- Eine Teilzahlung markiert den Beleg als **Teilweise**.
- Eine vollständige Zahlung markiert den Beleg als **Bezahlt**.

### Bearbeiten oder löschen
- **Tippen Sie lange** auf eine Zahlung, um sie zu bearbeiten oder zu löschen.

> Das Löschen einer Zahlung kann den Zahlungsstatus des Belegs ändern.

### Filtern und sortieren
- Nutzen Sie die Leiste, um Zahlungen zu **filtern** oder zu **sortieren**.
""",
    helpMinQuan: """
## Mindestmenge

Legen Sie für jeden Artikel eine **Mindestmenge** fest, damit Sie wissen, wann nachbestellt werden soll.

### Was das ist
- Der niedrigste Bestand, den Sie halten möchten.
- Fällt der Bestand unter diese Zahl, erscheint der Artikel im Bericht **Nachbestellen** und auf der **Startseite** als niedriger Bestand.

### Festlegen
- Öffnen Sie einen Artikel beim Hinzufügen oder Bearbeiten.
- Geben Sie eine Zahl bei **Mindestmenge** ein (zum Beispiel 5 oder 10).

### Niedriger Bestand
- Nutzen Sie den Bericht **Nachbestellen**, um Artikel unter dem Minimum zu sehen.
- Die Startseite zeigt auch **Nicht vorrätig** und **Niedriger Bestand**.

### Aktualisieren
- Bearbeiten Sie den Artikel jederzeit, um das Minimum zu ändern.
- Passen Sie es an Verkaufstempo oder Saison an.

### Tipps
- Nutzen Sie ein höheres Minimum für schnell verkaufte oder wichtige Artikel.
- Prüfen Sie die Werte regelmäßig, damit die Hinweise nützlich bleiben.
""",
  );
}
