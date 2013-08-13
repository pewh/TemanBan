app.factory 'SupplierResource', ($resource) ->
    $resource '/api/suppliers/:id', id: '@id',
        get:
            method: 'GET'
            isArray: true
        update:
            method: 'PUT'
