app.factory 'SupplierResource', ($resource) ->
    $resource '/api/suppliers/:id', id: '@_id',
        update: method: 'PUT'
