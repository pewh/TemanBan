app = angular.module 'app', ['ngResource', 'ui.highlight', 'ui.select2']

app.config ($locationProvider, $routeProvider) ->
    # hashbang mode
    $locationProvider.html5Mode(true)

    # URL router
    $routeProvider
        # ----------
        # HONE
        # ----------
        .when '/',
            templateUrl: '/template/home.html'
            controller: 'HomeController'
        # ----------
        # ITEM
        # ----------
        .when '/item',
            templateUrl: '/template/item/list.html'
            controller: 'ItemController'
        .when '/item/new',
            templateUrl: '/template/item/new.html'
            controller: 'ItemController'
        .when '/item/:id',
            templateUrl: '/template/item/edit.html'
            controller: 'ItemController'
        # ----------
        # SUPPLIER
        # ----------
        .when '/supplier',
            templateUrl: '/template/supplier/list.html'
            controller: 'SupplierController'
        .when '/supplier/new',
            templateUrl: '/template/supplier/new.html'
            controller: 'SupplierController'
        .when '/supplier/:id',
            templateUrl: '/template/supplier/edit.html'
            controller: 'SupplierController'
        # ----------
        # CUSTOMER
        # ----------
        .when '/customer',
            templateUrl: '/template/customer/list.html'
            controller: 'CustomerController'
        .when '/customer/new',
            templateUrl: '/template/customer/new.html'
            controller: 'CustomerController'
        .when '/customer/:id',
            templateUrl: '/template/customer/edit.html'
            controller: 'CustomerController'
        # ----------
        # REDIRECT
        # ----------
        .otherwise redirectTo: '/'


app.run ($rootScope, $location, AuthenticationService, SocketService) ->
    location.replace '/' if location.pathname == '/login.html' and AuthenticationService.isLoggedIn()

    $rootScope.$on '$routeChangeStart', (event, next, current) ->
        location.replace '/login.html' if $location.path() is '/' and not AuthenticationService.isLoggedIn()
