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

server.listen app.get('port'), -> console.log 'Running on http://localhost:8000'

io.sockets.on 'connection', (socket) ->
    ['item', 'supplier', 'customer'].map (resource) ->
        socket.on "create:#{resource}", (data) -> io.sockets.emit("create:#{resource}", data)
        socket.on "update:#{resource}", (data) -> io.sockets.emit("update:#{resource}", data)
        socket.on "delete:#{resource}", (data) -> io.sockets.emit("delete:#{resource}", data)
        socket.on "search:#{resource}", (data) -> socket.emit("search:#{resource}", data)
