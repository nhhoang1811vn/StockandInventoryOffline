# AGENTS.md — Instructions for AI coding agents

## Before you start

1. Read [CONTEXT.md](CONTEXT.md) first (glossary, stack, constraints).
2. Read the document relevant to your task before changing code:
    - structure, state, DI, routing → [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
    - rules, limits, workflows → [docs/BUSINESS_LOGIC.md](docs/BUSINESS_LOGIC.md)
    - schema, migrations, SQL → [docs/DATABASE.md](docs/DATABASE.md)
    - build, codegen, translations, CI → [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
3. Search for an existing implementation (widget, cubit method, query, util) before writing a new
   one. Reuse it.

## Rules

- **Follow existing patterns.** New screens follow `lib/presentation/pages/<feature>/` with a
  `bloc/` folder (`@injectable` Cubit + freezed state), a route in `lib/presentation/router.dart`
  and a constant in `lib/presentation/pages/pages.dart`.
- **No business logic in widgets.** Widgets render state and call cubit methods. Rules and data
  access go to cubits, use cases, repositories or `DBHelper`.
- **Preserve behaviour** unless the task explicitly asks for a change. Existing bugs listed in the
  docs are not yours to fix as a side effect; mention them instead.
- **Touch only what the task needs.** Do not reformat, rename or "clean up" unrelated files.
- **Do not invent** APIs, methods, models, tables or columns. Confirm them in source. If
  something is not documented and not in code, say it is unknown.
- **Avoid new dependencies.** Prefer what is in `pubspec.yaml`. Ask before adding a package.
- **Domain language.** Use the terms in the CONTEXT.md glossary in code and user-facing text.
- **Localization.** Add user-visible strings to every file in `assets/translations/` (11 locales),
  editing the JSON directly (see DEVELOPMENT.md). Do not use the legacy `translation/` scripts.
- **Schema changes.** Follow the checklist in DATABASE.md. Never edit an existing migration entry.
- **Generated files.** Do not hand-edit `lib/di/di.config.dart`, `*.freezed.dart` or `*.g.dart`.
  Re-run codegen.
- **Secrets.** Do not add keys, keystores or credentials. Do not print or copy existing ones.

## After you change code

1. Run codegen if you changed annotated classes, freezed states or DI registrations.
2. Run `flutter analyze`.
3. Run `flutter test`. There are currently no tests in the repo; if you add logic, add a test
   (create `test/`) or state that nothing could be run.
4. Report what you ran and its result, and what you could not verify.

## Keep docs true

Update the affected document in the same change when you alter an architectural decision, a
business rule, the schema, a migration, a route or the build process. Record significant decisions
as a new file in `docs/adr/`. Do not duplicate content across docs; link instead.
