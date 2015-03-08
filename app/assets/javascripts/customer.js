(function() {
  var app = angular.module("mallesti-customer", []);

  app.controller("CustomersController", ['$http', function($http) {
    var scope = this;
    scope.customers = [];

    $http.get("/customers.json").success(function(data) {
      scope.customers = data.customers
    });
  }]);
})();
