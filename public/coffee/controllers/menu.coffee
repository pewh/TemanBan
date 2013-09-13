app.controller 'MenuController', ($scope, AuthenticationService, FlashService, MomentService, SocketService) ->
    $scope.activeLink = 'item'
    $scope.isLoggedIn = AuthenticationService.isLoggedIn()
    $scope.currentUser = AuthenticationService.currentUser()
    $scope.currentRole = AuthenticationService.currentRole()
    $scope.logout = -> AuthenticationService.logout()
    $scope.notifications = []

    $scope.newNotification = true

    $scope.removeNewNotificationStatus = ->
        $scope.newNotification = false

    $scope.clearAllNotification = ->
        FlashService.clear()

    SocketService.on 'create:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            user: $scope.currentUser
            msg: "#{$scope.currentUser} menambah barang #{data.name}"
            
    SocketService.on 'update:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            msg: 'Barang telah diedit'
            
    SocketService.on 'delete:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            msg: 'Barang telah dihapus'
            
    ###
    $scope.count = {}
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
