# Offert App – Backlog / Orders

## Core Engine

- [ ] Improve line item UX (better layout, validation)
- [ ] Support editing units (h, st, m2, etc.)
- [ ] Optional: represent travelFee as QuoteLine instead of template field
- [ ] Add discount line type

---

## PDF

- [ ] Improve PDF layout (table styling, logo placeholder)
- [ ] Add company info section (future)
- [ ] Add VAT support (configurable %)
- [ ] Add page numbering

---

## AI – Phase 1 (Text Only, Opt-In)

- [ ] Add "Suggest with AI" button in ProjectDetailsScreen
- [ ] Send title + notes + template to AI
- [ ] Receive structured JSON with suggested QuoteLines
- [ ] Show suggestions in preview modal
- [ ] User must approve before adding lines

---

## AI – Phase 2 (Audio)

- [ ] Record audio inside app
- [ ] Transcribe to text
- [ ] Feed transcript to AI suggestion engine

---

## AI – Phase 3 (Image)

- [ ] Upload/take photo
- [ ] Send to vision model
- [ ] Extract tasks/material suggestions
- [ ] Merge with existing draft

---

## AI – Phase 4 (Video)

- [ ] Upload video
- [ ] Extract frames
- [ ] Vision analysis
- [ ] Merge suggestions

---

## Professionalization

- [ ] Add VAT configuration
- [ ] Add company profile settings
- [ ] Add export to email
- [ ] Add customer database
- [ ] Add versioning for quotes
- [ ] Add status (Draft / Sent / Accepted)

---

## Infrastructure

- [ ] Add backend skeleton for AI API
- [ ] Define structured AI prompt format
- [ ] Add environment config
- [ ] Add logging