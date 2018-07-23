MicroEvent = require 'microevent'
utils = require './utils'
View = require './views/view'
FragView = require './views/frag'
ImageView = require './views/image'
TextView = require './views/text'
VideoEmbedView = require './views/video-embed'
VideoView = require './views/video'
LinearLayout = require './views/linear-layout'
AbsoluteLayout = require './views/absolute-layout'
FlexLayout = require './views/flex-layout'

class Incito
    constructor: (@containerEl, @options = {}) ->
        @el = document.createElement 'div'
        @entries = []
        @ids = {}

        return

    start: ->
        incito = @options.incito or {}

        @el.className = 'incito'
        @el.setAttribute 'lang', incito.locale if incito.locale?

        @loadFonts incito.font_assets
        @applyTheme incito.theme
        @render @el, incito.root_view

        @containerEl.appendChild @el

        @lazyload()
        
        @
    
    destroy: ->
        @containerEl.removeChild @el

        if @lazyloadCheck?
            window.removeEventListener 'scroll', @lazyloadCheck, false
            window.removeEventListener 'resize', @lazyloadCheck, false

        @trigger 'destroyed'
        
        return

    render: (el, attrs = {}) ->
        match = null
        viewName = attrs.view_name
        views =
            View: View
            FragView: FragView
            ImageView: ImageView
            TextView: TextView
            VideoEmbedView: VideoEmbedView
            VideoView: VideoView
            LinearLayout: LinearLayout
            AbsoluteLayout: AbsoluteLayout
            FlexLayout: FlexLayout
        match = views[viewName] ? View
        view = new match(attrs).render()

        @entries.push view.el if view.lazyload is true

        if attrs.id? and typeof attrs.meta is 'object'
            @ids[attrs.id] = attrs.meta

        if Array.isArray(attrs.child_views)
            attrs.child_views.forEach (childView) =>
                @render(view.el, childView)

                return
        
        el.appendChild view.el
    
        view.el
    
    applyTheme: (theme = {}) ->
        if Array.isArray theme.font_family
            @el.style.fontFamily = theme.font_family.join(', ')
        
        if utils.isDefinedStr theme.background_color
            @el.style.backgroundColor = theme.background_color

        if utils.isDefinedStr theme.text_color
            @el.style.color = theme.text_color
        
        if typeof theme.line_spacing_multiplier is 'number'
            @el.style.lineHeight = theme.line_spacing_multiplier
        
        return

    loadFonts: (fontAssets = {}) ->
        if 'FontFace' of window
            for key, value of fontAssets
                urls = value.src.map((src) -> "url(#{src[1]})").join ', '
                font = new FontFace key, urls,
                    style: value.style ? 'normal'
                    weight: value.weight ? 'normal'

                document.fonts.add font

                font.load()
        else
            styleEl = document.createElement 'style'

            for key, value of fontAssets
                urls = value.src.map((src) -> "url('#{src[1]}') format('#{src[0]}')").join ', '
                text = """
                    @font-face {
                        font-family: '#{key}';
                        src: #{urls};
                    }
                """
                
                styleEl.appendChild document.createTextNode(text)

            document.head.appendChild styleEl
        
        return
    
    lazyload: ->
        threshold = 1000

        if 'IntersectionObserver' of window
            observer = new IntersectionObserver (entries) =>
                entries.forEach (entry) =>
                    if entry.isIntersecting or entry.intersectionRatio > 0
                        @revealElement entry.target
                        observer.unobserve entry.target

                    return

                return
            ,
                rootMargin: "#{threshold}px"

            @entries.forEach observer.observe.bind(observer)
        else
            isInsideViewport = (el) ->
                rect = el.getBoundingClientRect()
                windowHeight = window.innerHeight ? document.documentElement.clientHeight

                rect.top <= windowHeight + threshold and rect.top + rect.height >= -threshold
            check = =>
                @entries = @entries.filter (el) =>
                    if isInsideViewport el
                        @revealElement el

                        false
                    else
                        true
                
                return
            
            @lazyloadCheck = utils.throttle check, 150

            window.addEventListener 'scroll', @lazyloadCheck, false
            window.addEventListener 'resize', @lazyloadCheck, false

            setTimeout check, 0

        return
    
    revealElement: (el) ->
        src = el.getAttribute 'data-src'

        if el.tagName.toLowerCase() is 'img'
            el.addEventListener 'load', ->
                el.className += ' incito--loaded'

                return
            el.setAttribute 'src', src
        else if el.tagName.toLowerCase() is 'video'
            sourceEl = document.createElement 'source'

            sourceEl.setAttribute 'src', src
            sourceEl.setAttribute 'type', el.getAttribute('data-mime')

            el.appendChild sourceEl
        else if /incito__video-embed-view/gi.test(el.className)
            iframeEl = document.createElement 'iframe'

            iframeEl.setAttribute 'src', src

            el.appendChild iframeEl
        else
            el.style.backgroundImage = "url(#{src})"

        return

MicroEvent.mixin Incito

module.exports = Incito