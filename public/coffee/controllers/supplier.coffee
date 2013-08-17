app.controller 'SupplierController', ($scope, $routeParams, $location, FlashService, SupplierResource, SocketService, filterFilter) ->
    resource = SupplierResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:supplier', (data) ->
        FlashService.info "Pemasok #{data.name} telah ditambah"
        resource.query (res) -> $scope.data = res

    SocketService.on 'update:supplier', (data) ->
        FlashService.info "Pemasok #{data.name} telah diedit"
        resource.query (res) -> $scope.data = res

    SocketService.on 'delete:supplier', (data) ->
        FlashService.info "Pemasok #{data.name} telah dihapus"
        resource.query (res) -> $scope.data = res

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.supplier = res

    $scope.collapseSupplier = {}

    $scope.itemlist = (supplierId) ->
        #if $scope.collapseSupplier[supplierId] is undefined
        #    $scope.collapseSupplier[supplierId] = true
        #else
        #    $scope.collapseSupplier[supplierId] = false

        $scope.collapseSupplier[supplierId] = not $scope.collapseSupplier[supplierId]

    $scope.add = ->
        resource.save $scope.supplier, ->
            SocketService.emit 'create:supplier', $scope.supplier
            $scope.supplier =
                name: ''
                address: ''
                contact: ''
            ($ '#name').focus()
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.update = ->
        $scope.supplier.$update ->
            SocketService.emit 'update:supplier', $scope.supplier
            $location.path '/supplier'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        supplier = _.where($scope.data, _id: id)[0]
        FlashService.confirm "Apakah Anda yakin untuk menghapus #{supplier.name}?", ->
            resource.remove id: id, ->
                SocketService.emit 'delete:supplier', supplier

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:supplier', $scope.filteredData?.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:supplier', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
