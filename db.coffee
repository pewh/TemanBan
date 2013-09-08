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
    role:
        type: String
        enum: ['manager', 'staff', 'commissioner']

Supplier = new Schema
    name:
        type: String
        required: true
    address:
        type: String
    contact:
        type: String

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
    suppliers:
        type: Schema.Types.ObjectId
        ref: 'Supplier'
        required: true

Customer = new Schema
    name:
        type: String
        required: true
    address:
        type: String
    contact:
        type: String

PurchaseInvoiceDetail = new Schema
    item:
        type: Schema.Types.ObjectId
        ref: 'Item'
        required: true
    quantity:
        type: Number
        required: true
        min: 1

PurchaseInvoice = new Schema
    created_at: Date
    code:
        type: String
        required: true
        unique: true
    supplier:
        type: Schema.Types.ObjectId
        ref: 'Supplier'
        required: true
    details: [PurchaseInvoiceDetail]

SalesInvoiceDetail = new Schema
    item:
        type: Schema.Types.ObjectId
        ref: 'Item'
        required: true
    quantity:
        type: Number
        required: true
        min: 1

SalesInvoice = new Schema
    created_at:
        type: Date
        required: true
        unique: true
    code:
        type: String
        required: true
    customer:
        type: Schema.Types.ObjectId
        ref: 'Customer'
        required: true
    discount:
        type: Number
        min: 0
        max: 100
    details: [SalesInvoiceDetail]


module.exports =
    index: (options) ->
        model = options.model.find (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

        if options.populateField?
            options.populateField.forEach (field) ->
                model.populate(field)

    show: (options) ->
        model = options.model.findById options.id, (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

        if options.populateField?
            options.populateField.forEach (field) ->
                model.populate(field)

    search: (options) ->
        options.model.find options.criteria, (err, data) ->
            if err then options.res.json(err, 500) else options.res.json(data)

    create: (options) ->
        model = new options.model(options.body)
        model.save (err) =>
            if err then options.res.json(err, 500) else options.res.json(model)

    update: (options) ->
        options.model.findById options.id, (err, data) ->
            updateddata = options.replace(data)

            updateddata.save (err) ->
                if err then options.res.json(err, 500) else options.res.json(updateddata)

    patch: (options) ->
        options.model.findById options.id, (err, data) ->
            options.replace(data)

            data.save (err) ->
                if err then options.res.json(err, 500) else options.res.json(updateddata)

    destroy: (options) ->
        options.model.findById options.id, (err, data) ->
            data? and data.remove (err) ->
                if err then options.res.json(err, 500) else options.res.json(data)

    UserModel: mongoose.model('User', User)
    ItemModel: mongoose.model('Item', Item)
    SupplierModel: mongoose.model('Supplier', Supplier)
    CustomerModel: mongoose.model('Customer', Customer)
    PurchaseInvoiceModel: mongoose.model('PurchaseInvoice', PurchaseInvoice)
    SalesInvoiceModel: mongoose.model('SalesInvoice', SalesInvoice)
