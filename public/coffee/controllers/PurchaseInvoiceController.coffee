app.controller 'PurchaseInvoiceController', ($scope, Restangular, SocketService, FlashService, MomentService) ->
    invoices = Restangular.all 'purchase_invoices'

    do reload = ->
        $scope.data = invoices.getList()

    SocketService.on 'delete:purchase_invoice', (data) ->
        FlashService.info "Faktur beli #{data.code} telah dihapus", MomentService.currentTime()
        reload()

    $scope.calculateTotalPrice = (details) ->
        stock = _.pluck details, 'quantity'
        purchase_price = _.pluck( _.pluck(details, 'item'), 'purchase_price')
        zipped = _.zip(stock, purchase_price)
        sumZipped = _.map zipped, (z) -> z[0] * z[1]

        _.reduce sumZipped, (c, v) -> c + v

    $scope.remove = (id) ->
        Restangular.one('purchase_invoices', id).remove().then (invoice) ->
            SocketService.emit 'delete:purchase_invoice', invoice

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
