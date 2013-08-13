app.controller 'SupplierController', ($scope, $routeParams, $location, FlashService, SupplierResource, SocketService, filterFilter) ->
    resource = SupplierResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:supplier', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pemasok #{data.name} telah ditambah"

    SocketService.on 'update:supplier', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pemasok #{data} telah diedit"

    SocketService.on 'delete:supplier', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pemasok #{data.name} telah dihapus"

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.supplier = res[0]

    $scope.add = ->
        resource.save $scope.supplier, ->
            SocketService.emit 'create:supplier', $scope.supplier
            $scope.supplier =
                name: ''
                address: ''
                contact: []
            ($ '#name').focus()
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.update = ->
        modifiedSupplier = $scope.supplier.name
        $scope.supplier.$update ->
            SocketService.emit 'update:supplier', modifiedSupplier
            $location.path '/supplier'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        resource.get id: id, (removedSupplier)->
            resource.remove id: id, -> SocketService.emit 'delete:supplier', removedSupplier[0]

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:supplier', $scope.filteredData?.length
