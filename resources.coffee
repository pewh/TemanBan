_ = require 'lodash'
async = require 'async'
db = require './db'
moment = require 'moment'

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

    findSuppliersByItems: (req, res) ->
        db.ItemModel.find({ suppliers: req.params.id }).exec (err, data) ->
            if err then res.json(err, 500) else res.json(data)

    populateMostWantedStock: (req, res) ->
        db.SalesInvoiceModel.find(
            created_at:
                $gt: moment().subtract('week', 2)
        ).populate('details.item')
        .exec (err, data) ->
            res.json data

    populatePurchaseTransaction: (req, res) ->
        getTotalPurchaseCost = (obj) ->
            details = _.pluck(obj, 'details')[0]

            _.reduce details, (prev, key) ->
                prev + (key.quantity * key.item.purchase_price)
            , 0

        getTotalSalesCost = (obj) ->
            details = _.flatten( _.pluck(obj, 'details') )

            _.reduce details, (prev, key) ->
                prev + (key.quantity * key.item.sales_price)
            , 0

        findCriteria = {}

        if req.params.startDate? and req.params.endDate?
            findCriteria =
                created_at:
                    $gte: req.params.startDate
                    $lt: req.params.endDate

        # Find max & min date based on range date
        async.parallel([
            (callback) ->
                db.PurchaseInvoiceModel.find(findCriteria).exec (err, data) ->
                    callback(null, data)
            (callback) ->
                db.SalesInvoiceModel.find(findCriteria).exec (err, data) ->
                    callback(null, data)
        ], (err, result) ->
            flattenArray = _.flatten(result)
            createdAtValues = _.pluck(flattenArray, 'created_at')
            timestampValues = _.map createdAtValues, (date) ->
                dateWithoutTime = new Date(date).setHours(0,0,0,0)
                return Date.UTC.apply(this, moment(dateWithoutTime).toArray())

            # get min & max date
            minDate = moment(_.min(timestampValues))
            maxDate = moment(_.max(timestampValues))

            # create range based on min & max date
            currentDate = minDate
            dates = []

            while currentDate <= maxDate
                dates.push
                    x: '' + currentDate.unix() + '000'
                    y: 0
                currentDate.add('day', 1)

            # ASYNC for get transaction history
            async.parallel([
                (callback) ->
                    db.PurchaseInvoiceModel.find(findCriteria)
                        .populate('details.item')
                        .sort('created_at')
                        .exec (err, data) ->
                            groupedData = _.groupBy data, (obj) ->
                                date = new Date(obj.created_at).setHours(0,0,0,0)
                                return Date.UTC.apply(this, moment(date).toArray())

                            keyData = _.keys(groupedData)
                            valData = _.values(groupedData).map(getTotalPurchaseCost)
                            zippedData = _.zip(keyData, valData)

                            result = _.map zippedData, (data) ->
                                _.object ['x', 'y'], data

                            callback(null,
                                name: 'Beli'
                                data: result
                            )

                (callback) ->
                    db.SalesInvoiceModel.find(findCriteria)
                        .populate('details.item')
                        .sort('created_at')
                        .exec (err, data) ->
                            groupedData = _.groupBy data, (obj) ->
                                date = new Date(obj.created_at).setHours(0, 0, 0, 0)
                                return Date.UTC.apply(this, moment(date).toArray())

                            keyData = _.keys(groupedData)
                            valData = _.values(groupedData).map(getTotalSalesCost)
                            zippedData = _.zip(keyData, valData)

                            result = _.map zippedData, (data) ->
                                _.object ['x', 'y'], data

                            callback(null,
                                name: 'Jual'
                                data: result
                            )
            ], (err, results) ->
                _.map results, (result) ->
                    _.each dates, (date) ->
                        result.data.push(date) unless _.contains(result.data, date)

                    result.data = _.sortBy result.data, (resultData) -> resultData.x

                    result.data = _.uniq result.data, 'x'

                res.json results
            )
        )


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

    patch: (req, res) ->
        db.patch
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

    patch: (req, res) ->
        db.patch
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

    patch: (req, res) ->
        db.patch
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

    patch: (req, res) ->
        db.patch
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
                populateField: ['details.item', 'supplier']
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
        #values = _.map fields, (field) -> req.body[field]
        #content = _.zipObject(fields, values)

        db.update
            res: res
            model: db.PurchaseInvoiceModel
            id: req.params.id
            replace: (data) ->
                fields.forEach (field) ->
                    data[field] = req.body[field]
                return data

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
