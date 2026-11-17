/* Builders Camp Tailwind preset — GENERATED from tokens.json by build.mjs. Do not edit. v1.0.0
 * Usage (tailwind.config): presets: [require("<path>/brand/tokens/tailwind-preset.cjs")]
 * Requires tokens.css to be imported once (it defines the CSS variables). */
module.exports = {
  "darkMode": [
    "class"
  ],
  "theme": {
    "container": {
      "center": true,
      "padding": "1.5rem",
      "screens": {
        "2xl": "1200px"
      }
    },
    "extend": {
      "colors": {
        "background": "hsl(var(--background) / <alpha-value>)",
        "foreground": "hsl(var(--foreground) / <alpha-value>)",
        "card": {
          "DEFAULT": "hsl(var(--card) / <alpha-value>)",
          "foreground": "hsl(var(--card-foreground) / <alpha-value>)"
        },
        "popover": {
          "DEFAULT": "hsl(var(--popover) / <alpha-value>)",
          "foreground": "hsl(var(--popover-foreground) / <alpha-value>)"
        },
        "primary": {
          "DEFAULT": "hsl(var(--primary) / <alpha-value>)",
          "foreground": "hsl(var(--primary-foreground) / <alpha-value>)"
        },
        "secondary": {
          "DEFAULT": "hsl(var(--secondary) / <alpha-value>)",
          "foreground": "hsl(var(--secondary-foreground) / <alpha-value>)"
        },
        "muted": {
          "DEFAULT": "hsl(var(--muted) / <alpha-value>)",
          "foreground": "hsl(var(--muted-foreground) / <alpha-value>)"
        },
        "accent": {
          "DEFAULT": "hsl(var(--accent) / <alpha-value>)",
          "foreground": "hsl(var(--accent-foreground) / <alpha-value>)",
          "hover": "hsl(var(--accent-hover) / <alpha-value>)"
        },
        "destructive": {
          "DEFAULT": "hsl(var(--destructive) / <alpha-value>)",
          "foreground": "hsl(var(--destructive-foreground) / <alpha-value>)"
        },
        "border": "hsl(var(--border) / <alpha-value>)",
        "input": "hsl(var(--input) / <alpha-value>)",
        "ring": "hsl(var(--ring) / <alpha-value>)",
        "accent-hover": "var(--bc-accent-hover)",
        "accent-tint": "var(--bc-accent-tint)",
        "brand": {
          "ink": "#141414",
          "white": "#FFFFFF",
          "green": "#27A54D",
          "coral": "#FF7A59",
          "green-strong": "#1F843D",
          "blue": "#5271FF",
          "lime": "#C2FF33",
          "navy": "#1F242E"
        },
        "neutral": {
          "0": "#FFFFFF",
          "50": "#FAFAFA",
          "100": "#F5F5F5",
          "200": "#E6E6E6",
          "400": "#A6A6A6",
          "500": "#737373",
          "700": "#404040",
          "900": "#141414"
        },
        "feedback": {
          "success": "#16A34A",
          "success-bg": "#F0FDF4",
          "success-badge": "#DCFCE7",
          "warning": "#F59E0B",
          "warning-text": "#D97706",
          "warning-bg": "#FEF3C7",
          "warning-ink": "#78350F",
          "error": "#EF4444",
          "error-text": "#DC2626",
          "error-bg": "#FEF2F2",
          "star": "#FBBF24"
        },
        "track": {
          "vibe-coding": "#EA580C",
          "ai-product": "#3B82F6",
          "leadership": "#4B5563",
          "discovery": "#22C55E",
          "purple": "#8B5CF6",
          "emerald": "#10B981"
        }
      },
      "backgroundImage": {
        "track-vibe-coding": "linear-gradient(to right, #C2410C, #EA580C)",
        "track-ai-product": "linear-gradient(to right, #2563EB, #3B82F6)",
        "track-leadership": "linear-gradient(to right, #374151, #4B5563)",
        "track-discovery": "linear-gradient(to right, #16A34A, #22C55E)"
      },
      "fontFamily": {
        "sans": [
          "Montserrat",
          "system-ui",
          "-apple-system",
          "Segoe UI",
          "sans-serif"
        ],
        "display": [
          "Montserrat",
          "system-ui",
          "sans-serif"
        ],
        "brush": [
          "Nanum Brush Script",
          "cursive"
        ],
        "mono": [
          "ui-monospace",
          "SF Mono",
          "JetBrains Mono",
          "Menlo",
          "Consolas",
          "monospace"
        ]
      },
      "fontSize": {
        "bc-display": [
          "8rem",
          {
            "lineHeight": "1",
            "letterSpacing": "-0.05em",
            "fontWeight": "800"
          }
        ],
        "bc-h1": [
          "3.75rem",
          {
            "lineHeight": "1",
            "letterSpacing": "-0.025em",
            "fontWeight": "800"
          }
        ],
        "bc-h2": [
          "2.25rem",
          {
            "lineHeight": "1.111",
            "letterSpacing": "-0.025em",
            "fontWeight": "700"
          }
        ],
        "bc-h3": [
          "1.25rem",
          {
            "lineHeight": "1.4",
            "letterSpacing": "-0.025em",
            "fontWeight": "700"
          }
        ],
        "bc-h4": [
          "1.125rem",
          {
            "lineHeight": "1.556",
            "letterSpacing": "-0.025em",
            "fontWeight": "700"
          }
        ],
        "bc-lead": [
          "1.25rem",
          {
            "lineHeight": "1.4",
            "letterSpacing": "0",
            "fontWeight": "300"
          }
        ],
        "bc-body": [
          "1rem",
          {
            "lineHeight": "1.5",
            "letterSpacing": "0",
            "fontWeight": "400"
          }
        ],
        "bc-small": [
          "0.875rem",
          {
            "lineHeight": "1.429",
            "letterSpacing": "0",
            "fontWeight": "400"
          }
        ],
        "bc-caption": [
          "0.75rem",
          {
            "lineHeight": "1.333",
            "letterSpacing": "0",
            "fontWeight": "400"
          }
        ],
        "bc-eyebrow": [
          "0.75rem",
          {
            "lineHeight": "1.333",
            "letterSpacing": "0.05em",
            "fontWeight": "600"
          }
        ],
        "bc-button": [
          "0.875rem",
          {
            "lineHeight": "1.429",
            "letterSpacing": "0",
            "fontWeight": "600"
          }
        ]
      },
      "borderRadius": {
        "sm": "6px",
        "md": "8px",
        "lg": "var(--radius)",
        "xl": "12px",
        "2xl": "16px",
        "3xl": "24px"
      },
      "boxShadow": {
        "bc-sm": "0 1px 2px 0 rgb(0 0 0 / 0.05)",
        "bc-md": "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)",
        "bc-lg": "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)",
        "bc-xl": "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)",
        "bc-sticky-bar": "0 -4px 20px 0 rgb(0 0 0 / 0.08)"
      },
      "maxWidth": {
        "container": "1200px",
        "content": "1024px",
        "reading": "768px",
        "copy": "512px"
      },
      "transitionDuration": {
        "bc-instant": "100ms",
        "bc-fast": "150ms",
        "bc-base": "200ms",
        "bc-slow": "500ms",
        "bc-reveal": "600ms"
      },
      "transitionTimingFunction": {
        "bc-standard": "cubic-bezier(0.4, 0, 0.2, 1)",
        "bc-out": "cubic-bezier(0, 0, 0.2, 1)",
        "bc-emphasis": "cubic-bezier(0.16, 1, 0.3, 1)"
      },
      "keyframes": {
        "bc-fade-up": {
          "from": {
            "opacity": "0",
            "transform": "translateY(20px)"
          },
          "to": {
            "opacity": "1",
            "transform": "translateY(0)"
          }
        },
        "accordion-down": {
          "from": {
            "height": "0"
          },
          "to": {
            "height": "var(--radix-accordion-content-height)"
          }
        },
        "accordion-up": {
          "from": {
            "height": "var(--radix-accordion-content-height)"
          },
          "to": {
            "height": "0"
          }
        }
      },
      "animation": {
        "bc-fade-up": "bc-fade-up 600ms cubic-bezier(0, 0, 0.2, 1) forwards",
        "accordion-down": "accordion-down 200ms ease-out",
        "accordion-up": "accordion-up 200ms ease-out"
      }
    }
  }
};
