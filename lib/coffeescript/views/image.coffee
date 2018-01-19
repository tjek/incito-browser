View = require './view'

module.exports = class Image extends View
    tagName: 'img'

    className: 'incito__image-view incito--lazyload'
    
    render: ->
        if @attrs.src?
            @el.setAttribute 'data-src', @attrs.src

        @