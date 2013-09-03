app.controller 'PurchaseTransactionController', ($scope, Restangular, FlashService) ->
    $scope.cart = []
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()

    $scope.addToCart = ->
        selectedItem = (_.where $scope.items.$$v, _id: $scope.item)[0]

        if _.contains($scope.cart, selectedItem)
            angular.element("[data-id='#{selectedItem._id}']").editable 'toggle'
        else
            if selectedItem.stock == 0
                FlashService.error "Stok #{selectedItem.name} tidak tersedia"
            else
                $scope.cart.push selectedItem

    $scope.updateTotal = (index) ->
        console.log index
        $scope.cart[index].total = $scope.cart[index].qty * $scope.cart[index].purchase_price

    $scope.clear = (index) ->
        $scope.cart.splice(index, 1)

    $scope.clearAll = ->
        $scope.cart.splice(0)

    $scope.filteredItems = ->
        _.where($scope.items.$$v, { suppliers: {_id: $scope.supplier } })
