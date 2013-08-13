app.factory 'ItemResource', ($resource) ->
    $resource '/api/items/:id', id: '@id',
        get:
            method: 'GET'
            isArray: true
        update:
            method: 'PUT'
