app.controller 'ItemController', ($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) ->
    items = Restangular.all 'items'

    do reload = ->
        $scope.data = items.getList()
        $scope.suppliers = Restangular.all('suppliers').getList()

    SocketService.on 'create:item', (data) ->
        message = "Barang #{data.name} telah ditambah"
        FlashService.info message, MomentService.currentTime()
        reload()

    SocketService.on 'update:item', (data) ->
        message = """
                  Barang telah di-update <br />
                  Nama:    <strong>#{data.name}</strong> <br />
                  Kolom:   <strong>#{data.field}</strong> <br />
                  Sebelum: <strong>#{data.oldValue}</strong> <br />
                  Sesudah: <strong>#{data.newValue}</strong>
                  """
        FlashService.info message, MomentService.currentTime()
        reload()

    SocketService.on 'delete:item', (data) ->
        FlashService.info "Barang #{data.name} telah dihapus", MomentService.currentTime()
        reload()

    $scope.watchStock = (index) ->
        'danger': !$scope.data.$$v[index].stock
        'warning': 0 < $scope.data.$$v[index].stock < 5

    $scope.add = ->
        if $scope.item.purchase_price >= $scope.item.sales_price
            FlashService.error 'Harga jual harus lebih besar dari harga beli', MomentService.currentTime()
        else
            items.post($scope.item).then (item) ->
                SocketService.emit 'create:item', item
                $scope.item =
                    stock: 1
                    purchase_price: 1
                    sales_price: 1

                angular.element('#name').focus()
            , (err) ->
                if err.status == 500
                    if err.data.code == 11000
                        FlashService.error 'Nama barang sudah ada', MomentService.currentTime()

    $scope.remove = (id) ->
        Restangular.one('items', id).remove().then (item) ->
            SocketService.emit 'delete:item', item

    $scope.$watch 'showNewForm', (val) ->
        if $scope.showNewForm
            $location.path('/item/new')
        else
            $location.path('/item')

    ###
    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)

        if val isnt undefined
            SocketService.emit 'search:item', $scope.filteredData.length

    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:item', $scope.data.length
    ###

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
