app = angular.module 'app', ['ngResource', 'ui.highlight']

app.config ($interpolateProvider, $locationProvider, $routeProvider) ->
    # change interpolate behavior
    $interpolateProvider.startSymbol('[[').endSymbol(']]')

    # hashbang mode
    $locationProvider.html5Mode(false).hashPrefix('!')

    # URL router
    $routeProvider
        # ----------
        # LOGIN
        # ----------
        .when '/login',
            templateUrl: '/template/login.html'
            controller: 'LoginController'
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
        # REDIRECT
        # ----------
        .otherwise redirectTo: '/'


app.run ($rootScope, $location, AuthenticationService) ->
    routesThatRequireAuth = ['/', '/item']
    $rootScope.$on '$routeChangeStart', (event, next, current) ->
        if _.contains(routesThatRequireAuth, $location.path()) and not AuthenticationService.isLoggedIn()
            $location.path '/login'


app.factory 'SessionService', ->
    get: (key) -> sessionStorage.getItem key
    set: (key, val) -> sessionStorage.setItem key, val
    unset: (key) -> sessionStorage.removeItem key


app.factory 'AuthenticationService', ($location, $http, SessionService) ->
    login: (credentials) ->
        $http.post('/auth/login', credentials).success -> SessionService.set 'authenticated', true
    logout: ->
        $http.get('/auth/logout').success -> SessionService.unset 'authenticated'
    isLoggedIn: ->
        SessionService.get 'authenticated'


app.filter 'rupiah', -> (string) ->
    if string
        return accounting.formatMoney(parseInt(string), 'Rp ', '.', '.') + ',-'
    else
        return '-'


app.directive 'activeLink', ($location) ->
    restrict: 'A'
    link: (scope, element, attribute, controller) ->
        path = element.children('a').attr('href')[3..]
        scope.location = $location

        scope.$watch 'location.path()', (newPath) ->
            newPath = '/' + newPath.split('/')[1]

            if path is newPath
                element.addClass 'active'
            else
                element.removeClass 'active'


app.controller 'MenuController', ($scope, $location, AuthenticationService) ->
    $scope.isLoggedIn = ->
        AuthenticationService.isLoggedIn()

    $scope.logout = ->
        AuthenticationService.logout().success ->
            $location.path '/login'


app.controller 'LoginController', ($scope, $location, AuthenticationService) ->
    $scope.credentials =
        username: ''
        password: ''

    $scope.login = ->
        AuthenticationService.login($scope.credentials).success ->
            $location.path '/home'
        .error (message) ->
            $scope.flash = message.flash
