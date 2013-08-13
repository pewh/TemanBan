app.controller 'CustomerController', ($scope, $routeParams, $location, FlashService, CustomerResource, SocketService, filterFilter) ->
    resource = CustomerResource

    resource.query (res) -> $scope.data = res

    SocketService.on 'create:customer', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pelanggan #{data.name} telah ditambah"

    SocketService.on 'update:customer', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pelanggan #{data} telah diedit"

    SocketService.on 'delete:customer', (data) ->
        resource.query (res) ->
            $scope.data = res
            FlashService.info "Pelanggan #{data.name} telah dihapus"

    $scope.load = ->
        resource.get id: $routeParams.id, (res) -> $scope.customer = res[0]

    $scope.add = ->
        resource.save $scope.customer, ->
            SocketService.emit 'create:customer', $scope.customer
            $scope.customer =
                name: ''
                address: ''
                contact: []
            ($ '#name').focus()
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.update = ->
        modifiedCustomer = $scope.customer.name
        $scope.customer.$update ->
            SocketService.emit 'update:customer', modifiedCustomer
            $location.path '/customer'
        , (err) -> FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        resource.get id: id, (removedCustomer)->
            resource.remove id: id, -> SocketService.emit 'delete:customer', removedCustomer[0]

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:customer', $scope.filteredData?.length
