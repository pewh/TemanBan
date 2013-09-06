_ = require 'lodash'
db = require './db'

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

exports.users =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.UserModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.UserModel

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.UserModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.UserModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.UserModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.UserModel
            id: req.params.id

exports.items =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.ItemModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.ItemModel
                populateField: ['suppliers']

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.ItemModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.ItemModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.ItemModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.ItemModel
            id: req.params.id

exports.suppliers =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.SupplierModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.SupplierModel

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.SupplierModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.SupplierModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.SupplierModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.SupplierModel
            id: req.params.id

exports.customers =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.CustomerModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.CustomerModel

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.CustomerModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.CustomerModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.CustomerModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.CustomerModel
            id: req.params.id

exports.purchase_invoices =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.PurchaseInvoiceModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.PurchaseInvoiceModel
                populateField: ['details.item', 'supplier']

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.PurchaseInvoiceModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.PurchaseInvoiceModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.PurchaseInvoiceModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.PurchaseInvoiceModel
            id: req.params.id

exports.sales_invoices =
    retrieve: (req, res) ->
        if req.params.id?
            db.show
                res: res
                model: db.SalesInvoiceModel
                id: req.params.id
        else
            db.index
                res: res
                model: db.SalesInvoiceModel
                populateField: ['details.item', 'customer']

    create: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.create
            res: res
            model: db.SalesInvoiceModel
            body: content

    update: (req, res) ->
        fields = _.keys(req.body)
        values = _.map fields, (field) -> req.body[field]
        content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.SalesInvoiceModel
            id: req.params.id
            replace: (data) -> data = content

    patch: (req, res) ->
        db.update
            res: res
            model: db.SalesInvoiceModel
            id: req.body.pk
            replace: (data) -> data[req.body.name] = req.body.value

    delete: (req, res) ->
        db.destroy
            res: res
            model: db.SalesInvoiceModel
            id: req.params.id
