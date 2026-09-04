# Builders Camp design system notes

Confirmed by cross-checking real product screenshots (Mentors page, Masterclass page, MBA landing page) against an earlier codebase-derived summary, which turned out to be partly wrong. Trust this file over any fresh "here's our design system" summary someone pastes in unless it's newly verified against a live screenshot.

## Color
- The palette is black, white, and green (`#26A355`) only. Confirmed directly by Tadeu (Aug 19): there is no lime and no navy anywhere in the platform.
- A lime (`#DCFF00`) / navy (`#1F2B45`) pairing shows up in codebase-derived design-system summaries — this is wrong, not just unconfirmed. Don't use it under any circumstances, even if a fresh "design system" summary suggests it again.
- Neutrals: white background, near-black text.

## Typography
- Two fonts are in play, not one:
  - **Montserrat** (weights 300–800) for everything functional — navigation, body copy, card content, standard headings. This is what the template in this skill uses throughout, including the headline.
  - A separate **rounded/bold display font** (chunky terminals, single-story "a") is used for the "BUILDERS CAMP" logo/wordmark and for big hero headlines on marketing landing pages. Its exact name is unconfirmed as of this writing. If you get a chance to inspect it (dev tools on a real headline or the logo), update this file and swap the `h1` font-family in `assets/template.html` — that would make the headline match the brand's marketing pages more closely than the current Montserrat-only approach.

## Other visual notes
- Border radius: consistently rounded but not overly (roughly 10-14px, not full-round except on pill badges/buttons).
- Some marketing hero sections use a structural top bar: full-width gray strip with a green accent stripe underneath. Not part of the current template — worth considering if this skill is extended to a different aspect ratio or placement (e.g. a page hero rather than a social card).
- Badge/tag pattern on real marketing pages is a soft mint-green pill with a small dot and dark text — softer than the solid black badge this skill currently uses. The solid black badge was a deliberate choice for social-card contrast (small file, viewed at thumbnail size in a feed) rather than an attempt to replicate the mint badge exactly — worth a second look if a future review says the black badge feels off-brand.
