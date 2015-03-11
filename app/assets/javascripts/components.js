(function() {
  var app = angular.module('mallesti-components', ['ui.router', 'mallesti-auth']);

  // Header
  app.directive("mallestiNav", function() {
    return {
      restrict: "E",
      templateUrl: "navbar.html",
      controller: "HeaderController",
      controllerAs: "headerCtrl"
    };
  });

  app.controller("HeaderController", ['$state', 'AuthService', function($state, AuthService) {
    this.email = AuthService.currentUserEmail();

    this.logout = function() {
      // Borra el usuario y vete al login
      AuthService.destroyUser();
      $state.go("login");
    };
  }]);

  // Pagination
  app.directive("mallestiPagination", function() {
    return {
      restrict: "E",
      templateUrl: "pagination.html",
      scope: {
        ctrl: "=",
        state: "=",
        statename: "="
      }
    };
  });
})();
