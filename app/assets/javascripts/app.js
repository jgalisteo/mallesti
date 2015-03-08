(function() {
  var app = angular.module("mallesti", ["ui.router", "templates", "mallesti-customer"]);

  app.config(function($urlRouterProvider, $stateProvider) {
    // Por defecto mostramos el listado de clientes
    $urlRouterProvider.otherwise("/customers");

    $stateProvider
      .state("customers", {
        url: "/customers",
        templateUrl:  "customers-list.html",
        controller:   "CustomersController",
        controllerAs: "customersCtrl"
      })
      .state("customer", {
        url: "/customers/:id",
        templateUrl:  "customer-info.html",
        controller:   "CustomerController",
        controllerAs: "customerCtrl"
      })
  });

  app.run(function($rootScope) {
    $rootScope.disableForm = function(model) {
      return Object.getOwnPropertyNames(model).length === 0;
    };
  });
})();
