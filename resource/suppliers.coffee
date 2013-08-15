db = require './db'

exports.index = (req, res) ->
    db.index
        res: res
        model: db.SupplierModel

exports.show = (req, res) ->
    db.show
        res: res
        model: db.SupplierModel
        id: req.params.supplier

exports.create = (req, res) ->
    db.create
        res: res
        model: db.SupplierModel
        body:
            name: req.body.name
            address: req.body.address
            contact: req.body.contact

exports.update = (req, res) ->
    db.update
        res: res
        model: db.SupplierModel
        id: req.params.supplier
        replace: (data) ->
            data.name = req.body.name
            data.address = req.body.address
            data.contact = req.body.contact

exports.destroy = (req, res) ->
    db.destroy
        res: res
        model: db.SupplierModel
        id: req.params.supplier
