_ = require 'lodash'
db = require './db'

resources = [
    users: db.UserModel
,
    items: db.ItemModel
,
    suppliers: db.SupplierModel
,
    customers: db.CustomerModel
,
    users: db.UserModel
]

_.forEach resources, (resource) ->
    _.forIn resource, (model, controller) ->
        exports[controller] =
            retrieve: (req, res) ->
                if req.params.id?
                    db.show
                        res: res
                        model: model
                        id: req.params.id
                else
                    db.index
                        res: res
                        model: model
                        populateField: 'supplier_id'

            create: (req, res) ->
                fields = _.keys(req.body)
                values = _.map fields, (field) -> req.body[field]
                content = _.zipObject(fields, values)

                db.create
                    res: res
                    model: model
                    body: content

            update: (req, res) ->
                fields = _.keys(req.body)
                values = _.map fields, (field) -> req.body[field]
                content = _.zipObject(fields, values)

                db.update
                    res: res
                    model: model
                    id: req.params.id
                    replace: (data) -> data = content

            patch: (req, res) ->
                db.update
                    res: res
                    model: model
                    id: req.body.pk
                    replace: (data) -> data[req.body.name] = req.body.value

            delete: (req, res) ->
                db.destroy
                    res: res
                    model: model
                    id: req.params.id

exports.credentials = (req, res) ->
    db.search
        res: res
        model: db.UserModel
        criteria:
            username: req.body.username
            password: req.body.password
