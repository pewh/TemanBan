mysql = require 'mysql'

connection = mysql.createConnection
    host: 'localhost'
    user: 'root'
    database: 'TemanBan'

module.exports.credentials = (req, res) ->
    if connection
        query = """
                SELECT * FROM User
                WHERE username = '#{req.body.username}'
                AND password = '#{req.body.password}'
                """
        connection.query query, (error, rows, fields) ->
            if rows.length
                res.json rows
            else
                res.json flash: 'Username atau password salah', 500
