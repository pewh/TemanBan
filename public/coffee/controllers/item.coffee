app.controller 'ItemController', ($scope, $routeParams, $location, FlashService, ItemResource, SupplierResource, SocketService, filterFilter) ->
    resource = ItemResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:item', (data) ->
        FlashService.info "Barang #{data.name} telah ditambah"
        resource.query (res) -> $scope.data = res

    SocketService.on 'update:item', (data) ->
        # BUG called triple times
        # TODO show what's part that has modified
        FlashService.info "Barang #{data.name} telah diedit"
        resource.query (res) -> $scope.data = res

    SocketService.on 'delete:item', (data) ->
        FlashService.info "Barang #{data.name} telah dihapus"
        resource.query (res) -> $scope.data = res

    SupplierResource.query (res) -> $scope.suppliers = res

    $scope.stockStatus =
        isEmpty: (index) -> !$scope.data[index].stock
        isWarning: (index) -> 0 < $scope.data[index].stock < 5

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.item = res

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
        $scope.item.$update ->
            SocketService.emit 'update:item', $scope.item
            $location.path '/item'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        item = _.where($scope.data, _id: id)[0]
        #FlashService.confirm "Apakah Anda yakin untuk menghapus #{item.name}?", ->
        resource.remove id: id, ->
            SocketService.emit 'delete:item', item

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:item', $scope.filteredData?.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:item', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
