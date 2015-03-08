(function() {
  var app = angular.module("mallesti-customer", []);

  app.controller("CustomersController", ['$http', function($http) {
    var scope = this;
    // Para la tabla de clientes
    scope.customers = [];
    // Para el formulario de nuevo cliente
    scope.newCustomer = {};
    scope.errors = {};

    $http.get("/customers.json").success(function(data) {
      scope.customers = data.customers
    });

    // Función para eliminar un cliente
    scope.removeCustomer = function(customer) {
      if(confirm("¿Estás seguro de que quieres eliminar el cliente " + customer.name + "?")) {
        $http.delete("/customers/" + customer.id + ".json").success(function() {
          var index = scope.customers.indexOf(customer);
          scope.customers.splice(index, 1);
        });
      }
    };

    // Función para añadir un nuevo cliente
    scope.addCustomer = function() {
      $http.post("/customers.json", {customer: scope.newCustomer})
        .success(function(data) {
          scope.customers.push(data.customer);
          scope.newCustomer = {};
          scope.errors = {};
        })
        .error(function(data) {
          scope.errors = data.errors
        });
    };

    scope.disableForm = function() {
      return Object.getOwnPropertyNames(scope.newCustomer).length === 0
    };
  }]);

  // Directivas
  app.directive("customersTable", function() {
    return {
      restrict: "E",
      templateUrl: "customers-table.html"
    };
  });

  app.directive("customerForm", function() {
    return {
      restrict: "E",
      templateUrl: "customer-form.html"
    };
  });
})();
