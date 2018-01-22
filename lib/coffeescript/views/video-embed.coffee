View = require './view'

module.exports = class FlexLayout extends View
    className: 'incito__video-embed-view'

    render: ->
        iframeEl = document.createElement 'iframe'
        width = @attrs.video_width or 100
        height = @attrs.video_height or 100
        ratio = (height / width) * 100

        if @attrs.src?
            iframeEl.setAttribute 'src', @attrs.src
        
        iframeEl.setAttribute 'allowfullscreen', ''

        @el.style.paddingTop = ratio + '%'
        @el.appendChild iframeEl

        @