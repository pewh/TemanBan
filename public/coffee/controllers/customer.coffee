app.controller 'CustomerController', ($scope, $routeParams, $location, Restangular, FlashService, SocketService, filterFilter) ->
    customers = Restangular.all 'customers'

    do reload = ->
        $scope.data = customers.getList()

    SocketService.on 'create:customer', (data) ->
        reload()
        FlashService.info "Pelanggan #{data.name} telah ditambah"

    SocketService.on 'update:customer', (data) ->
        reload()
        FlashService.info "Pelanggan #{data.name} telah diedit"

    SocketService.on 'delete:customer', (data) ->
        reload()
        FlashService.info "Pelanggan #{data.name} telah dihapus"

    $scope.load = ->
        $scope.customer = Restangular.one('customers', $routeParams.id).get()

    $scope.add = ->
        customers.post($scope.customer).then (customer) ->
            SocketService.emit 'create:customer', customer
            $scope.customer =
                name: ''
                address: ''
                contact: ''
                
            angular.element('#name').focus()
        , (err) ->
            FlashService.error err.data.err if err.status == 500

    $scope.update = ->
        $scope.customer.put().then (customer) ->
            SocketService.emit 'update:customer', customer
            $location.path '/customer'
        , (err) ->
            FlashService.error err.data if err.status == 500

    $scope.remove = (id) ->
        Restangular.one('customers', id).remove().then (customer) ->
            SocketService.emit 'delete:customer', customer

    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)
        console.log $scope.data, $scope.search, $scope.filteredData

        if val isnt undefined
            SocketService.emit 'search:customer', $scope.filteredData.length
            console.log $scope.filteredData.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:customer', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
