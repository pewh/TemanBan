db = require './db'

module.exports.credentials = (req, res) ->
    db.search
        res: res
        model: db.UserModel
        criteria:
            username: req.body.username
            password: req.body.password
