###
app.factory 'CustomerResource', (Restangular) ->
    $resource '/api/customers/:id', id: '@_id',
        update: method: 'PUT'
###
