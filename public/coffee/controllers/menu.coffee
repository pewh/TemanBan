app.controller 'MenuController', ($scope, Restangular, AuthenticationService, FlashService, MomentService, SocketService) ->
    $scope.activeLink = 'item'
    $scope.isLoggedIn = AuthenticationService.isLoggedIn()
    $scope.currentUser = AuthenticationService.currentUser()
    $scope.currentRole = AuthenticationService.currentRole()
    $scope.logout = -> AuthenticationService.logout()
    $scope.suppliers = Restangular.all('suppliers').$$v
    $scope.notifications = []

    $scope.newNotification = true

    $scope.removeNewNotificationStatus = ->
        $scope.newNotification = false

    $scope.clearAllNotification = ->
        $scope.notifications.splice(0)

    SocketService.on 'create:item', (data) ->
        $scope.newNotification = true

        console.log $scope.suppliers
        $scope.notifications.push
            date: MomentService.currentTime()
            msg: "#{$scope.currentUser} menambah barang #{data.name}"
            detail: """
                    Pemasok:    <strong>#{data.suppliers.name}</strong> <br />
                    Harga Beli: <strong>#{data.purchase_price}</strong> <br />
                    Harga Jual: <strong>#{data.sales_price}</strong>
                    """
            
    SocketService.on 'update:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            msg: "#{$scope.currentUser} mengedit barang #{data.name}"
            detail: """
                    <strong>#{data.field}</strong> <br />
                    <li class=divider />
                    Sebelum: <strong>#{data.oldValue}</strong> <br />
                    Sesudah: <strong>#{data.newValue}</strong> <br />
                    """
            
    SocketService.on 'delete:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            msg: "#{$scope.currentUser} menghapus barang #{data.name}"
            
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
