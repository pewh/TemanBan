express = require 'express'
app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

app.set 'port', process.env.PORT || 8000
app.use express.bodyParser()
app.use express.static('public')
app.use express.errorHandler()

resources = require('./resources')

app.post    '/api/items',         resources.items.create
app.get     '/api/items',         resources.items.retrieve
app.get     '/api/items/:id',     resources.items.retrieve
app.put     '/api/items/:id',     resources.items.update
app.patch   '/api/items',         resources.items.patch
app.delete  '/api/items/:id',     resources.items.delete

app.post    '/api/suppliers',     resources.suppliers.create
app.get     '/api/suppliers',     resources.suppliers.retrieve
app.get     '/api/suppliers/:id', resources.suppliers.retrieve
app.put     '/api/suppliers/:id', resources.suppliers.update
app.patch   '/api/suppliers',     resources.suppliers.patch
app.delete  '/api/suppliers/:id', resources.suppliers.delete

app.post    '/api/customers',     resources.customers.create
app.get     '/api/customers',     resources.customers.retrieve
app.get     '/api/customers/:id', resources.customers.retrieve
app.put     '/api/customers/:id', resources.customers.update
app.patch   '/api/customers',     resources.customers.patch
app.delete  '/api/customers/:id', resources.customers.delete

app.post    '/auth/login',        resources.credentials
###

app.resource 'api/users', require './resource/users'
app.resource 'api/items', require './resource/items'
app.resource 'api/suppliers', require './resource/suppliers'
app.resource 'api/customers', require './resource/customers'
###

server.listen app.get('port'), -> console.log 'Running on http://localhost:8000'

io.sockets.on 'connection', (socket) ->
    # ITEM
    socket.on 'create:item', (data) -> io.sockets.emit('create:item', data)
    socket.on 'update:item', (data) -> io.sockets.emit('update:item', data)
    socket.on 'delete:item', (data) -> io.sockets.emit('delete:item', data)
    socket.on 'search:item', (data) -> socket.emit('search:item', data)
    # SUPPLIER
    socket.on 'create:supplier', (data) -> io.sockets.emit('create:supplier', data)
    socket.on 'update:supplier', (data) -> io.sockets.emit('update:supplier', data)
    socket.on 'delete:supplier', (data) -> io.sockets.emit('delete:supplier', data)
    socket.on 'search:supplier', (data) -> socket.emit('search:supplier', data)
    # CUSTOMER
    socket.on 'create:customer', (data) -> io.sockets.emit('create:customer', data)
    socket.on 'update:customer', (data) -> io.sockets.emit('update:customer', data)
    socket.on 'delete:customer', (data) -> io.sockets.emit('delete:customer', data)
    socket.on 'search:customer', (data) -> socket.emit('search:customer', data)
