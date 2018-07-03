import Vuex from 'vuex';
import VuexPersistence from 'vuex-persist';

const vuexLocal = new VuexPersistence({
  storage: window.localStorage,
})

export default () => {
  return new Vuex.Store({
    plugins: [vuexLocal.plugin],

    state: {
      email: '',
      token: '',
    },

    getters: {
      isAuthenticated(state) {
        return state.token !== '';
      }
    },

    mutations: {
      setEmail(state, { email }) {
        state.email = email;
      },

      setToken(state, { token }) {
        state.token = token;
      }
    }
  });
}
