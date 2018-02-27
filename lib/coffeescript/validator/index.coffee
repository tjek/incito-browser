{ Validator } = require 'jsonschema'
isColor = require 'is-color'
{ isUri } = require 'valid-url'
schemas = require './schemas/incito'

v = new Validator()
v.customFormats.cssColor = (input) ->
    (input is undefined) or isColor input
v.customFormats.url = (input) ->
    (input is undefined) or isUri input

for schema in schemas
    v.addSchema schema, schema.id

[incitoSchema] = schemas

validate = (payload) ->
    v.validate payload, incitoSchema

module.exports = validate