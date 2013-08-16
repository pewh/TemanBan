db = require './db'

exports.index = (req, res) ->
    db.index
        res: res
        model: db.ItemModel
        populateField: 'supplier_id'

exports.show = (req, res) ->
    db.show
        res: res
        model: db.ItemModel
        id: req.params.item

exports.create = (req, res) ->
    db.create
        res: res
        model: db.ItemModel
        body:
            name: req.body.name
            stock: req.body.stock
            purchase_price: req.body.purchase_price
            sales_price: req.body.sales_price
            supplier_id: req.body.supplier_id

exports.update = (req, res) ->
    db.update
        res: res
        model: db.ItemModel
        id: req.params.item
        replace: (data) ->
            data.name = req.body.name
            data.stock = req.body.stock
            data.purchase_price = req.body.purchase_price
            data.sales_price = req.body.sales_price
            data.supplier_id = req.body.supplier_id

exports.destroy = (req, res) ->
    db.destroy
        res: res
        model: db.ItemModel
        id: req.params.item
