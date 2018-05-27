export default ({ store, route, redirect, $axios }) => {
  console.log(`Processing "${route.fullPath}" in middleware/auth.js`);

  // TODO: Allow access to all main pages!
  if (route.fullPath === '/') {
    console.log(`Page with anonymous access!`);
    return;
  }

  // Use info derived by token from global vuex store
  if (!store.getters.isAuthenticated) {
    console.log(`You are not logged in! Redirecting to safe zone`);
    return redirect('/');
  }

  // TODO: Verify if user has permission to access this page
  console.log(`I have a token! ${store.state.token}`);
}
