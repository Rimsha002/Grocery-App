const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          50: '#FFF7E6',
          100: '#FFE4BF',
          200: '#FFD199',
          300: '#FFBE73',
          400: '#FFAB4C',
          500: '#FF8B01', // Main primary color
          600: '#FA6F01', // Darker shade
          700: '#F55301', // Darkest shade
          800: '#CC4501',
          900: '#A33701',
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
} 