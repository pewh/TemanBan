express     = require('express')
app         = express()
gzippo      = require('gzippo')
server      = require('http').createServer(app)
io          = require('socket.io').listen(server)
resources   = require('./resources')
restful     = require('./restful')

# CONFIG
app.set 'port', process.env.PORT || 8000
app.use express.bodyParser()
app.use gzippo.staticGzip('public')
app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
)

models = [
    name: 'user'
    allow: ['GET', 'POST', 'PUT', 'DELETE']
,
    name: 'item'
    allow: ['GET', 'POST', 'PATCH', 'DELETE']
,
    name: 'supplier'
    allow: ['GET', 'POST', 'PATCH', 'DELETE']
,
    name: 'customer'
    allow: ['GET', 'POST', 'PATCH', 'DELETE']
,
    name: 'purchase_invoice'
    allow: ['GET', 'POST', 'PUT', 'DELETE']
,
    name: 'sales_invoice'
    allow: ['GET', 'POST', 'PUT', 'DELETE']
]

restful.config(
    app: app
    resources: resources
    models: models
).run()


# CUSTOM ROUTER
app.get  '/api/group/suppliers',         resources.helper.populateSuppliers
app.get  '/api/suppliers/:id/items',     resources.helper.findSuppliersByItems
app.get  '/api/suppliers-for-items/:id', resources.helper.findSuppliersByItems
app.post '/auth/login',                  resources.helper.credentials

app.get  '/api/purchase/range/:startDate?/:endDate?', resources.helper.populatePurchaseTransaction
app.get  '/api/stock/items', resources.helper.populateMostWantedStock

# SOCKETS
io.sockets.on 'connection', (socket) ->
    models.forEach (resource) ->
        socket.on "create:#{resource.name}", (data) -> io.sockets.emit("create:#{resource.name}", data)
        socket.on "update:#{resource.name}", (data) -> io.sockets.emit("update:#{resource.name}", data)
        socket.on "delete:#{resource.name}", (data) -> io.sockets.emit("delete:#{resource.name}", data)
        socket.on "search:#{resource.name}", (data) -> socket.emit("search:#{resource.name}", data)

# START SERVER
server.listen app.get('port'), -> console.log 'Running on http://localhost:8000'
