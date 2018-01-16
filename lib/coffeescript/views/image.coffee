View = require './view'

module.exports = class Image extends View
    tagName: 'img'

    className: 'incito__image-view'
    
    render: ->
        if @attrs.src?
            @el.src = @attrs.src

        @