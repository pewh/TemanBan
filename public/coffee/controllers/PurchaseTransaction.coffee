app.controller 'PurchaseTransactionController', ($scope, Restangular, FlashService) ->
    $scope.cart = []
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()

    setInterval ->
        $scope.$apply ->
            $scope.datetime = (new Date()).toISOString()
    , 1000

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
        $scope.cart[index].total = $scope.cart[index].qty * $scope.cart[index].purchase_price

    $scope.grandTotal = ->
        total = _.pluck($scope.cart, 'total')
        a = _.reduce total, (c, x) -> c + x
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
            details: items

        Restangular.all('purchase_invoices').post(invoice).then (result) ->
            console.log result
        , (err) ->
            console.err err
            ###
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Nama barang sudah ada', MomentService.currentTime()
            ###
