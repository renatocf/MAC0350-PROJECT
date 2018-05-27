<template>
  <div class="planejamento">
    <h1>Planejamento</h1>

    <!-- Example of Vue using some data -->
    <ul v-for="disciplina of disciplinas" :key="disciplina.id_disciplina">
      <li>{{ disciplina.codigo_disciplina }}</li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      disciplinas: []
    };
  },

  // Initialize elements in 'data' before rendering page.
  // More info at: https://nuxtjs.org/api/
  async asyncData({ app }) {
    return {
      disciplinas: await app.$axios.$get("/disciplinas")
    }
  }
}
</script>

<style lang="scss">
.planejamento {
}
</style>
