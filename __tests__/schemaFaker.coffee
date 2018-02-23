jsf = require 'json-schema-faker'
validate = require '../lib/coffeescript/validator'
incitoSchema = require '../lib/coffeescript/validator/schemas/incito'

randomEnum = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]

# TODO: Make this better
fakerSchema = incitoSchema.shift()
fakerSchema.definitions = {}
for schema in incitoSchema
  fakerSchema.definitions[schema.id.substr(1)] = schema

schema = JSON.stringify schema, null, 2
schema = schema.replace(/\$ref": "/g, '$ref": "#/definitions')
schema = JSON.parse schema
console.info  schema


jsf.format 'viewClass', -> randomEnum ['View', 'FragView', 'ImageView', 'TextView', 'VideoEmbedView', 'LinearLayout', 'AbsoluteLayout', 'FlexLayout']
jsf.format 'stroke', -> randomEnum ['solid', 'dotted', 'dashed']
jsf.format 'tileMode', -> randomEnum ['repeat_x', 'repeat_y', 'repeat']
jsf.format 'cssColor', -> 'red' # TODO: Generate other colors as well, though JSDom does not support much
jsf.format 'url', -> 'https://www.youtube.com/embed/something'

test 'Faked schema validation', ->
    expect(true).toBe(true)
    jsf.resolve(fakerSchema).then (data) ->
            console.info 'data', data
        .catch (e) ->
            console.error e
    
    return