# Playbook — PDF guides, lead magnets, workbooks for print

> No shipped PDF template was found (G-07-adjacent); this spec applies the brand system to A4/Letter documents. Values not seen in a shipped document are **[inferred]**. Builders Camp guides live on builderscamp.com/guides (salary, career paths, tools, templates, interview prep, glossary, comparisons) — PDFs are their downloadable form.

## 1. Page

- **A4 portrait (210×297mm)**, export also fits US Letter (keep content in the 210×279mm intersection). 
- Margins: 20mm top/bottom, 18mm sides [inferred]. 12-column grid, 5mm gutter.
- Running header (from page 2): wordmark black 6mm tall left · guide title 8pt muted right. Footer: page number "3 / 24" right 8pt, "builderscamp.com" left 8pt muted.

## 2. Type (print sizes)

| Element | Size / leading / weight |
|---|---|
| Cover title | 40–48pt / 1.0 / 800, tracking −0.03em, key phrase green |
| H1 (chapter) | 28pt / 1.1 / 800 |
| H2 | 18pt / 1.2 / 700 |
| H3 | 13pt / 1.3 / 700 |
| Body | 10.5pt / 1.5 / 400 (ink `#141414`) |
| Lead | 13pt / 1.4 / 300 muted |
| Eyebrow | 8pt / 600 / 0.12em uppercase green |
| Caption / source | 8pt / 400 muted |

Montserrat embedded (subset). Max 75 characters per line → use a 2-column layout only for reference sections.

## 3. Page types

1. **Cover** — full-bleed ink `#141414`, white wordmark top-left, eyebrow "FREE GUIDE" green, title white, subtitle 14pt `#A6A6A6`, optional rays motif top-right at 7% white; bottom: "Learn AI + Product at BuildersCamp.com".
2. **Contents** — numbered list with green numerals 20pt/800.
3. **Chapter opener** — white, giant faded green numeral (120pt, 12% opacity), H1, 2-line lead.
4. **Content** — H2/H3, body, callouts (`#F5F5F5`, radius 3mm, green uppercase key), checklists (green ✓), tables (header `#F5F5F5`, 0.5pt `#E6E6E6` rules, no verticals).
5. **Template / worksheet** — fields as 0.75pt `#E6E6E6` boxes with 8pt muted labels; generous write-in space.
6. **Example / case** — story box with a first name and stakes (voice rule 5), mint `#E9F6ED` background.
7. **CTA / back page** — ink background, white wordmark, "Become an AI-Native Product Builder", 3 benefit bullets (41 bootcamps, mentorship, community), green button-shaped link "Join the Membership → builderscamp.com", QR code (white tile, green border).

## 4. Colour in print

Use the same hex values (RGB PDF for screen-first lead magnets). For professional print convert with a FOGRA39 profile; green prints close to C76 M0 Y86 K0 [inferred — proof before printing]. Never print large flat ink areas in rich black above 300% total ink.

## 5. Content rules

Every guide: a one-line promise on the cover, "Who this is for" box on page 2, a template or checklist the reader can use today, sources cited (8pt), last-updated date, author with role. Exported filename: `builders-camp-<slug>-guide.pdf`.

## 6. Accessibility

Tagged PDF, reading order set, alt text on images/diagrams, real text (no text as images), document title + language metadata, link text that makes sense out of context.
