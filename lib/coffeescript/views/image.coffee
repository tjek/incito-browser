View = require './view'
utils = require '../utils'

module.exports = class Image extends View
    tagName: 'img'

    className: 'incito__image-view incito--lazyload'
    
    render: ->
        if utils.isDefinedStr @attrs.src
            @el.setAttribute 'data-src', @attrs.src
        
        if utils.isDefinedStr @attrs.label
            @el.setAttribute 'alt', @attrs.label

        @