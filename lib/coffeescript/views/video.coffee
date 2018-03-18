View = require './view'
utils = require '../utils'

module.exports = class Video extends View
    className: 'incito__video-view'

    tagName: 'video'

    lazyload: true

    render: ->
        return if not utils.isDefinedStr @attrs.src

        if @attrs.autoplay is true
            @el.setAttribute 'autoplay', ''
        
        if @attrs.loop is true
            @el.setAttribute 'loop', ''
        
        if @attrs.controls is true
            @el.setAttribute 'controls', ''
        
        @el.setAttribute 'muted', 'true'
        @el.setAttribute 'preload', 'metadata'
        @el.setAttribute 'playsinline', ''
        @el.setAttribute 'data-src', @attrs.src
        @el.setAttribute 'data-mime', @attrs.mime

        @