mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/TemanBan'
Schema = mongoose.Schema

User = new Schema
    username:
        type: String
        required: true
        unique: true
    password:
        type: String
        required: true
    authority:
        type: String
        enum: ['manager', 'staff', 'commissioner']

Item = new Schema
    name:
        type: String
        required: true
        unique: true
    stock:
        type: Number
        required: true
        min: 0
    purchase_price:
        type: Number
        required: true
        min: 0
    sales_price:
        type: Number
        required: true
        min: 0
    supplier_id:
        type: Schema.Types.ObjectId
        ref: 'Supplier'
        required: true

Supplier = new Schema
    name:
        type: String
        required: true
    address:
        type: String
    contact:
        type: String

Customer = new Schema
    name:
        type: String
        required: true
    address:
        type: String
    contact:
        type: String

module.exports =
    index: (options) ->
        model = options.model.find (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

        model.populate(options.populateField) if options.populateField?

    show: (options) ->
        options.model.findById options.id, (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

    search: (options) ->
        options.model.find options.criteria, (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

    create: (options) ->
        model = new options.model(options.body)
        model.save (err) =>
            if err then options.res.json(err, 500) else options.res.json(model)

    update: (options) ->
        options.model.findById options.id, (err, data) ->
            options.replace(data)
            data.save (err) ->
                if err then options.res.json(err, 500) else options.res.json(data)

    destroy: (options) ->
        options.model.findById options.id, (err, data) ->
            data? and data.remove (err) ->
                if err then options.res.json(err, 500) else options.res.json(data)

    UserModel: mongoose.model('User', User)
    ItemModel: mongoose.model('Item', Item)
    SupplierModel: mongoose.model('Supplier', Supplier)
    CustomerModel: mongoose.model('Customer', Customer)
