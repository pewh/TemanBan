app.filter 'rupiah', -> (string) ->
    if string
        return accounting.formatMoney(parseInt(string, 10), 'Rp ', '.', '.') + ',-'
    else
        return '-'
