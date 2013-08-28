app.filter 'currency', ->
    return (number, currencyCode) ->
        currency =
            IDR:
                sign: 'Rp'
                thousand: '.'
                decimal: ','
                suffix: ',-'
        if number
            chosenCurrency = currency[currencyCode]
            return accounting.formatMoney(
                number,
                chosenCurrency.sign,
                chosenCurrency.decimal,
                chosenCurrency.thousand
            ) + chosenCurrency.suffix
        else
            return '-'

app.filter 'stripzero', ->
    return (string) ->
        return string or '-'
