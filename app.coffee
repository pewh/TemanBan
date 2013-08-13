express = require 'express'
Resource = require 'express-resource'
app = express()
auth = require './resource/auth'
server = require('http').createServer(app)
io = require('socket.io').listen(server)

app.configure ->
    app.use express.bodyParser()
    app.use express.static('public')

app.resource 'api/users', require './resource/users'
app.resource 'api/items', require './resource/items'
app.resource 'api/suppliers', require './resource/suppliers'
app.resource 'api/customers', require './resource/customers'
app.post '/auth/login', (req, res) -> auth.credentials(req, res)

server.listen 8000, -> console.log 'Running on http://localhost:8000'

io.sockets.on 'connection', (socket) ->
    # ITEM
    socket.on 'create:item', (data) -> io.sockets.emit('create:item', data)
    socket.on 'update:item', (data) -> io.sockets.emit('update:item', data)
    socket.on 'delete:item', (data) -> io.sockets.emit('delete:item', data)
    socket.on 'search:item', (data) -> socket.emit('search:item', data)
    #socket.on 'create:item', (data) -> io.sockets.emit('create:item', data)
    #socket.on 'update:item', (data) -> io.sockets.emit('update:item', data)
    #socket.on 'delete:item', (data) -> io.sockets.emit('delete:item', data)
    #socket.on 'search:item', (data) -> socket.emit('search:item', data)
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
