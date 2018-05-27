<template>
  <div class=".aside__login">
    <p>Login</p>
    <input type="email" v-model="email"/>
    <input type="password" v-model="password"/>

    <button type="submit" @click="login" @submit.prevent>
      Login
    </button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: ''
    }
  },

  methods: {
    async login() {
      // TODO: Implement login logic here
      // TIP: Method is `async` because it should use "await this.$axios"
      console.log(`User: ${this.email} ${this.password}`);

      // Save token at global vuex store to be used by auth middleware
      this.$store.commit("setToken", { token: "" });
    }
  }
}
</script>

<style lang="scss">
.aside__login {
}
</style>
