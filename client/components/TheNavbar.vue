<template>
  <nav class="navbar">
    <h1>Navbar</h1>
  </nav>
</template>

<style>
.navbar {
  /* Grid to position the cell itself */
  grid-area: navbar;
  place-self: stretch;

  /* Flexbox to align the content in the cell */
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;

  /* FIXME: Border to highlight */
  border: 8px solid blue;
}
</style>
