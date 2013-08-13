app.controller 'ItemController', ($scope, $routeParams, $location, FlashService, ItemResource, SupplierResource, SocketService, filterFilter) ->
    resource = ItemResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:item', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Barang #{data.name} telah ditambah"

    SocketService.on 'update:item', (data) ->
        # BUG called triple times
        # TODO show what's part that has modified
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Barang #{data} telah diedit"

    SocketService.on 'delete:item', (data) ->
        resource.remove id: data.id, ->
            FlashService.info "Barang #{data.item.name} telah dihapus"
            resource.query (res) -> $scope.data = res

    SupplierResource.query (res) -> $scope.suppliers = res

    $scope.stockStatus =
        isEmpty: (index) -> !$scope.data[index].stock
        isWarning: (index) -> 0 < $scope.data[index].stock < 5

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.item = res[0]

    $scope.add = ->
        resource.save $scope.item, ->
            SocketService.emit 'create:item', $scope.item
            $scope.item =
                stock: 1
                purchase_price: 1
                sales_price: 1
            ($ '#name').focus()
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.update = ->
        modifiedItem = $scope.item.name
        $scope.item.$update ->
            SocketService.emit 'update:item', modifiedItem
            $location.path '/item'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        resource.get id: id, (removedItem)->
            FlashService.confirm "Apakah Anda yakin untuk menghapus #{removedItem[0].name}?", ->
                SocketService.emit 'delete:item', { id: id, item: removedItem[0] }

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:item', $scope.filteredData?.length
        else
            SocketService.emit 'search:item', $scope.data.length
