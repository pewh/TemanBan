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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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
                populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

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

