<template>
  <div class="page">
    <the-navbar/>
    <the-aside/>
    <main class="main">
      <nuxt/>
    </main>
    <the-footer/>
  </div>
</template>

<script>
import TheNavbar from "~/components/TheNavbar.vue";
import TheAside from "~/components/TheAside.vue";
import TheFooter from "~/components/TheFooter.vue";

export default {
  components: {
    TheNavbar,
    TheAside,
    TheFooter,
  }
};
</script>

<style lang="scss">
html {
  font-family: 'Roboto', sans-serif;
  font-size: 16px;
}

.page {
	width: calc(100vw - (100vw - 100%));
  height: 100vh;

  /* Grid to position the content */
  display: grid;

  grid-template-rows: 1fr 10fr 1fr;
  grid-template-columns: 3fr 9fr;

  grid-template-areas:
    "aside navbar"
    "aside main  "
    "aside footer";
}

.main {
  /* Grid to position the cell itself */
  grid-area: main;
  justify-self: stretch;

  /* Flexbox to align the content in the cell */
  display: flex;
  flex-direction: column;
  justify-content: start;
  align-items: center;

  /* FIXME: Border to highlight */
  border: 8px solid red;
}
</style>
