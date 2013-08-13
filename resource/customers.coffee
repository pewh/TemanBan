sql = require './sql'

exports.index = (req, res) ->
    sql.execute res, 'SELECT * FROM Customer'

exports.create = (req, res) ->
    query = """
            INSERT INTO Customer(name, address, contact) VALUES (
                '#{req.body.name}',
                '#{req.body.address}',
                '#{req.body.contact}'
            )
            """
    sql.execute res, query

exports.show = (req, res) ->
    sql.execute res, "SELECT * FROM Customer WHERE id = #{req.params.customer}"

exports.update = (req, res) ->
    params = []
    params.push "#{key} = '#{val}'" for key, val of req.body
    set = params.join(', ')
    sql.execute res, "UPDATE Customer SET #{set} WHERE id = #{req.params.customer}"

exports.destroy = (req, res) ->
    sql.execute res, "DELETE FROM Customer WHERE id = #{req.params.customer}"
