// tailwind.config.cjs
const daisyuiThemes = require("daisyui/src/theming/themes");

module.exports = {
  content: [
    "./app/views/**/*.{html,erb,haml,slim}",
    "./app/javascript/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        nord: {
          ...daisyuiThemes["nord"],
        },
      },
    ],
  },
};