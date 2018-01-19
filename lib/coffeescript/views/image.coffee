View = require './view'

module.exports = class Image extends View
    tagName: 'img'

    className: 'incito__image-view incito--lazyload'
    
    render: ->
        # Avoid grey border around image.
        @el.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'

        if @attrs.src?
            @el.setAttribute 'data-src', @attrs.src

        @