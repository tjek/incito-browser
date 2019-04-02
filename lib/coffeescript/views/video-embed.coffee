View = require './view'
utils = require '../utils'

allowedHostnames = ['www.youtube.com', 'www.vimeo.com', 'video.twentythree.net']

module.exports = class FlexLayout extends View
    tagName: 'iframe'

    className: 'incito__video-embed-view'

    render: ->
        if utils.isDefinedStr @attrs.src
            src = @attrs.src
            linkEl = document.createElement 'a'

            linkEl.setAttribute 'href', src

            if linkEl.hostname in allowedHostnames
                @el.setAttribute 'allow', 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
                @el.setAttribute 'src', src

        @