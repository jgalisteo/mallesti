(function() {
  var app = angular.module("mallesti", [
      "ui.router", "permission", "templates", "mallesti-auth", "mallesti-permission",
      "mallesti-customer"
  ]);

  // Esto pasa el token y el email en cada petición que hagamos a la API
  app.factory("httpInterceptor", ['AuthService', function(AuthService) {
    return {
      request: function(config) {
        config.headers['X-User-Email'] = AuthService.currentUserEmail();
        config.headers['X-User-Token'] = AuthService.currentUserToken();
        return config;
      }
    };
  }])

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
            redirectTo: "customers"
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
            redirectTo: "customers"
          }
        }
      })
      .state("customers", {
        url: "/customers",
        templateUrl:  "customers-list.html",
        controller:   "CustomersController",
        controllerAs: "customersCtrl",
        data: {
          permissions: {
            only: ['member'],
            redirectTo: "login"
          }
        }
      })
      .state("customer", {
        url: "/customers/:id",
        templateUrl:  "customer-info.html",
        controller:   "CustomerController",
        controllerAs: "customerCtrl",
        data: {
          permissions: {
            only: ['member'],
            redirectTo: "login"
          }
        }
      })
  });

  app.run(function($rootScope) {
    $rootScope.disableForm = function(model) {
      return Object.getOwnPropertyNames(model).length === 0;
    };
  });
})();
