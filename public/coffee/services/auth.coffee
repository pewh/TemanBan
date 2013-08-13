app.factory 'SessionService', ->
    get: (key) -> sessionStorage.getItem key
    set: (key, val) -> sessionStorage.setItem key, val
    unset: (key) -> sessionStorage.removeItem key


app.factory 'AuthenticationService', ($rootScope, $location, $http, SessionService, FlashService) ->
    login: (credentials) ->
        $http.post('/auth/login', credentials).success (data) ->
            SessionService.set 'authenticated', true
            location.replace '/' if data.length
        .error (message) -> FlashService.error 'Username atau password salah'
    logout: -> SessionService.unset 'authenticated'
    isLoggedIn: -> SessionService.get 'authenticated'
