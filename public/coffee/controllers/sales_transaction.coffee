app.controller 'SalesTransactionController', ($scope, Restangular, FlashService, SocketService, MomentService) ->
    $scope.cart = []
    $scope.customers = Restangular.all('customers').getList()
    $scope.items = Restangular.all('items').getList()

    setInterval ->
        $scope.$apply ->
            $scope.datetime = (new Date()).toISOString()
    , 1000

    clearCart = ->
        $scope.code = ''
        $scope.customer = ''
        $scope.discount = 0
        $scope.cart = []

    SocketService.on 'create:sales_invoice', (data) ->
        message = """
                  Faktur penjualan #{data.code} telah ditambah <br />
                  Klik <a href="/#/invoice/sales">disini</a> untuk melihat
                  """
        FlashService.info message, MomentService.currentTime()
        clearCart()

    $scope.addToCart = ->
        selectedItem = (_.where $scope.items.$$v, _id: $scope.item)[0]

        if _.contains($scope.cart, selectedItem)
            angular.element("[data-id='#{selectedItem._id}']").focus()
        else
            if selectedItem.stock == 0
                FlashService.error "Stok #{selectedItem.name} tidak tersedia"
            else
                $scope.cart.push selectedItem

    $scope.updateTotal = (index) ->
        console.log index
        $scope.cart[index].total = $scope.cart[index].qty * $scope.cart[index].sales_price

    $scope.grandTotal = ->
        total = _.pluck($scope.cart, 'total')
        a = _.reduce total, (c, x) -> c + x
        return a

    $scope.clear = (index) ->
        $scope.cart.splice(index, 1)

    $scope.clearAll = ->
        $scope.cart.splice(0)

    $scope.submit = ->
        items = _.map $scope.cart, (cart) ->
            return {
                item: _.values(_.pick cart, '_id')[0]
                quantity: _.values(_.pick cart, 'qty')[0]
            }

        invoice =
            created_at: $scope.datetime
            code: $scope.code
            customer: $scope.customer
            discount: $scope.discount
            details: items

        Restangular.all('sales_invoices').post(invoice).then (result) ->
            SocketService.emit 'create:sales_invoice', result
        , (err) ->
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Kode faktur sudah ada', MomentService.currentTime()

        angular.element('#invoice_code').focus()
