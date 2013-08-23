app.controller 'ItemController', ($scope, $routeParams, $location, FlashService, MomentService, ItemResource, SupplierResource, SocketService, filterFilter) ->
    resource = ItemResource

    do reload = ->
        resource.query (res) -> $scope.data = res

    SocketService.on 'create:item', (data) ->
        reload()
        message = "Barang #{data.name} telah ditambah\nlagi"
        FlashService.info message, MomentService.currentTime()

    SocketService.on 'update:item', (data) ->
        reload()
        message = "#{data.field} dari barang #{data.name} telah di-update menjadi #{data.newValue}".capitalize()
        FlashService.info message, MomentService.currentTime()

    SocketService.on 'delete:item', (data) ->
        reload()
        FlashService.info "Barang #{data.name} telah dihapus", MomentService.currentTime()

    SupplierResource.query (res) ->
        $scope.suppliers = res

    $scope.stockStatus =
        isEmpty: (index) -> !$scope.data[index].stock
        isWarning: (index) -> 0 < $scope.data[index].stock < 5

    $scope.load = ->
        if $routeParams.id
            resource.get id: $routeParams.id, (res) -> $scope.item = res

    $scope.add = ->
        resource.save @item, =>
            SocketService.emit 'create:item', @item
            @item =
                stock: 1
                purchase_price: 1
                sales_price: 1
            ($ '#name').focus()
        , (err) ->
            if err.status == 500
                FlashService.error 'Nama barang sudah ada' if err.data.code == 11000

    $scope.edit = (id) ->
        $scope.showEditForm = true
        $scope.showNewForm = false
        $scope.selectedId = id
        $routeParams.id = id

    $scope.remove = (id) ->
        item = _.where($scope.data, _id: id)[0]
        resource.remove id: id, ->
            SocketService.emit 'delete:item', item

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:item', $scope.filteredData.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:item', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
