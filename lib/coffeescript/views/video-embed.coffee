View = require './view'
utils = require '../utils'

allowedHostnames = ['www.youtube.com', 'www.vimeo.com', 'video.twentythree.net']

module.exports = class FlexLayout extends View
    className: 'incito__video-embed-view incito--lazyload'

    tagName: 'iframe'

    render: ->
        linkEl = document.createElement 'a'

        if utils.isDefinedStr @attrs.src
            linkEl.setAttribute 'href', @attrs.src

            if linkEl.hostname in allowedHostnames
                @el.setAttribute 'data-src', @attrs.src

        @