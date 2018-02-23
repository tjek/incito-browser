jsf = require 'json-schema-faker'
validate = require '../lib/coffeescript/validator'
fakerSchema = require './stubs/faker'

randomEnum = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]

console.info randomEnum ['View', 'FragView', 'ImageView', 'TextView', 'VideoEmbedView', 'LinearLayout', 'AbsoluteLayout', 'FlexLayout']
console.info randomEnum ['solid', 'dotted', 'dashed']
console.info randomEnum ['repeat_x', 'repeat_y', 'repeat']

jsf.format 'viewClass', -> randomEnum ['View', 'FragView', 'ImageView', 'TextView', 'VideoEmbedView', 'LinearLayout', 'AbsoluteLayout', 'FlexLayout']
jsf.format 'stroke', -> randomEnum ['solid', 'dotted', 'dashed']
jsf.format 'tileMode', -> randomEnum ['repeat_x', 'repeat_y', 'repeat']
jsf.format 'cssColor', -> 'red' # TODO: Generate other colors as well, though JSDom does not support much
jsf.format 'url', -> 'https://www.youtube.com/embed/something'

test 'Faked schema validation', ->
    expect(true).toBe(true)
    jsf.resolve(fakerSchema).then (data) ->
            console.info data
        .catch (e) ->
            console.error e
    
    return