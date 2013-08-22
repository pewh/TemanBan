app.factory 'MomentService', ($rootScope) ->
    currentTime: -> moment().format('HH:mm:ss')
