const pkg = require('./package')

module.exports = {
  mode: 'spa',

  /*
  ** Headers of the page
  */
  head: {
    title: pkg.name,
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: pkg.description }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      {
        rel: "stylesheet",
        href: "https://fonts.googleapis.com/css?family=Roboto"
      }
    ]
  },

  /*
  ** Customize the progress-bar color
  */
  loading: { color: '#3F51B5' },

  /*
  ** Global CSS
  */
  css: [
    "@/node_modules/normalize.css/normalize.css"
  ],

  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
  ],

  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://github.com/nuxt-community/axios-module#usage
    "@nuxtjs/axios",
    // Doc: https://github.com/anteriovieira/nuxt-sass-resources-loader#usage
    "nuxt-sass-resources-loader"
  ],

  /*
  ** Axios module configuration
  */
  axios: {
    // See https://github.com/nuxt-community/axios-module#options
    baseURL: "http://localhost:3000"
  },

  /*
  ** Nuxt sass resource loader configuration
  */
  sassResources: [
    // See https://github.com/anteriovieira/nuxt-sass-resources-loader#usage
    "@/assets/custom.scss",
  ],

  /*
  ** Middleware configuration
  */
  router: {
    middleware: 'auth'
  },

  /*
  ** Build configuration
  */
  build: {
    /*
    ** You can extend webpack config here
    */
    extend(config, ctx) {
      // Run ESLint on save
      if (ctx.isDev && ctx.isClient) {
        config.module.rules.push({
          enforce: 'pre',
          test: /\.(js|vue)$/,
          loader: 'eslint-loader',
          exclude: /(node_modules)/
        })
      }
    }
  }
}
