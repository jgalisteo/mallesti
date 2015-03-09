(function() {
  var app = angular.module("mallesti", [
      "ui.router", "permission", "templates", "mallesti-auth", "mallesti-permission",
      "mallesti-customer"
  ]);

  // Esto pasa el token y el email en cada petición que hagamos a la API
  app.factory("httpInterceptor",
    ['$q', '$injector', '$timeout','AuthService',
      function($q, $injector, $timeout, AuthService) {
        var $state;

        $timeout(function(){
          $state = $injector.get("$state");
        });

        return {
          request: function(config) {
            config.headers['X-User-Email'] = AuthService.currentUserEmail();
            config.headers['X-User-Token'] = AuthService.currentUserToken();
            return config;
          },
          responseError: function(rejection) {
            if(rejection.status === 401) {
              AuthService.destroyUser();
              $state.go("login");
            }
            return $q.reject(rejection);
          }
        };
      }
  ])

  app.config(function($urlRouterProvider, $stateProvider, $httpProvider) {
    // Configuramos todas las peticiones para pasar el token de usuario
    $httpProvider.interceptors.push("httpInterceptor")

    // Por defecto mostramos el listado de clientes
    $urlRouterProvider.otherwise("/customers");

    $stateProvider
      .state("login", {
        url: "/login",
        templateUrl: "login.html",
        controller: "LoginController",
        controllerAs: "loginCtrl",
        data: {
          permissions: {
            only: ['anonymous'],
            redirectTo: "main.customers"
          }
        }
      })
      .state("sign_up", {
        url: "/sign_up",
        templateUrl: "sign_up.html",
        controller: "SignUpController",
        controllerAs: "signUpCtrl",
        data: {
          permissions: {
            only: ['anonymous'],
            redirectTo: "main.customers"
          }
        }
      })
      .state("main", {
        url: "/",
        templateUrl: "main.html",
        data: {
          permissions: {
            only: ['member'],
            redirectTo: "login"
          }
        }
      })
      .state("main.customers", {
        url: "customers",
        templateUrl:  "customers-list.html",
        controller:   "CustomersController",
        controllerAs: "customersCtrl",
      })
      .state("main.customer", {
        url: "customers/:id",
        templateUrl:  "customer-info.html",
        controller:   "CustomerController",
        controllerAs: "customerCtrl",
      })
  });

  app.run(function($rootScope) {
    $rootScope.disableForm = function(model) {
      return Object.getOwnPropertyNames(model).length === 0;
    };
  });

  app.directive("mallestiNav", function() {
    return {
      restrict: "E",
      templateUrl: "navbar.html",
      controller: "LoginController",
      controllerAs: "loginCtrl"
    };
  });
})();
