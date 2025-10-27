module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: false, // DaisyUIのテーマ機能をオフ
  },
}