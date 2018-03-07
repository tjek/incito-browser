View = require './view'
utils = require '../utils'

allowedHostnames = ['www.youtube.com', 'www.vimeo.com', 'video.twentythree.net']

module.exports = class FlexLayout extends View
    className: 'incito__video-embed-view incito--lazyload'

    render: ->
        @el.addEventListener 'incito-lazyload', @renderIframe.bind(@)

        @
    
    renderIframe: ->
        if utils.isDefinedStr @attrs.src
            iframeEl = document.createElement 'iframe'
            linkEl = document.createElement 'a'

            linkEl.setAttribute 'href', @attrs.src

            if linkEl.hostname in allowedHostnames
                iframeEl.setAttribute 'src', @attrs.src

                @el.appendChild iframeEl

        @