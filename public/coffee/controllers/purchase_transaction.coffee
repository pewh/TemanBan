app.controller 'PurchaseTransactionController', ($scope, Restangular, FlashService, SocketService, MomentService) ->
    $scope.cart = []
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()

    setInterval ->
        $scope.$apply ->
            $scope.datetime = (new Date()).toISOString()
    , 1000

    clearCart = ->
        $scope.code = ''
        $scope.supplier = ''
        $scope.cart = []

    SocketService.on 'create:purchase_invoice', (data) ->
        message = """
                  Faktur pembelian #{data.code} telah ditambah <br />
                  Klik <a href="/#/invoice/purchase">disini</a> untuk melihat
                  """
        FlashService.info message, MomentService.currentTime()
        clearCart()
        $scope.showNotificationStatus()

    $scope.addToCart = ->
        selectedItem = (_.where $scope.items.$$v, _id: $scope.item)[0]

        if _.contains($scope.cart, selectedItem)
            angular.element("[data-id='#{selectedItem._id}']").focus()
        else
            $scope.cart.push selectedItem

    $scope.calculateTotalPrice = ->
        totalQty = _.pluck($scope.cart, 'qty')
        totalPrice = _.pluck($scope.cart, 'purchase_price')
        total = _.zip(totalQty, totalPrice)

        a = _.reduce(total, (c, x) ->
            c + (x[0] * x[1])
        , 0)
        return a

    $scope.clear = (index) ->
        $scope.cart.splice(index, 1)

    $scope.clearAll = ->
        $scope.cart.splice(0)

    $scope.filteredItems = ->
        _.where($scope.items.$$v, { suppliers: {_id: $scope.supplier } })

    $scope.submit = ->
        items = _.map $scope.cart, (cart) ->
            return {
                item: _.values(_.pick cart, '_id')[0]
                quantity: _.values(_.pick cart, 'qty')[0]
            }

        invoice =
            created_at: $scope.datetime
            code: $scope.code
            supplier: $scope.supplier
            details: items

        Restangular.all('purchase_invoices').post(invoice).then (result) ->
            SocketService.emit 'create:purchase_invoice', result
        , (err) ->
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Kode faktur sudah ada', MomentService.currentTime()

        angular.element('#invoice_code').focus()
