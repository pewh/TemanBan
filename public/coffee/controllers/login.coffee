app.controller 'LoginController', ($scope, AuthenticationService) ->
    $scope.credentials =
        username: ''
        password: ''

    $scope.login = -> AuthenticationService.login($scope.credentials)
