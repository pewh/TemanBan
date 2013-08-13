app.factory 'CustomerResource', ($resource) ->
    $resource '/api/customers/:id', id: '@id',
        get:
            method: 'GET'
            isArray: true
        update:
            method: 'PUT'
