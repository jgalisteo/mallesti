(function() {
  var app = angular.module("mallesti-customer", ["ui.router"]);

  app.controller("CustomersController",
    [
      '$http', '$rootScope', '$state',
      function($http, $rootScope, $state) {
        var scope = this;
        // Para la tabla de clientes
        scope.customers = [];
        // Para la paginación
        scope.totalPages = [];
        scope.currentPage = $state.params.page || 1;
        scope.nextPage = null;
        scope.prevPage = null;
        // Para el formulario de nuevo cliente
        scope.model = {};
        scope.errors = {};

        $http.get("/customers/page/" + scope.currentPage + ".json").success(function(data) {
          scope.customers = data.customers;
          scope.totalPages = $rootScope.pagesArray(data.meta.totalPages);
          scope.nextPage = data.meta.nextPage;
          scope.prevPage = data.meta.prevPage;
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
        scope.save = function() {
          $http.post("/customers.json", {customer: scope.model})
            .success(function(data) {
              scope.customers.push(data.customer);
              $state.go("main.customer", {id: data.customer.id});
            })
            .error(function(data) {
              scope.errors = data.errors
            });
        };
  }]);

  app.controller("CustomerController", ['$http', '$stateParams', function($http, $stateParams) {
    var scope = this;
    scope.customer = {};
    scope.model = {};
    scope.errors = {};
    scope.showForm = false;

    $http.get("/customers/" + $stateParams.id + ".json").success(function(data) {
      scope.customer = data.customer;
      angular.copy(data.customer, scope.model);
    });

    scope.toggleForm = function() {
      scope.showForm = !scope.showForm;
      if(!scope.showForm) {
        scope.errors = {};
        angular.copy(scope.customer, scope.model);
      }
    };

    // Función para actualizar un cliente
    scope.save = function() {
      $http.put("/customers/" + scope.customer.id + ".json", {customer: scope.model})
        .success(function() {
          angular.copy(scope.model, scope.customer);
          scope.showForm = false;
          scope.errors = {};
        })
        .error(function(data) {
          scope.errors = data.errors
        });
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
      scope: {
        ctrl: "="
      },
      templateUrl: "customer-form.html"
    };
  });

  app.directive("customerDetails", function() {
    return {
      restrict: "E",
      templateUrl: "customer-details.html"
    };
  });
})();
