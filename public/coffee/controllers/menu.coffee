app.controller 'MenuController', ($scope, Restangular, AuthenticationService, FlashService, MomentService, SocketService) ->
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
        $scope.notifications.splice(0)

    # ITEM
    SocketService.on 'create:item', (data) ->
        $scope.newNotification = true

        Restangular.one('suppliers', data.suppliers).getList().then (supplier) ->
            $scope.notifications.push
                date: MomentService.currentTime()
                labelAction: 'label-info'
                msg: "#{$scope.currentUser} menambah barang #{data.name}"
                detail: """
                        Nama:       <strong>#{data.name}</strong> <br />
                        Harga Beli: <strong>#{data.purchase_price}</strong> <br />
                        Harga Jual: <strong>#{data.sales_price}</strong>
                        Pemasok:    <strong>#{supplier.name}</strong> <br />
                        """
            
    SocketService.on 'update:item', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-warning'
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
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus barang #{data.name}"
            

    # SUPPLIER
    SocketService.on 'create:supplier', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-info'
            msg: "#{$scope.currentUser} menambah pemasok #{data.name}"
            detail: """
                    Nama:   <strong>#{data.name}</strong> <br />
                    Alamat: <strong>#{data.address}</strong> <br />
                    Kontak: <strong>#{data.contact}</strong>
                    """
            
    SocketService.on 'update:supplier', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-warning'
            msg: "#{$scope.currentUser} mengedit pemasok #{data.name}"
            detail: """
                    <strong>#{data.field}</strong> <br />
                    <li class=divider />
                    Sebelum: <strong>#{data.oldValue}</strong> <br />
                    Sesudah: <strong>#{data.newValue}</strong> <br />
                    """
            
    SocketService.on 'delete:supplier', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus pemasok #{data.name}"
            

    # CUSTOMER
    SocketService.on 'create:customer', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-info'
            msg: "#{$scope.currentUser} menambah pelanggan #{data.name}"
            detail: """
                    Nama:   <strong>#{data.name}</strong> <br />
                    Alamat: <strong>#{data.address}</strong> <br />
                    Kontak: <strong>#{data.contact}</strong>
                    """
            
    SocketService.on 'update:customer', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-warning'
            msg: "#{$scope.currentUser} mengedit pelanggan #{data.name}"
            detail: """
                    <strong>#{data.field}</strong> <br />
                    <li class=divider />
                    Sebelum: <strong>#{data.oldValue}</strong> <br />
                    Sesudah: <strong>#{data.newValue}</strong> <br />
                    """
            
    SocketService.on 'delete:customer', (data) ->
        $scope.newNotification = true

        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus pelanggan #{data.name}"

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
