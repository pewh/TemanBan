sql = require './sql'

exports.index = (req, res) ->
    sql.execute res, 'SELECT * FROM User'

exports.create = (req, res) ->
    query = """
            INSERT INTO User(username, password, role)
            VALUES ('#{req.body.username}', '#{req.body.password}', '#{req.body.role}')
            """
    sql.execute res, query

exports.show = (req, res) ->
    sql.execute res, "SELECT * FROM User WHERE id = #{req.params.user}"

exports.update = (req, res) ->
    params = []
    params.push "#{key} = '#{val}'" for key, val of req.body
    set = params.join(', ')
    sql.execute res, "UPDATE User SET #{set} WHERE id = #{req.params.user}"

exports.destroy = (req, res) ->
    sql.execute res, "DELETE FROM User WHERE id = #{req.params.user}"
