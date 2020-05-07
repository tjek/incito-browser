import View from './view'
import { isDefinedStr } from "../utils"

export default class Video extends View
    className: 'incito__video-view'

    tagName: 'video'

    lazyload: true

    render: ->
        return @ if not isDefinedStr @attrs.src

        @el.muted = true
        @el.preload = 'metadata'
        @el.setAttribute 'muted', ''
        @el.setAttribute 'playsinline', 'true'
        @el.setAttribute 'webkit-playsinline', 'true'
        @el.setAttribute 'data-src', @attrs.src
        @el.setAttribute 'data-mime', @attrs.mime

        if @attrs.autoplay is true
            @el.autoplay = true
        
        if @attrs.loop is true
            @el.loop = true
        
        if @attrs.controls is true
            @el.controls = true

        # Link.
        if isDefinedStr @attrs.link
            @el.setAttribute 'data-link', ''
            @el.addEventListener 'click', =>
                window.open @attrs.link, '_blank'

                return
            , false

        @