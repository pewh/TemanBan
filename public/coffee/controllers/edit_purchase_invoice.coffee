app.controller 'EditPurchaseInvoiceController', ($scope, $state, $stateParams, $location, Restangular, SocketService, FlashService, MomentService) ->
    do init = ->
        Restangular.one('purchase_invoices', $stateParams.id).get().then (cart) ->
            $scope.cart = cart
            $scope.supplier = cart.supplier._id
            $scope.isCartChanged = false

    watchThreshold = 0
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()

    #invoices = Restangular.all('purchase_invoices')

    $scope.calculateTotalPrice = (details) ->
        stock = _.pluck details, 'quantity'
        purchase_price = _.pluck( _.pluck(details, 'item'), 'purchase_price')
        zipped = _.zip(stock, purchase_price)
        sumZipped = _.map zipped, (z) -> z[0] * z[1]

        _.reduce sumZipped, (c, v) -> c + v

    $scope.calculateTotalQty = (details) ->
        stock = _.pluck details, 'quantity'

        _.reduce stock, (c, v) -> c + v

    $scope.filteredItems = ->
        _.where($scope.items.$$v, { suppliers: {_id: $scope.supplier } })

    $scope.clear = (index) ->
        $scope.cart.details.splice(index, 1)

    $scope.clearAll = (index) ->
        $scope.cart.details.splice(0)

    $scope.reset = ->
        init()
        watchThreshold = 1

    $scope.$watch 'cart', (oldVal, newVal) ->
        watchThreshold++
        $scope.isCartChanged = true if watchThreshold >= 4
    , true

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
