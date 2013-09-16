app.controller 'SalesInvoiceController', ($scope, $stateParams, Restangular, SocketService, FlashService, MomentService) ->
    $scope.customers = Restangular.all('customers').getList()
    $scope.items = Restangular.all('items').getList()
    invoices = Restangular.all 'sales_invoices'

    do reload = ->
        $scope.data = invoices.getList()

    clearCart = ->
        $scope.code = ''
        $scope.customer = ''
        $scope.cart = []

    SocketService.on 'delete:sales_invoice', (data) ->
        $scope.notifications.push
            date: MomentService.currentTime()
            labelAction: 'label-danger'
            msg: "#{$scope.currentUser} menghapus faktur penjualan  #{data.code}"

        FlashService.info "Faktur jual #{data.code} telah dihapus", MomentService.currentTime()

        $scope.showNotificationStatus()
        reload()

    SocketService.on 'create:sales_invoice', (data) ->
        $scope.showNotificationStatus()
        reload()

    SocketService.on 'update:item', (data) ->
        $scope.showNotificationStatus()
        reload()

    SocketService.on 'update:customer', (data) ->
        $scope.showNotificationStatus()
        reload()

    $scope.calculateTotalPrice = (details) ->
        stock = _.pluck details, 'quantity'
        sales_price = _.pluck( _.pluck(details, 'item'), 'sales_price')
        zipped = _.zip(stock, sales_price)
        sumZipped = _.map zipped, (z) -> z[0] * z[1]

        _.reduce sumZipped, (c, v) -> c + v

    $scope.calculateTotalQty = (details) ->
        stock = _.pluck details, 'quantity'

        _.reduce stock, (c, v) -> c + v

    $scope.remove = (id) ->
        Restangular.one('sales_invoices', id).remove().then (invoice) ->
            SocketService.emit 'delete:sales_invoice', invoice

    $scope.collapseInvoice = {}

    $scope.itemlist = (invoiceId) ->
        $scope.collapseInvoice[invoiceId] = not $scope.collapseInvoice[invoiceId]

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
