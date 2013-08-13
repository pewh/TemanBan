sql = require './sql'

exports.index = (req, res) ->
    sql.execute res, 'SELECT * FROM Supplier'

exports.create = (req, res) ->
    query = """
            INSERT INTO Supplier(name, address, contact) VALUES (
                '#{req.body.name}',
                '#{req.body.address}',
                '#{req.body.contact}'
            )
            """
    sql.execute res, query

exports.show = (req, res) ->
    sql.execute res, "SELECT * FROM Supplier WHERE id = #{req.params.supplier}"

exports.update = (req, res) ->
    params = []
    params.push "#{key} = '#{val}'" for key, val of req.body
    set = params.join(', ')
    sql.execute res, "UPDATE Supplier SET #{set} WHERE id = #{req.params.supplier}"

exports.destroy = (req, res) ->
    sql.execute res, "DELETE FROM Supplier WHERE id = #{req.params.supplier}"
