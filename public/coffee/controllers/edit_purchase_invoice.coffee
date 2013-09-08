app.controller 'EditPurchaseInvoiceController', ($scope, $stateParams, Restangular, SocketService, FlashService, MomentService) ->
    do init = ->
        Restangular.one('purchase_invoices', $stateParams.id).get().then (cart) ->
            $scope.cart = cart
            $scope.supplier = cart.supplier._id

    watchThreshold = 0
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()

    #invoices = Restangular.all('purchase_invoices')
    $scope.addToCart = ->
        selectedItem = (_.where $scope.items.$$v, _id: $scope.item)[0]
        getItems = _.pluck($scope.cart.details, 'item')
        getItemId = _.pluck(getItems, '_id')

        if _.contains(getItemId, selectedItem._id)
            angular.element("[data-id='#{selectedItem._id}']").focus()
        else
            $scope.cart.details.push
                qty: 1
                item: selectedItem

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
        $scope.isCartChanged = false
        watchThreshold = 1

    $scope.update = ->
        items = _.map $scope.cart.details, (cart) ->
            return {
                item: _.values(_.pick cart, '_id')[0]
                quantity: _.values(_.pick cart, 'qty')[0]
            }

        Restangular.one('purchase_invoices', $stateParams.id).get().then (result) ->
            result.created_at = $scope.cart.created_at
            result.code = $scope.cart.code
            result.supplier = $scope.supplier
            result.details = items

            result.put().then (updatedResult) ->
                console.log updatedResult
                $scope.isCartChanged = false
                watchThreshold = 3
                #SocketService.emit 'update:purchase_invoice', result
            , (err) ->
                console.log err
                if err.status == 500
                    if err.data.code == 11000
                        FlashService.error 'Kode faktur sudah ada', MomentService.currentTime()

        angular.element('#invoice_code').focus()

    $scope.$watch 'cart', (oldVal, newVal) ->
        watchThreshold++
        $scope.isCartChanged = true if watchThreshold >= 4
    , true

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
