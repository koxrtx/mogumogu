export default {
  theme: {
    extend: {
      fontFamily: {
        sans: ['"M PLUS Rounded 1c"', 'sans-serif'], // デフォルトsansに置き換え
        rounded: ['"M PLUS Rounded 1c"', 'sans-serif'],
      },
    },
  },
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: ["daisyui"],
}