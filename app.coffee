express     = require('express')
app         = express()
server      = require('http').createServer(app)
io          = require('socket.io').listen(server)
resources   = require('./resources')

# CONFIG
app.set 'port', process.env.PORT || 8000
app.use express.bodyParser()
app.use express.static('public')
app.use express.errorHandler()

models = ['user', 'item', 'supplier', 'customer', 'purchase_invoice', 'sales_invoice']

# ROUTER
models.map (model) ->
    app.post   "/api/#{model}s",     resources["#{model}s"].create
    app.get    "/api/#{model}s",     resources["#{model}s"].retrieve
    app.get    "/api/#{model}s/:id", resources["#{model}s"].retrieve
    app.put    "/api/#{model}s/:id", resources["#{model}s"].update
    app.patch  "/api/#{model}s",     resources["#{model}s"].patch
    app.delete "/api/#{model}s/:id", resources["#{model}s"].delete

app.get  '/api/group/suppliers',     resources.helper.populateSuppliers
app.get  '/api/suppliers/:id/items', resources.helper.populateSupplierItems
app.post '/auth/login',              resources.helper.credentials

# SOCKETS
io.sockets.on 'connection', (socket) ->
    models.map (resource) ->
        socket.on "create:#{resource}", (data) -> io.sockets.emit("create:#{resource}", data)
        socket.on "update:#{resource}", (data) -> io.sockets.emit("update:#{resource}", data)
        socket.on "delete:#{resource}", (data) -> io.sockets.emit("delete:#{resource}", data)
        socket.on "search:#{resource}", (data) -> socket.emit("search:#{resource}", data)

# START SERVER
server.listen app.get('port'), -> console.log 'Running on http://localhost:8000'
