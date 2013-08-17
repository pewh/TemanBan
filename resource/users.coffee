db = require './db'

exports.index = (req, res) ->
    db.index
        res: res
        model: db.UserModel

exports.show = (req, res) ->
    db.show
        res: res
        model: db.UserModel
        id: req.params.user

exports.create = (req, res) ->
    db.create
        res: res
        model: db.UserModel
        body:
            username: req.body.username
            password: req.body.password
            role: req.body.contact

exports.update = (req, res) ->
    db.update
        res: res
        model: db.UserModel
        id: req.params.user
        replace: (data) ->
            data.username = req.body.username
            data.password = req.body.password
            data.role = req.body.role

exports.destroy = (req, res) ->
    db.destroy
        res: res
        model: db.UserModel
        id: req.params.user
