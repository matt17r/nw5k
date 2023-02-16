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
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'nw5k-eggplant': {
          900: '#301F29',
          800: '#523546',
          700: '#704A60',
          600: '#8C5F7A',
          500: '#A67491',
          400: '#BD8AA8',
          300: '#D1A1BD',
          200: '#E3BAD2',
          100: '#F2D8E7',
           50: '#FFF5FB',
        },
        'nw5k-teal': '#28525b',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ]
}
