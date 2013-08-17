db = require './db'
async = require 'async'
_ = require 'lodash'

exports.index = (req, res) ->
    db.SupplierModel.find (err, data) ->
        if err
            res.json(err)
        else
            insertionFn = []

            data.map (d) ->
                insertionFn.push (callback) ->
                    db.ItemModel.find supplier_id: d._id, (err, item) ->
                        callback null, item
                    return d

            async.parallel insertionFn, (err, results) ->
                _.map data, (d, i) ->
                    d.items = results[i]
                res.json data

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
