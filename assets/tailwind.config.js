// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/word_guess_web.ex",
    "../lib/word_guess_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      },
      animation: {
        'gradient-x': 'gradient-x 10s ease infinite',
        'float': 'float 6s ease-in-out infinite',
      },
      keyframes: {
        'gradient-x': {
          '0%, 100%': {
            'background-size': '200% 200%',
            'background-position': 'left center'
          },
          '50%': {
            'background-size': '200% 200%',
            'background-position': 'right center'
          },
        },
        'float': {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("daisyui"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ],
  daisyui: {
    themes: [
      {
        wordguess: {
          "primary": "#6366f1",          // Indigo
          "secondary": "#8b5cf6",        // Violet
          "accent": "#ec4899",           // Pink
          "neutral": "#1f2937",          // Gray-800
          "base-100": "#111827",         // Gray-900
          "base-200": "#1f2937",         // Gray-800
          "base-300": "#374151",         // Gray-700
          "base-content": "#f3f4f6",     // Gray-100
          "info": "#06b6d4",             // Cyan
          "success": "#10b981",          // Emerald
          "warning": "#f59e0b",          // Amber
          "error": "#ef4444",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        cyberpunk: {
          "primary": "#ff00ff",          // Magenta
          "secondary": "#00ffff",        // Cyan
          "accent": "#ffff00",           // Yellow
          "neutral": "#1a1a2e",          // Dark blue
          "base-100": "#000000",         // Black
          "base-200": "#0f0f1a",         // Very dark blue
          "base-300": "#1a1a2e",         // Dark blue
          "base-content": "#00ffff",     // Cyan text
          "info": "#00ffff",             // Cyan
          "success": "#00ff00",          // Green
          "warning": "#ffff00",          // Yellow
          "error": "#ff0000",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        halloween: {
          "primary": "#ff7700",          // Orange
          "secondary": "#9900ff",        // Purple
          "accent": "#00ff00",           // Green
          "neutral": "#1f1200",          // Very dark brown
          "base-100": "#120b00",         // Almost black
          "base-200": "#1f1200",         // Very dark brown
          "base-300": "#2d1a00",         // Dark brown
          "base-content": "#ffb366",     // Light orange
          "info": "#00ffff",             // Cyan
          "success": "#00ff00",          // Green
          "warning": "#ffff00",          // Yellow
          "error": "#ff0000",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        forest: {
          "primary": "#2e7d32",          // Dark green
          "secondary": "#795548",        // Brown
          "accent": "#ffc107",           // Amber
          "neutral": "#1b2e1b",          // Very dark green
          "base-100": "#0d1a0d",         // Almost black green
          "base-200": "#1b2e1b",         // Very dark green
          "base-300": "#2a452a",         // Dark green
          "base-content": "#c8e6c9",     // Light green
          "info": "#29b6f6",             // Light blue
          "success": "#66bb6a",          // Green
          "warning": "#ffa726",          // Orange
          "error": "#ef5350",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        aqua: {
          "primary": "#0288d1",          // Blue
          "secondary": "#00acc1",        // Cyan
          "accent": "#ff4081",           // Pink
          "neutral": "#102027",          // Very dark blue
          "base-100": "#0a1922",         // Almost black blue
          "base-200": "#102027",         // Very dark blue
          "base-300": "#1a3747",         // Dark blue
          "base-content": "#b3e5fc",     // Light blue
          "info": "#29b6f6",             // Light blue
          "success": "#66bb6a",          // Green
          "warning": "#ffa726",          // Orange
          "error": "#ef5350",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        light: {
          "primary": "#6366f1",          // Indigo
          "secondary": "#8b5cf6",        // Violet
          "accent": "#ec4899",           // Pink
          "neutral": "#f3f4f6",          // Gray-100
          "base-100": "#ffffff",         // White
          "base-200": "#f9fafb",         // Gray-50
          "base-300": "#f3f4f6",         // Gray-100
          "base-content": "#1f2937",     // Gray-800
          "info": "#06b6d4",             // Cyan
          "success": "#10b981",          // Emerald
          "warning": "#f59e0b",          // Amber
          "error": "#ef4444",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
      {
        dark: {
          "primary": "#6366f1",          // Indigo
          "secondary": "#8b5cf6",        // Violet
          "accent": "#ec4899",           // Pink
          "neutral": "#1f2937",          // Gray-800
          "base-100": "#111827",         // Gray-900
          "base-200": "#1f2937",         // Gray-800
          "base-300": "#374151",         // Gray-700
          "base-content": "#f3f4f6",     // Gray-100
          "info": "#06b6d4",             // Cyan
          "success": "#10b981",          // Emerald
          "warning": "#f59e0b",          // Amber
          "error": "#ef4444",            // Red
          
          "--rounded-box": "0.75rem",    // border radius for cards and other large elements
          "--rounded-btn": "0.5rem",     // border radius for buttons
          "--rounded-badge": "0.375rem", // border radius for badges
          "--animation-btn": "0.3s",     // speed of button animations
          "--animation-input": "0.2s",   // speed of input animations
          "--btn-focus-scale": "0.95",   // scale transform of button when focused
          "--border-btn": "1px",         // border width of buttons
          "--tab-border": "1px",         // border width of tabs
          "--tab-radius": "0.5rem",      // border radius of tabs
        },
      },
    ],
    darkTheme: "dark",
    base: true,
    styled: true,
    utils: true,
    prefix: "",
  },
}
