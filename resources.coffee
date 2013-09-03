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
                        populateField: 'suppliers'

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

exports.helper =
    credentials: (req, res) ->
        db.search
            res: res
            model: db.UserModel
            criteria:
                username: req.body.username
                password: req.body.password

    populateSuppliers: (req, res) ->
        db.SupplierModel.find (err, data) ->
            if err
                res.json(err, 500)
            else
                # get selected key
                pluckedId = _.pluck data, '_id'
                ids = pluckedId.map (id) -> id: id

                pluckedName = _.pluck data, 'name'
                names = pluckedName.map (name) -> name: name

                # group keys & push to arrays
                suppliers = []

                [0...ids.length].forEach (i) ->
                    createdObj = _.assign ids[i], names[i]
                    suppliers.push createdObj

                # renaming key of collections

                map =
                    id: 'value'
                    name: 'text'

                compiledData = []

                _.each suppliers, (obj) ->
                    renamedObj = {}

                    _.each obj, (val, key) ->
                        key = map[key] || key
                        renamedObj[key] = val

                    compiledData.push renamedObj

                # throw output
                res.json compiledData
    populateSupplierItems: (req, res) ->
        db.ItemModel.find({ suppliers: req.params.id }).exec (err, data) -> res.json data
