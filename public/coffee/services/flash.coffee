app.factory 'FlashService', ($rootScope) ->
    toastr.options.onclick = -> toastr.clear()
    return toastr
