# Offert App – Architecture

## Goal
Offline-first Flutter app for creating structured quotes/offers.
Manual-first UX. AI will only *suggest* later, never override pricing.

Primary runtime right now: **Chrome (web)**. Android/iOS later.

---

## High-level flow

1. User creates a Project (ProjectDraft)
2. User selects an optional PricingTemplate
3. User adds QuoteLines (labor/material/fee)
4. App calculates subtotal/markup/total deterministically
5. User exports PDF (web download)
6. Later: AI suggests QuoteLines based on text/audio/image/video (opt-in)

---

## State management

### AppState (ChangeNotifier)
- Source of truth for drafts + templates
- Handles CRUD and persistence
- Notifies UI via ChangeNotifier

### AppStateScope (InheritedNotifier)
- Provides AppState globally in widget tree
- Access pattern:
  - `final appState = AppStateScope.of(context);`

---

## Persistence

### StorageService (SharedPreferences)
- Stores lists as JSON:
  - Drafts
  - Templates
- Must be tolerant to missing fields (migration-friendly)

Key principles:
- Backwards compatibility when adding fields.
- If needed, bump storage keys to reset broken legacy data.

---

## Domain models

### PricingTemplate
Defines pricing defaults:
- `hourlyRate`
- `minHours`
- `travelFee`
- `markupPct`

Important:
- Template IDs must be unique (avoid timestamp-only collisions).
- Template deletion must detach templateId from any drafts that referenced it.

### ProjectDraft
Represents a project/offert draft:
- `id`
- `title`
- `clientName`
- `notes`
- `pricingTemplateId` (nullable)
- `lines: List<QuoteLine>` (default empty)

### QuoteLine
Represents an offer line item:
Types:
- `labor` (time-based, e.g. hours)
- `material` (qty-based)
- `fee` (fixed or qty-based fees)

Fields (minimal):
- `id`
- `type`
- `title`
- `qty`
- `unit` (e.g. "h", "st", "m2")
- `unitPrice`
- `note` (optional)

Computed:
- `lineTotal = qty * unitPrice`

---

## Deterministic pricing rules

### Subtotal
`subtotal = sum(line.lineTotal for all lines)`

### Markup
If PricingTemplate exists:
`markupAmount = subtotal * (markupPct / 100)`

### Total
`total = subtotal + markupAmount`

Notes:
- travelFee can be represented as a `fee` QuoteLine (recommended),
  OR displayed separately if still stored in template.
- AI must never "invent" totals; it can only suggest lines/hours/materials.

---

## UI structure (screens)

### HomeScreen
- Start new project
- List projects
- Open templates

### ProjectScreen (New project)
- Create a new draft
- Select template
- Save

### ProjectsListScreen
- List drafts
- Delete
- Open ProjectDetailsScreen

### ProjectDetailsScreen
- Display project fields
- Display selected template info
- Display line items + totals (Subtotal/Markup/Total)
- Actions:
  - Edit project
  - Export PDF

### EditProjectScreen
- Edit basic fields and template selection
- Must handle missing/deleted template IDs safely (dropdown value can’t reference missing item)

### TemplatesListScreen
- List templates
- Add/Edit/Delete

### EditTemplateScreen
- Create/update templates

---

## PDF export (web-first)

Target:
- AppBar button: "Export PDF"
- Generate PDF containing:
  - Project title
  - Client name
  - Notes
  - Template summary
  - Line items table
  - Subtotal/Markup/Total

Web behavior:
- Download via browser (Chrome).
- Filename: `offert_<project-title>.pdf` (sanitized)

Keep implementation minimal.
Prefer a small helper over heavy service layers.

---

## AI integration plan (later)

### Phase 1: Text suggestions (opt-in)
Input:
- Project title + notes + selected template
Output (structured JSON):
- Suggested QuoteLines
- Suggested hours/material quantities
- Suggested offer text draft

Rules:
- AI only suggests; user approves.
- Pricing remains deterministic.

### Phase 2: Audio
- Record audio -> transcribe -> same as Phase 1

### Phase 3: Images
- Upload/take photos -> vision analysis -> suggestions -> QuoteLines

### Phase 4: Video
- Extract frames -> vision -> merged suggestions

---

## Coding conventions for agents

- Read `AGENT_CONTEXT.md` before implementing.
- Keep changes minimal.
- Avoid creating new layers unless necessary.
- Run `flutter analyze` before commit.
- Prefer small commits, one feature per branch.