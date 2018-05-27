import Vuex from 'vuex';

export default () => {
  return new Vuex.Store({
    state: {
      token: '',
    },
    getters: {
      isAuthenticated(state) {
        return state.token !== '';
      }
    },
    mutations: {
      setToken(state, { token }) {
        state.token = token;
      }
    }
  });
}
