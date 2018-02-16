{ Validator } = require 'jsonschema'
isColor = require 'is-color'
{ isUri } = require 'valid-url'
schemas = require './schemas/incito'

v = new Validator();
v.customFormats.cssColor = (input) ->
    (input is undefined) or isColor input

v.customFormats.viewClass = (input) ->
    input in [undefined, 'View', 'FragView', 'ImageView', 'TextView', 'VideoEmbedView', 'LinearLayout', 'AbsoluteLayout', 'FlexLayout']

v.customFormats.stroke = (input) ->
    input in [undefined, 'solid', 'dotted', 'dashed']

v.customFormats.tileMode = (input) ->
    input in [undefined, 'repeat_x', 'repeat_y', 'repeat']

v.customFormats.url = (input) ->
    (input is undefined) or isUri input

for schema in schemas
    v.addSchema schema, schema.id

[incitoSchema] = schemas

validate = (payload) ->
    v.validate payload, incitoSchema

module.exports = validate