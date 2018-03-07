View = require './view'
utils = require '../utils'

module.exports = class Video extends View
    className: 'incito__video-view incito--lazyload'

    tagName: 'video'

    render: ->
        return if not utils.isDefinedStr @attrs.src

        @el.addEventListener 'play', @renderVideo.bind(@)

        if @attrs.autoplay is true
            @el.setAttribute 'autoplay', ''
        
        if @attrs.loop is true
            @el.setAttribute 'loop', ''
        
        if @attrs.controls is true
            @el.setAttribute 'controls', ''
        
        @el.setAttribute 'muted', 'true'
        @el.setAttribute 'preload', 'metadata'
        @el.setAttribute 'playsinline', ''

        @

    renderVideo: ->
        sourceEl = document.createElement 'source'

        sourceEl.setAttribute 'src', @attrs.src
        sourceEl.setAttribute 'type', @attrs.mime

        @el.appendChild sourceEl

        @