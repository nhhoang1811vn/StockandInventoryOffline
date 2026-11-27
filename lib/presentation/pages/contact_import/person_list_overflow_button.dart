import 'package:flutter/material.dart';

enum PersonListOverflowMenu { importFromContacts, help }

/// Overflow (⋮) menu of the supplier and customer lists: Import from
/// contacts (optional) and Help.
class PersonListOverflowButton extends StatelessWidget {
  const PersonListOverflowButton({
    super.key,
    required this.importLabel,
    required this.helpLabel,
    required this.onImportFromContacts,
    required this.onHelp,
    this.showImport = true,
  });

  final String importLabel;
  final String helpLabel;
  final VoidCallback onImportFromContacts;
  final VoidCallback onHelp;
  final bool showImport;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PersonListOverflowMenu>(
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (item) {
        switch (item) {
          case PersonListOverflowMenu.importFromContacts:
            onImportFromContacts();
          case PersonListOverflowMenu.help:
            onHelp();
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<PersonListOverflowMenu>>[
        if (showImport)
          PopupMenuItem<PersonListOverflowMenu>(
            value: PersonListOverflowMenu.importFromContacts,
            child: Text(importLabel),
          ),
        PopupMenuItem<PersonListOverflowMenu>(
          value: PersonListOverflowMenu.help,
          child: Text(helpLabel),
        ),
      ],
    );
  }
}
