View = require './view'

module.exports = class Image extends View
    tagName: 'img'

    className: 'incito__image-view incito--lazyload'
    
    render: ->
        # Avoid grey border around image.
        @el.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'

        if typeof @attrs.src is 'string'
            @el.setAttribute 'data-src', @attrs.src
        
        if typeof @attrs.label is 'string'
            @el.setAttribute 'alt', @attrs.label

        @