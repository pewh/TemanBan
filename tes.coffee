_ = require 'lodash'
db = {}

resources = [
    users: 'db.UserModel'
,
    items: 'db.ItemModel'
,
    suppliers: 'db.SupplierModel'
,
    customers: 'db.CustomerModel'
,
    purchase_invoices: 'db.PurchaseInvoiceModel'
,
    sales_invoices: 'db.SalesInvoiceModel'
]

_.forEach resources, (resource) ->
    _.forIn resource, (model, controller) ->
        console.log """
            exports.#{controller} =
                retrieve: (req, res) ->
                    if req.params.id?
                        db.show
                            res: res
                            model: #{model}
                            id: req.params.id
                    else
                        db.index
                            res: res
                            model: #{model}
                            populateField: ['suppliers', 'details.item', 'details.item.supplier_id']

                create: (req, res) ->
                    fields = _.keys(req.body)
                    values = _.map fields, (field) -> req.body[field]
                    content = _.zipObject(fields, values)

                    db.create
                        res: res
                        model: #{model}
                        body: content

                update: (req, res) ->
                    fields = _.keys(req.body)
                    values = _.map fields, (field) -> req.body[field]
                    content = _.zipObject(fields, values)

                    db.update
                        res: res
                        model: #{model}
                        id: req.params.id
                        replace: (data) -> data = content

                patch: (req, res) ->
                    db.update
                        res: res
                        model: #{model}
                        id: req.body.pk
                        replace: (data) -> data[req.body.name] = req.body.value

                delete: (req, res) ->
                    db.destroy
                        res: res
                        model: #{model}
                        id: req.params.id

        """

