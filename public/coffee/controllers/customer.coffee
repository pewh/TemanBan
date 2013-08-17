app.controller 'CustomerController', ($scope, $routeParams, $location, FlashService, CustomerResource, SocketService, filterFilter) ->
    resource = CustomerResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:customer', (data) ->
        FlashService.info "Pelanggan #{data.name} telah ditambah"
        resource.query (res) -> $scope.data = res

    SocketService.on 'update:customer', (data) ->
        FlashService.info "Pelanggan #{data.name} telah diedit"
        resource.query (res) -> $scope.data = res

    SocketService.on 'delete:customer', (data) ->
        FlashService.info "Pelanggan #{data.name} telah dihapus"
        resource.query (res) -> $scope.data = res

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.customer = res

    $scope.add = ->
        resource.save $scope.customer, ->
            SocketService.emit 'create:customer', $scope.customer
            $scope.customer =
                name: ''
                address: ''
                contact: ''
            ($ '#name').focus()
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.update = ->
        $scope.customer.$update ->
            SocketService.emit 'update:customer', $scope.customer
            $location.path '/customer'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        customer = _.where($scope.data, _id: id)[0]
        FlashService.confirm "Apakah Anda yakin untuk menghapus #{customer.name}?", ->
            resource.remove id: id, ->
                SocketService.emit 'delete:customer', customer

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:customer', $scope.filteredData.length
            console.log $scope.filteredData.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:customer', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
