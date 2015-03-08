(function() {
  var app = angular.module('mallesti-permission', ['permission', 'mallesti-auth']);

  app.run(function(Permission, AuthService) {
    Permission
      .defineRole('anonymous', function() {
        return !AuthService.currentUser();
      })
      .defineRole('member', function() {
        console.log(AuthService.currentUser());
        return AuthService.currentUser();
      });
  });
})();
