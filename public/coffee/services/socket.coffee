app.factory 'SocketService', ($rootScope, $timeout) ->
    socket = io.connect()

    return {
        on: (eventName, callback) ->
            socket.on eventName, ->
                args = arguments
                $timeout ->
                    callback.apply socket, args
                , 0
        emit: (eventName, data, callback) ->
            socket.emit eventName, data, ->
                args = arguments
                callback.apply(socket, args) if callback
        removeAllListeners: -> socket.removeAllListeners()
    }
