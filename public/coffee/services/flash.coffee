app.factory 'FlashService', ($rootScope, SupplierResource) ->
    humane.clickToClose = true
    humane.waitForMove = true

    return {
        log: (message, isQueue) ->
            humane.log message
        info: (message) ->
            humane.info = humane.spawn addnCls: 'humane-libnotify-info'
            humane.info message
        error: (message) ->
            humane.error = humane.spawn addnCls: 'humane-libnotify-error'
            humane.error message
    }
