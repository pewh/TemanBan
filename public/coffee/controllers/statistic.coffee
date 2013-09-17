app.controller 'StatisticController', ($scope, Restangular, SocketService) ->

    do reload = ->
        Restangular.one('purchase/range').get().then (data) ->
            $scope.transaction = data

            $scope.isDataExist = ->
                chartData = (data[0].data[0].y or data[1].data[0].y)
                return chartData

            $scope.purchaseTotal = _.reduce data[0].data, (prev, key) ->
                prev + key.y
            , 0

            $scope.salesTotal = _.reduce data[1].data, (prev, key) ->
                prev + key.y
            , 0

            $scope.calcTotal = $scope.salesTotal - $scope.purchaseTotal

            if $scope.calcTotal < 0
                $scope.currencyStatus = 'Kerugian'
                $scope.calcTotal = Math.abs($scope.calcTotal)
            else
                $scope.currencyStatus = 'Keuntungan'

            total = $scope.purchaseTotal + $scope.salesTotal

            salesRatio =
                purchase: $scope.purchaseTotal / total * 100
                sales: $scope.salesTotal / total * 100

            $scope.asset = [
                name: 'Beli'
                y: salesRatio.purchase
                color: '#d9534f'
            ,
                name: 'Jual'
                y: salesRatio.sales
                color: '#1f6377'
            ]

    SocketService.on 'update:item', (data) -> reload()
    SocketService.on 'create:purchase_invoice', (data) -> reload()
    SocketService.on 'delete:purchase_invoice', (data) -> reload()
    SocketService.on 'create:sales_invoice', (data) -> reload()
    SocketService.on 'delete:sales_invoice', (data) -> reload()
