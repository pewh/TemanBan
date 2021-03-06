app.controller 'SupplierController', ($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) ->
    suppliers = Restangular.all 'suppliers'
    items = Restangular.all('items')

    items.getList().then (x) ->
        $scope.itemsBySupplier = (supplierId) -> _.where x, { suppliers: {_id: supplierId }}

    do reload = ->
        $scope.data = suppliers.getList()

    SocketService.on 'create:supplier', (data) ->
        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-info'
            msg: "#{$scope.currentUser} menambah pemasok #{data.name}"
            detail: """
                    Nama:   <strong>#{data.name}</strong> <br />
                    Alamat: <strong>#{data.address}</strong> <br />
                    Kontak: <strong>#{data.contact}</strong>
                    """

        message = "Pemasok #{data.name} telah ditambah"
        FlashService.info message, MomentService.currentTime()

        $scope.showNotificationStatus()
        reload()


    SocketService.on 'update:supplier', (data) ->
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

        message = """
                  Pemasok telah di-update <br />
                  Nama:    <strong>#{data.name}</strong> <br />
                  Kolom:   <strong>#{data.field}</strong> <br />
                  Sebelum: <strong>#{data.oldValue}</strong> <br />
                  Sesudah: <strong>#{data.newValue}</strong>
                  """
        FlashService.info message, MomentService.currentTime()

        $scope.showNotificationStatus()
        reload()


    SocketService.on 'delete:supplier', (data) ->
        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus pemasok #{data.name}"

        FlashService.info "Pemasok #{data.name} telah dihapus", MomentService.currentTime()

        $scope.showNotificationStatus()
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

    $scope.watchStock = (item) ->
        'danger': !item.stock
        'warning': 0 < item.stock < 5

    # TODO: use bootstrap collapse
    $scope.collapseSupplier = {}

    $scope.itemlist = (supplierId) ->
        $scope.collapseSupplier[supplierId] = not $scope.collapseSupplier[supplierId]

    $scope.add = ->
        suppliers.post($scope.supplier).then (supplier) ->
            SocketService.emit 'create:supplier', supplier
            $scope.supplier =
                name: ''
                address: ''
                contact: ''
            angular.element('#name').focus()
        , (err) ->
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Nama pemasok sudah ada', MomentService.currentTime()

    $scope.remove = (id) ->
        Restangular.one('suppliers', id).remove().then (supplier) ->
            SocketService.emit 'delete:supplier', supplier

    $scope.$watch 'showNewForm', (val) ->
        if $scope.showNewForm
            $location.path('/supplier/new')
        else
            $location.path('/supplier')

    ###
    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:supplier', $scope.filteredData?.length
    ###

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:supplier', $scope.data.length

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
