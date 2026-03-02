# Offert App – Agent Context

## Purpose
This is an offline-first Flutter app for generating structured construction quotes.

## Core Principles

1. Manual-first.
   AI must only suggest, never override.
   All pricing is deterministic.

2. Pricing logic is deterministic.
   - Line items define subtotal.
   - Markup is applied on subtotal.
   - Total = subtotal + markup.
   AI must never calculate totals freely.

3. PricingTemplate defines:
   - hourlyRate
   - minHours
   - travelFee
   - markupPct

4. QuoteLine defines:
   - labor
   - material
   - fee
   Each line has qty * unitPrice = lineTotal.

5. UI should remain minimal.
   No heavy abstractions.
   Keep modifications small.

6. No overengineering.
   Avoid service layers unless required.

7. Web-first.
   Chrome is primary runtime for now.

## When implementing features
- Prefer minimal changes.
- Modify as few files as possible.
- Run flutter analyze before commit.
- Keep commits small and clear.