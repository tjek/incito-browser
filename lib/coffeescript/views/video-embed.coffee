import View from './view'
import { isDefinedStr } from "../utils"

allowedHostnames = ['www.youtube.com', 'www.vimeo.com', 'video.twentythree.net']

export default class FlexLayout extends View
    className: 'incito__video-embed-view'

    lazyload: false

    render: ->
        return @ if not isDefinedStr @attrs.src

        src = @attrs.src
        linkEl = document.createElement 'a'

        linkEl.setAttribute 'href', src

        if linkEl.hostname in allowedHostnames
            @el.setAttribute 'data-src', src
            @lazyload = true
        
        @