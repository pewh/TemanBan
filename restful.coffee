app = undefined
resources = undefined
models = undefined
urlPrefix = ''

module.exports.config = (options) ->
    app = options.app
    resources = options.resources
    models = options.models
    urlPrefix = options.urlPrefix
    return this

actions =
    GET: (model) ->
        app.get "/api/#{model}s", resources["#{model}s"].retrieve
        app.get "/api/#{model}s/:id", resources["#{model}s"].retrieve

    POST: (model) ->
        app.post "/api/#{model}s", resources["#{model}s"].create

    PUT: (model) ->
        app.put "/api/#{model}s/:id", resources["#{model}s"].update

    PATCH: (model) ->
        app.patch "/api/#{model}s", resources["#{model}s"].patch

    DELETE: (model) ->
        app.delete "/api/#{model}s/:id", resources["#{model}s"].delete

module.exports.run = ->
    if app? and resources? and models? and models.length
        models.forEach (model) ->
            model.allow.forEach (allow) ->
                actions[allow](model.name)
