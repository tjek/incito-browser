import View from './view'
import { isDefinedStr } from "../utils"

allowedHostnames = ['.youtube.com', '.vimeo.com', '.twentythree.net']

export default class FlexLayout extends View
    className: 'incito__video-embed-view'

    lazyload: false

    render: ->
        return @ if not isDefinedStr @attrs.src

        src = @attrs.src
        linkEl = document.createElement 'a'

        linkEl.setAttribute 'href', src

        isSupported = allowedHostnames.find (hostname) ->
            linkEl.hostname.slice(-hostname.length) is hostname

        if isSupported
            @el.setAttribute 'data-src', src
            @lazyload = true
        
        @