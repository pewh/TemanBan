app.factory 'FlashService', ($rootScope) ->
    $.noty.defaults =
        timeout: 2500
        theme: 'defaultTheme'
        dismissQueue: true
        template: '<div class="noty_message"><span class="noty_text"></span><div class="noty_close"></div></div>'
        animation:
            open: height: 'toggle'
            close: height: 'toggle'
            easing: 'swing'
            speed: 500
        callback: ->
            onShow: ->
            afterShow: ->
            onClose: ->
            afterClose: ->

    return {
        info: (message) ->
            noty
                text: message
                type: 'information'
                layout: 'bottom'
                closeWith: ['click', 'hover']
        error: (message) ->
            noty
                text: message
                type: 'error'
                layout: 'bottom'
                closeWith: ['click', 'hover']
        confirm: (message, callback) ->
            noty
                text: message
                type: 'confirm'
                layout: 'top'
                buttons: [
                    addClass: 'btn btn-primary'
                    text: 'Yes'
                    onClick: ($noty) ->
                        callback()
                        $noty.close()
                ,
                    addClass: 'btn btn-danger'
                    text: 'No'
                    onClick: ($noty) -> $noty.close()
                ]
    }
