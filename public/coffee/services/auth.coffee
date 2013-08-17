app.factory 'SessionService', ->
    get: (key) -> sessionStorage.getItem key
    set: (key, val) -> sessionStorage.setItem key, val
    unset: (key) -> sessionStorage.removeItem key


app.factory 'AuthenticationService', ($rootScope, $location, $http, SessionService, FlashService) ->
    login: (credentials) ->
        $http.post('/auth/login', credentials).success (data) ->
            if data.length
                SessionService.set 'authenticated', true
                SessionService.set 'username', credentials.username
                SessionService.set 'role', credentials.role
                location.replace '/'
            else
                FlashService.error 'Username atau password salah'
    logout: ->
        SessionService.unset 'authenticated'
        SessionService.unset 'username'
        SessionService.unset 'role'
    isLoggedIn: ->
        SessionService.get 'authenticated'
    currentUser: ->
        SessionService.get 'username'
    currentRole: ->
        SessionService.get 'role'
