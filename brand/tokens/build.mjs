#!/usr/bin/env node
// Generates tokens.css, tailwind-preset.cjs and contrast.md from tokens.json.
// Usage: node brand/tokens/build.mjs   (no dependencies)
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const dir = dirname(fileURLToPath(import.meta.url));
const t = JSON.parse(readFileSync(join(dir, "tokens.json"), "utf8"));
const v = (x) => (x && typeof x === "object" && "$value" in x ? x.$value : x);
const entries = (o) => Object.entries(o).filter(([k]) => !k.startsWith("$"));

// ---------- colour helpers ----------
const hexToRgb = (h) => {
  const n = h.replace("#", "");
  return [0, 2, 4].map((i) => parseInt(n.slice(i, i + 2), 16));
};
const rgbToHsl = ([r, g, b]) => {
  r /= 255; g /= 255; b /= 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  let h = 0, s = 0;
  const l = (max + min) / 2;
  if (max !== min) {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    h = max === r ? (g - b) / d + (g < b ? 6 : 0) : max === g ? (b - r) / d + 2 : (r - g) / d + 4;
    h *= 60;
  }
  const f = (x) => Math.round(x * 10) / 10;
  return `${f(h)} ${f(s * 100)}% ${f(l * 100)}%`;
};
const hslTriplet = (val) => (val.startsWith("#") ? rgbToHsl(hexToRgb(val)) : null);
const lum = (h) => {
  const c = hexToRgb(h).map((x) => {
    x /= 255;
    return x <= 0.03928 ? x / 12.92 : ((x + 0.055) / 1.055) ** 2.4;
  });
  return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
};
const contrast = (a, b) => {
  const [x, y] = [lum(a), lum(b)].sort((p, q) => q - p);
  return (x + 0.05) / (y + 0.05);
};

// ---------- tokens.css ----------
const header = `/* Builders Camp design tokens — GENERATED from tokens.json by build.mjs. Do not edit. v${t.$meta.version} */\n`;
let css = header;
css += `@import url('${v(t.font.googleFontsUrl)}');\n\n`;

const themeBlock = (theme) =>
  entries(t.color[theme])
    .map(([k, tok]) => {
      const val = v(tok);
      const hsl = hslTriplet(val);
      // shadcn convention: --name holds an HSL triplet so `hsl(var(--name) / <alpha>)` works.
      return hsl ? `  --${k}: ${hsl};\n  --bc-${k}: ${val};` : `  --bc-${k}: ${val};`;
    })
    .join("\n");

css += `:root {\n`;
css += `  /* semantic (light) */\n${themeBlock("light")}\n`;
css += `  --radius: ${v(t.radius.lg)};\n\n  /* brand */\n`;
for (const [k, tok] of entries(t.color.brand)) css += `  --bc-brand-${k}: ${v(tok)};\n`;
css += `\n  /* neutral */\n`;
for (const [k, tok] of entries(t.color.neutral)) css += `  --bc-neutral-${k}: ${v(tok)};\n`;
css += `\n  /* feedback */\n`;
for (const [k, tok] of entries(t.color.feedback)) css += `  --bc-${k}: ${v(tok)};\n`;
css += `\n  /* category (tracks/programmes) */\n`;
for (const [k, tok] of entries(t.color.category)) {
  css += `  --bc-cat-${k}: ${v(tok)};\n`;
  if (tok.solid) css += `  --bc-cat-${k}-solid: ${tok.solid};\n`;
}
css += `\n  /* deck & workbook neutrals (slides, workbooks, artifacts) */\n`;
for (const [k, tok] of entries(t.color.deck)) css += `  --bc-deck-${k}: ${v(tok)};\n`;
css += `\n  /* type */\n`;
for (const [k, tok] of entries(t.font.family)) css += `  --bc-font-${k}: ${v(tok)};\n`;
for (const [k, s] of entries(t.type)) {
  css += `  --bc-text-${k}: ${s.size}px;\n  --bc-leading-${k}: ${s.lineHeight};\n  --bc-weight-${k}: ${s.weight};\n  --bc-tracking-${k}: ${s.tracking};\n`;
}
css += `\n  /* space / radius / shadow / layout / motion */\n`;
for (const [k, tok] of entries(t.space)) css += `  --bc-space-${k}: ${v(tok)}px;\n`;
for (const [k, tok] of entries(t.radius)) css += `  --bc-radius-${k}: ${v(tok)};\n`;
for (const [k, tok] of entries(t.shadow)) css += `  --bc-shadow-${k}: ${v(tok)};\n`;
for (const [k, tok] of entries(t.layout)) if (k !== "breakpoints") css += `  --bc-${k}: ${v(tok)};\n`;
for (const [k, tok] of entries(t.motion.duration)) css += `  --bc-duration-${k}: ${v(tok)};\n`;
for (const [k, tok] of entries(t.motion.easing)) css += `  --bc-ease-${k}: ${v(tok)};\n`;
for (const [k, tok] of entries(t.motion.distance)) css += `  --bc-distance-${k}: ${v(tok)};\n`;
css += `}\n\n`;
const dark = themeBlock("dark");
css += `.dark, [data-theme="dark"] {\n${dark}\n}\n\n`;
css += `@media (prefers-color-scheme: dark) {\n  :root:not([data-theme="light"]):not(.light)[data-bc-auto-dark] {\n${dark.replace(/^/gm, "  ")}\n  }\n}\n\n`;
css += `@media (max-width: 767px) {\n  :root {\n`;
for (const [k, s] of entries(t.type)) if (s.sizeMobile) css += `    --bc-text-${k}: ${s.sizeMobile}px;\n`;
for (const [k, s] of entries(t.type)) if (s.lineHeightMobile) css += `    --bc-leading-${k}: ${s.lineHeightMobile};\n`;
css += `  }\n}\n\n@media (prefers-reduced-motion: reduce) {\n  :root { --bc-duration-fast: 0ms; --bc-duration-base: 0ms; --bc-duration-slow: 0ms; --bc-duration-reveal: 0ms; }\n}\n`;
writeFileSync(join(dir, "tokens.css"), css);

// ---------- tailwind preset (v3; works as reference for v4 @theme) ----------
const semantic = {};
for (const [k] of entries(t.color.light)) {
  if (hslTriplet(v(t.color.light[k]))) semantic[k] = `hsl(var(--${k}) / <alpha-value>)`;
}
const nest = (o) => {
  const out = {};
  for (const [k, val] of Object.entries(o)) {
    const [base, ...rest] = k.split("-");
    if (rest.length && ["foreground", "hover", "tint"].includes(rest.join("-"))) {
      out[base] = typeof out[base] === "object" ? out[base] : out[base] ? { DEFAULT: out[base] } : {};
      out[base][rest.join("-")] = val;
    } else if (typeof out[k] === "object") out[k].DEFAULT = val;
    else out[k] = val;
  }
  return out;
};
const preset = {
  darkMode: ["class"],
  theme: {
    container: { center: true, padding: "1.5rem", screens: { "2xl": v(t.layout["container-max"]) } },
    extend: {
      colors: {
        ...nest(semantic),
        "accent-tint": "var(--bc-accent-tint)",
        brand: Object.fromEntries(entries(t.color.brand).map(([k, tok]) => [k, v(tok)])),
        neutral: Object.fromEntries(entries(t.color.neutral).map(([k, tok]) => [k, v(tok)])),
        feedback: Object.fromEntries(entries(t.color.feedback).map(([k, tok]) => [k, v(tok)])),
        deck: Object.fromEntries(entries(t.color.deck).map(([k, tok]) => [k, v(tok)])),
        track: Object.fromEntries(entries(t.color.category).map(([k, tok]) => [k, tok.solid || v(tok)])),
      },
      backgroundImage: Object.fromEntries(
        entries(t.color.category).filter(([, tok]) => v(tok).includes("gradient")).map(([k, tok]) => [`gradient-track-${k}`, v(tok)])
      ),
      fontFamily: {
        sans: ["Montserrat", "system-ui", "-apple-system", "Segoe UI", "sans-serif"],
        display: ["Montserrat", "system-ui", "sans-serif"],
        brush: ["Nanum Brush Script", "cursive"],
        mono: ["ui-monospace", "SF Mono", "JetBrains Mono", "Menlo", "Consolas", "monospace"],
      },
      fontSize: Object.fromEntries(
        entries(t.type).map(([k, s]) => [
          `bc-${k}`,
          [`${s.size / 16}rem`, { lineHeight: String(s.lineHeight), letterSpacing: s.tracking, fontWeight: String(s.weight) }],
        ])
      ),
      borderRadius: {
        sm: v(t.radius.sm), md: v(t.radius.md), lg: "var(--radius)",
        xl: v(t.radius.xl), "2xl": v(t.radius["2xl"]), "3xl": v(t.radius["3xl"]), brutal: v(t.radius.brutal), deck: v(t.radius["deck-card"]),
      },
      boxShadow: Object.fromEntries(entries(t.shadow).map(([k, tok]) => [`bc-${k}`, v(tok)])),
      maxWidth: { container: v(t.layout["container-max"]), content: v(t.layout["content-max"]), reading: v(t.layout["reading-max"]), copy: v(t.layout["copy-max"]) },
      transitionDuration: Object.fromEntries(entries(t.motion.duration).map(([k, tok]) => [`bc-${k}`, v(tok)])),
      transitionTimingFunction: Object.fromEntries(entries(t.motion.easing).map(([k, tok]) => [`bc-${k}`, v(tok)])),
      keyframes: {
        "bc-fade-up": { from: { opacity: "0", transform: `translateY(${v(t.motion.distance["reveal-y"])})` }, to: { opacity: "1", transform: "translateY(0)" } },
        "accordion-down": { from: { height: "0" }, to: { height: "var(--radix-accordion-content-height)" } },
        "accordion-up": { from: { height: "var(--radix-accordion-content-height)" }, to: { height: "0" } },
      },
      animation: {
        "bc-fade-up": `bc-fade-up ${v(t.motion.duration.reveal)} ${v(t.motion.easing.out)} forwards`,
        "accordion-down": `accordion-down ${v(t.motion.duration.base)} ease-out`,
        "accordion-up": `accordion-up ${v(t.motion.duration.base)} ease-out`,
      },
    },
  },
};
writeFileSync(
  join(dir, "tailwind-preset.cjs"),
  `/* Builders Camp Tailwind preset — GENERATED from tokens.json by build.mjs. Do not edit. v${t.$meta.version}\n` +
    ` * Usage (tailwind.config): presets: [require("<path>/brand/tokens/tailwind-preset.cjs")]\n` +
    ` * Requires tokens.css to be imported once (it defines the CSS variables). */\n` +
    `module.exports = ${JSON.stringify(preset, null, 2)};\n`
);

// ---------- contrast report ----------
const pairs = [
  ["ink #141414 on white", "#141414", "#FFFFFF"],
  ["muted #737373 on white", "#737373", "#FFFFFF"],
  ["muted #737373 on neutral-100 #F5F5F5", "#737373", "#F5F5F5"],
  ["ink on neutral-100", "#141414", "#F5F5F5"],
  ["white on green #27A54D", "#FFFFFF", "#27A54D"],
  ["white on green-strong #1D7F41", "#FFFFFF", "#1D7F41"],
  ["green-strong #1D7F41 on white (small text/links)", "#1D7F41", "#FFFFFF"],
  ["deck muted #6B6B6B on white", "#6B6B6B", "#FFFFFF"],
  ["deck muted #6B6B6B on deck card #F4F4F4", "#6B6B6B", "#F4F4F4"],
  ["deck muted-on-dark #8A8A8A on black", "#8A8A8A", "#000000"],
  ["deck body #0D0D0D on mint #E9F6ED", "#0D0D0D", "#E9F6ED"],
  ["green #27A54D on black (slide eyebrows)", "#27A54D", "#000000"],
  ["diagram edge #8A8A8A on white (non-text, needs 3:1)", "#8A8A8A", "#FFFFFF"],
  ["green #27A54D on white (text/link)", "#27A54D", "#FFFFFF"],
  ["ink on green", "#141414", "#27A54D"],
  ["white on coral #FF7A59", "#FFFFFF", "#FF7A59"],
  ["ink on coral", "#141414", "#FF7A59"],
  ["white on blue #5271FF", "#FFFFFF", "#5271FF"],
  ["ink on lime #C2FF33", "#141414", "#C2FF33"],
  ["warning-ink #78350F on warning-bg #FEF3C7", "#78350F", "#FEF3C7"],
  ["success #16A34A on success-bg #F0FDF4", "#16A34A", "#F0FDF4"],
  ["error-text #DC2626 on error-bg #FEF2F2", "#DC2626", "#FEF2F2"],
  ["dark: fg #FAFAFA on bg #101318", "#FAFAFA", "#101318"],
  ["dark: muted #A6A6A6 on bg #101318", "#A6A6A6", "#101318"],
  ["dark: green #27A54D on bg #101318", "#27A54D", "#101318"],
  ["white on ink #141414", "#FFFFFF", "#141414"],
];
const grade = (r) => (r >= 7 ? "AAA" : r >= 4.5 ? "AA" : r >= 3 ? "AA large only (≥24px, or ≥18.66px bold)" : "FAIL — decorative only");
let md = `# Contrast report (generated by build.mjs — do not edit)\n\nWCAG 2.x contrast ratios for the brand's real pairings.\n\n| Pair | Ratio | Grade |\n|---|---|---|\n`;
for (const [n, a, b] of pairs) {
  const r = contrast(a, b);
  md += `| ${n} | ${r.toFixed(2)}:1 | ${grade(r)} |\n`;
}
writeFileSync(join(dir, "contrast.md"), md);
console.log("built tokens.css, tailwind-preset.cjs, contrast.md");
