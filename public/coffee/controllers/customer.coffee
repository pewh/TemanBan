app.controller 'CustomerController', ($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) ->
    customers = Restangular.all 'customers'

    do reload = ->
        $scope.data = customers.getList()
        $scope.showNotificationStatus()

    SocketService.on 'create:customer', (data) ->
        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-info'
            msg: "#{$scope.currentUser} menambah pelanggan #{data.name}"
            detail: """
                    Nama:   <strong>#{data.name}</strong> <br />
                    Alamat: <strong>#{data.address}</strong> <br />
                    Kontak: <strong>#{data.contact}</strong>
                    """
            
        FlashService.info "Pelanggan #{data.name} telah ditambah", MomentService.currentTime()
        reload()

    SocketService.on 'update:customer', (data) ->
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

        message = """
                  Pelanggan telah di-update <br />
                  Nama:    <strong>#{data.name}</strong> <br />
                  Kolom:   <strong>#{data.field}</strong> <br />
                  Sebelum: <strong>#{data.oldValue}</strong> <br />
                  Sesudah: <strong>#{data.newValue}</strong>
                  """
        FlashService.info message, MomentService.currentTime()
        reload()

    SocketService.on 'delete:customer', (data) ->
        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus pelanggan #{data.name}"

        FlashService.info "Pelanggan #{data.name} telah dihapus", MomentService.currentTime()
        reload()

    SocketService.on 'create:purchase_invoice', (data) ->
        $scope.showNotificationStatus()
        reload()

    SocketService.on 'delete:purchase_invoice', (data) ->
        $scope.showNotificationStatus()
        reload()

    SocketService.on 'create:sales_invoice', (data) ->
        $scope.showNotificationStatus()
        reload()

    SocketService.on 'delete:sales_invoice', (data) ->
        $scope.showNotificationStatus()
        reload()

    $scope.add = ->
        customers.post($scope.customer).then (customer) ->
            SocketService.emit 'create:customer', customer
            $scope.customer =
                name: ''
                address: ''
                contact: ''
                
            angular.element('#name').focus()
        , (err) ->
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Nama pelanggan sudah ada', MomentService.currentTime()

    $scope.remove = (id) ->
        Restangular.one('customers', id).remove().then (customer) ->
            SocketService.emit 'delete:customer', customer

    $scope.$watch 'showNewForm', (val) ->
        if $scope.showNewForm
            $location.path('/customer/new')
        else
            $location.path('/customer')

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
