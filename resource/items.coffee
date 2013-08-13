sql = require './sql'

exports.index = (req, res) ->
    sql.execute res, 'SELECT * FROM Item'

exports.create = (req, res) ->
    query = """
            INSERT INTO Item(name, stock, purchase_price, sales_price) VALUES (
                '#{req.body.name}',
                #{req.body.stock},
                #{req.body.purchase_price},
                #{req.body.sales_price}
            )
            """
    sql.execute res, query

exports.show = (req, res) ->
    sql.execute res, "SELECT * FROM Item WHERE id = #{req.params.item}"

exports.update = (req, res) ->
    params = []
    params.push "#{key} = '#{val}'" for key, val of req.body
    set = params.join(', ')
    sql.execute res, "UPDATE Item SET #{set} WHERE id = #{req.params.item}"

exports.destroy = (req, res) ->
    sql.execute res, "DELETE FROM Item WHERE id = #{req.params.item}"
