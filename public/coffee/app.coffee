app = angular.module 'app', ['restangular', 'ngResource', 'ui.state', 'ui.highlight', 'ui.bootstrap.buttons', 'ui.select2']

app.config ($routeProvider, $stateProvider, $urlRouterProvider, $provide, $locationProvider) ->
    $routeProvider.otherwise('/')

    $stateProvider
        .state 'home',
            url: '/'
            templateUrl: '/template/home.html'
            controller: 'HomeController'

        .state 'user',
            url: '/user'
            templateUrl: '/template/user/list.html'
            controller: 'UserController'
        .state 'user.new',
            url: '/new'
            templateUrl: '/template/user/new.html'
            controller: 'UserController'
        .state 'user.edit',
            url: '/:id/edit'
            templateUrl: '/template/user/edit.html'
            controller: 'UserController'

        .state 'item',
            url: '/item'
            templateUrl: '/template/item/list.html'
            controller: 'ItemController'
        .state 'item.new',
            url: '/new'
            templateUrl: '/template/item/new.html'
            controller: 'ItemController'

        .state 'supplier',
            url: '/supplier'
            templateUrl: '/template/supplier/list.html'
            controller: 'SupplierController'
        .state 'supplier.new',
            url: '/new'
            templateUrl: '/template/supplier/new.html'
            controller: 'SupplierController'

        .state 'customer',
            url: '/customer'
            templateUrl: '/template/customer/list.html'
            controller: 'CustomerController'
        .state 'customer.new',
            url: '/new'
            templateUrl: '/template/customer/new.html'
            controller: 'CustomerController'

        .state 'purchase_invoice',
            url: '/invoice/purchase'
            templateUrl: '/template/invoice/purchase/list.html'
            controller: 'PurchaseInvoiceController'

        .state 'sales_invoice',
            url: '/invoice/sales'
            templateUrl: '/template/invoice/sales/list.html'
            controller: 'SalesInvoiceController'

        .state 'purchase_transaction',
            url: '/transaction/purchase'
            templateUrl: '/template/transaction/purchase/new.html'
            controller: 'PurchaseTransactionController'

        .state 'sales_transaction',
            url: '/transaction/sales'
            templateUrl: '/template/transaction/sales/new.html'
            controller: 'SalesTransactionController'

        .state 'statistic',
            url: '/statistic'
            templateUrl: '/template/statistic/index.html'
            controller: 'StatisticController'


app.run ($rootScope, Restangular, AuthenticationService, SocketService, FlashService, MomentService) ->
    Restangular.setBaseUrl '/api'
    Restangular.setRestangularFields id: '_id'

    if location.pathname is '/login.html' and AuthenticationService.isLoggedIn()
        location.replace '/'

    if location.pathname isnt '/login.html' and not AuthenticationService.isLoggedIn()
        location.replace '/login.html'

    # menu
    $rootScope.isLoggedIn = AuthenticationService.isLoggedIn()
    $rootScope.currentUser = AuthenticationService.currentUser()
    $rootScope.currentRole = AuthenticationService.currentRole()
    $rootScope.logout = -> AuthenticationService.logout()
    $rootScope.newNotification = true
    $rootScope.notifications = []

    $rootScope.removeNewNotificationStatus = ->
        $rootScope.newNotification = false

    $rootScope.showNotificationStatus = ->
        $rootScope.newNotification = true

    $rootScope.clearAllNotification = ->
        $rootScope.notifications.splice(0)

    $rootScope.onlyFor = (arr) ->
        return _.contains(arr, $rootScope.currentRole)
