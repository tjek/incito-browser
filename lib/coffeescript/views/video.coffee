View = require './view'
utils = require '../utils'

module.exports = class Video extends View
    className: 'incito__video-view'

    tagName: 'video'

    render: ->
        return if not utils.isDefinedStr @attrs.src

        sourceEl = document.createElement 'source'

        @el.muted = true
        @el.preload = 'metadata'
        @el.setAttribute 'muted', ''
        @el.setAttribute 'playsinline', 'true'
        @el.setAttribute 'webkit-playsinline', 'true'

        if @attrs.autoplay is true
            @el.autoplay = true
        
        if @attrs.loop is true
            @el.loop = true
        
        if @attrs.controls is true
            @el.controls = true

        sourceEl.setAttribute 'src', @attrs.src
        sourceEl.setAttribute 'type', @attrs.mime

        @el.appendChild sourceEl

        @