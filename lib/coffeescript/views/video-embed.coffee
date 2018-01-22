View = require './view'
allowedHostnames = ['www.youtube.com', 'www.vimeo.com']

module.exports = class FlexLayout extends View
    className: 'incito__video-embed-view'

    render: ->
        linkEl = document.createElement 'a'
        iframeEl = document.createElement 'iframe'
        width = @attrs.video_width or 100
        height = @attrs.video_height or 100
        ratio = (height / width) * 100

        if @attrs.src?
            linkEl.setAttribute 'href', @attrs.src

            if linkEl.hostname in allowedHostnames
                iframeEl.setAttribute 'src', @attrs.src
                iframeEl.setAttribute 'allowfullscreen', ''

                @el.style.paddingTop = ratio + '%'
                @el.appendChild iframeEl

        @