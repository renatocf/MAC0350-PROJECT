<template>
  <footer class="footer">
    <h1>Footer</h1>
  </footer>
</template>

<style>
.footer {
  /* Grid to position the cell itself */
  grid-area: footer;
  place-self: stretch;

  /* Flexbox to align the content in the cell */
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;

  /* FIXME: Border to highlight */
  border: 8px solid orange;
}
</style>
