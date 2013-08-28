app.controller 'MenuController', ($scope, AuthenticationService, ItemResource, SupplierResource, SocketService) ->
    ###
    $scope.isLoggedIn = AuthenticationService.isLoggedIn()
    $scope.currentUser = AuthenticationService.currentUser()
    $scope.currentRole = AuthenticationService.currentRole()
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
            
    ###
    ###

    SocketService.on 'connect', (data) ->
        ItemResource.query (res) -> $scope.count.item = res.length
        SupplierResource.query (res) -> $scope.count.supplier = res.length
        CustomerResource.query (res) -> $scope.count.customer = res.length

    # ITEM
    SocketService.on 'create:item', (data) ->
        ItemResource.query (res) ->
            $scope.count.item = res.length

    SocketService.on 'delete:item', (data) ->
        console.log 'oe'
        ItemResource.query (res) -> $scope.count.item = res.length

    SocketService.on 'search:item', (data) -> $scope.count.item = data

    # SUPPLIER
    SocketService.on 'create:supplier', (data) ->
        SupplierResource.query (res) -> $scope.count.supplier = res.length

    SocketService.on 'delete:supplier', (data) ->
        SupplierResource.query (res) -> $scope.count.supplier = res.length

    SocketService.on 'search:supplier', (data) -> $scope.count.supplier = data

    # CUSTOMER
    SocketService.on 'create:customer', (data) ->
        CustomerResource.query (res) -> $scope.count.customer = res.length

    SocketService.on 'delete:customer', (data) ->
        CustomerResource.query (res) -> $scope.count.customer = res.length

    SocketService.on 'search:customer', (data) -> $scope.count.customer = data
    ###
