jsf = require 'json-schema-faker'
validate = require '../lib/coffeescript/validator'
incitoSchema = require '../lib/coffeescript/validator/schemas/incito'

randomEnum = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]

# TODO: Make this better, traversing the object instead
fakerSchema = incitoSchema.shift()
fakerSchema.definitions = {}
for schema in incitoSchema
    fakerSchema.definitions[schema.id.substr(1)] = schema

fakerSchema = JSON.stringify fakerSchema, null, 2
fakerSchema = fakerSchema.replace(/\$ref": "/g, '$ref": "#/definitions')
fakerSchema = JSON.parse fakerSchema

jsf.format 'cssColor', -> 'red' # TODO: Generate other colors as well, though JSDom does not support much
jsf.format 'url', -> 'https://www.youtube.com/embed/something'
jsf.option
    alwaysFakeOptionals: true   # TODO: Ultimately set to false, this is for debug purposes
    requiredOnly: false

# TODO: Generation is hitting https://github.com/json-schema-faker/json-schema-faker/issues/345
# jsf is not generating deep nested views atm
test 'Faked schema validation', ->
    jsf.resolve(fakerSchema).then (data) ->
        validation = validate data
    
    return