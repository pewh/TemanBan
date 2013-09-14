app.controller 'UserController', ($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, SessionService, filterFilter) ->
    users = Restangular.all 'users'

    $scope.roles = [
        value:'Sales'
        text:'Sales'
    ,
        value:'Manager'
        text:'Manager'
    ,
        value:'Komisaris'
        text:'Komisaris'
    ]

    do reload = ->
        $scope.data = users.getList()

    $scope.hideCurrentUserInfo = ->
        return (data) ->
            data.username isnt SessionService.get('username')

    SocketService.on 'create:user', (data) ->
        FlashService.info "Username #{data.username} telah ditambah", MomentService.currentTime()
        reload()

    SocketService.on 'update:user', (data) ->
        message = """
                  Username telah di-update <br />
                  Nama:    <strong>#{data.name}</strong> <br />
                  Kolom:   <strong>#{data.field}</strong> <br />
                  Sebelum: <strong>#{data.oldValue}</strong> <br />
                  Sesudah: <strong>#{data.newValue}</strong>
                  """
        FlashService.info message, MomentService.currentTime()
        reload()

    SocketService.on 'delete:user', (data) ->
        FlashService.info "Username #{data.username} telah dihapus", MomentService.currentTime()
        reload()

    $scope.add = ->
        users.post($scope.user).then (user) ->
            SocketService.emit 'create:user', user
            $scope.user =
                username: ''
                password: ''
                
            angular.element('#username').focus()
        , (err) ->
            if err.status == 500
                if err.data.code == 11000
                    FlashService.error 'Username sudah ada', MomentService.currentTime()

    $scope.remove = (id) ->
        Restangular.one('users', id).remove().then (user) ->
            SocketService.emit 'delete:user', user

    $scope.$watch 'showNewForm', (val) ->
        if $scope.showNewForm
            $location.path('/user/new')
        else
            $location.path('/user')

    $scope.$on '$destroy', (event) ->
        SocketService.removeAllListeners()
