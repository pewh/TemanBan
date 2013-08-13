app = angular.module 'app', ['ngResource', 'ui.highlight', 'app.services']

services = angular.module 'app.services', []

services.factory 'SocketService', ($rootScope) ->
    socket = io.connect()
    return {
        on: (eventName, callback) ->
            socket.on eventName, ->
                args = arguments
                $rootScope.$apply -> callback.apply(socket, args)
        emit: (eventName, data, callback) ->
            socket.emit eventName, data, ->
                args = arguments
                $rootScope.$apply -> callback.apply(socket, args) if callback
    }


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
            templateUrl: (params) -> '/template/item/edit.html'
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
            templateUrl: (params) -> '/template/supplier/edit.html'
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
            templateUrl: (params) -> '/template/customer/edit.html'
            controller: 'CustomerController'
        # ----------
        # REDIRECT
        # ----------
        .otherwise redirectTo: '/'


app.run ($rootScope, $location, AuthenticationService, SocketService) ->
    routesThatRequireAuth = ['/', '/item']
    location.replace '/' if location.pathname == '/login.html' and AuthenticationService.isLoggedIn()

    $rootScope.$on '$routeChangeStart', (event, next, current) ->
        location.replace '/login.html' if _.contains(routesThatRequireAuth, $location.path()) and not AuthenticationService.isLoggedIn()
