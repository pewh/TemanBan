app.factory 'CustomerResource', ($resource) ->
    $resource '/api/customers/:id', id: '@_id',
        update: method: 'PUT'
