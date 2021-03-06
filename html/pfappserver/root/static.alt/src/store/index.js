import Vue from 'vue'
import Vuex from 'vuex'
// import actions from './actions'
import session from './modules/session'
import config from './modules/config'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  // actions,
  modules: {
    session,
    config
  },
  strict: debug
})
