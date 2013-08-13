app.filter 'rupiah', -> (string) ->
    if string
        return accounting.formatMoney(parseInt(string), 'Rp ', '.', '.') + ',-'
    else
        return '-'
