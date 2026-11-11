# AGENTS.md

## Scope

This repository contains the KrakenDraw Flutter mobile client. Keep changes
within this repository unless the user explicitly asks for work in another
project. The backend is a separate sibling repository.

## Project conventions

- Use Flutter and Dart; follow the existing Riverpod, GoRouter, Dio, and Material
  3 patterns already used in `lib/`.
- Keep API calls in `lib/core/network/services/` and reuse the shared API
  client so authentication cookies and error handling remain consistent.
- Keep report intent parsing, report coordination/formatting, and file export
  in their existing `lib/core/report/` and `lib/core/export/` modules.
- Preserve the app's KrakenDraw branding and existing light/dark neon theme.
- Do not add dependencies or change generated/platform files unless needed for
  the requested behavior.

## Reports and dashboard boundary

- The chat report flow uses `GET /api/reportes/consultar` through
  `ReportesService`; the report intent parser sends requested metrics,
  categories, date range, and Top N where applicable.
- For technology reports, category names may be sent comma-separated. Keep the
  response, chat answer, PDF, and XLSX scoped to the categories requested by
  the user. Multiple requested categories should all be included. Preserve
  `top_n` when exporting from a report message.
- PDF and XLSX must be generated from the same scoped report data. XLSX should
  include only relevant data sheets; PDF may include tables and charts.
- Do not change dashboard endpoints or dashboard data filtering as part of a
  report-only change. Dashboard technology views rely on the complete category
  dataset.

## Regenerated files

- Route ZIP/SQL saves through `DownloadSaver`. Offer the platform save dialog;
  if it is canceled or unavailable, save to the existing Downloads directory,
  falling back to app Documents, and tell the user where the file was saved.
- Keep only the latest 20 regeneration records per account in the on-device
  SQLite database. Do not send filesystem paths or document references to the
  backend.
- Store a local openable copy when the selected destination uses a platform
  document reference. The assistant can report locations from this local
  history and open a saved file; handle moved or missing files without
  claiming they are still available.

## Commands

Prefix shell commands with `rtk` as required by the workspace instructions.
Use targeted `flutter analyze` for changed Dart code when validation is needed.
Do not run automated tests unless the user asks for them.
