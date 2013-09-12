app.controller 'StatisticController', ($scope, Restangular) ->
    $scope.asset = [
        name: 'Beli'
        y: 23
        color: '#d9534f'
    ,
        name: 'Jual'
        y: 53
        color: '#1f6377'
    ]

    Restangular.one('purchase/range').get().then (data) ->
        $scope.transaction = data
