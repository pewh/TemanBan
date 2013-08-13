app.controller 'MenuController', ($scope, AuthenticationService, ItemResource, SupplierResource, CustomerResource, SocketService) ->
    $scope.$on '$destroy', (event) -> SocketService.destroy()

    $scope.isLoggedIn = AuthenticationService.isLoggedIn()
    $scope.logout = -> AuthenticationService.logout()

    $scope.count = {}

    categories = [
        resource: ItemResource
        scopeName: 'item'
        event: ['connect', 'create:item', 'delete:item', 'search:item']
    ,
        resource: SupplierResource
        scopeName: 'supplier'
        event: ['connect', 'create:supplier', 'delete:supplier', 'search:supplier']
    ,
        resource: CustomerResource
        scopeName: 'customer'
        event: ['connect', 'create:customer', 'delete:customer', 'search:customer']
    ]


    categories.map (category) ->
        category.event.map (event) ->
            SocketService.on event, (data) ->
                if event.match(/^search:/)?
                    $scope.count[category.scopeName] = data
                else
                    category.resource.query (res) ->
                        $scope.count[category.scopeName] = res.length
