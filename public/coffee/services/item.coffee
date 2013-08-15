app.factory 'ItemResource', ($resource) ->
    $resource '/api/items/:id', id: '@_id',
        update: method: 'PUT'
