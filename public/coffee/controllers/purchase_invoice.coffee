app.controller 'PurchaseInvoiceController', ($scope, $stateParams, Restangular, SocketService, FlashService, MomentService) ->
    $scope.suppliers = Restangular.all('suppliers').getList()
    $scope.items = Restangular.all('items').getList()
    invoices = Restangular.all 'purchase_invoices'

    do reload = ->
        $scope.data = invoices.getList()

    clearCart = ->
        $scope.code = ''
        $scope.supplier = ''
        $scope.cart = []

    SocketService.on 'delete:purchase_invoice', (data) ->
        FlashService.info "Faktur beli #{data.code} telah dihapus", MomentService.currentTime()
        reload()

    $scope.calculateTotalPrice = (details) ->
        stock = _.pluck details, 'quantity'
        purchase_price = _.pluck( _.pluck(details, 'item'), 'purchase_price')
        zipped = _.zip(stock, purchase_price)
        sumZipped = _.map zipped, (z) -> z[0] * z[1]

        _.reduce sumZipped, (c, v) -> c + v

    $scope.calculateTotalQty = (details) ->
        stock = _.pluck details, 'quantity'

        _.reduce stock, (c, v) -> c + v

    $scope.remove = (id) ->
        Restangular.one('purchase_invoices', id).remove().then (invoice) ->
            SocketService.emit 'delete:purchase_invoice', invoice

    $scope.collapseInvoice = {}

    $scope.itemlist = (invoiceId) ->
        $scope.collapseInvoice[invoiceId] = not $scope.collapseInvoice[invoiceId]

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
