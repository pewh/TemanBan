mysql = require 'mysql'

connection = mysql.createConnection
    host: 'localhost'
    user: 'root'
    database: 'TemanBan'

module.exports.execute = (res, query, flash) ->
        if connection
            connection.query query, (error, rows, fields) ->
                if error
                    switch error.code
                        when 'ER_DUP_ENTRY' then res.json flash: 'Data sudah ada'
                        else res.json flash: ''
                else
                    if rows.insertId > 0
                        res.json flash: 'Data berhasil ditambah'
                    else if rows.insertId == 0
                        if rows.message
                            res.json flash: 'Data berhasil diedit'
                        else
                            res.json flash: 'Data berhasil dihapus'
                    else
                        res.json rows
