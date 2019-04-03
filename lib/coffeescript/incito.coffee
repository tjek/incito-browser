MicroEvent = require 'microevent'
utils = require './utils'
View = require './views/view'
ImageView = require './views/image'
TextView = require './views/text'
VideoEmbedView = require './views/video-embed'
VideoView = require './views/video'
AbsoluteLayout = require './views/absolute-layout'
FlexLayout = require './views/flex-layout'

views =
    View: View
    ImageView: ImageView
    TextView: TextView
    VideoEmbedView: VideoEmbedView
    VideoView: VideoView
    AbsoluteLayout: AbsoluteLayout
    FlexLayout: FlexLayout

class Incito
    constructor: (@containerEl, @options = {}) ->
        @el = document.createElement 'div'
        @ids = {}
        @incito = @options.incito or {}
        @views = @flattenViews [], @incito.root_view
        @viewIndex = 0
        @entries = []
        @lazyloader = utils.throttle @lazyload.bind(@), 150

        return

    start: ->
        @el.className = 'incito'
        @el.setAttribute 'lang', @incito.locale if @incito.locale?

        @loadFonts @incito.font_assets
        @applyTheme @incito.theme
        @render 150

        @containerEl.appendChild @el

        window.addEventListener 'scroll', @lazyloader, false
        window.addEventListener 'resize', @lazyloader, false

        @lazyload()

        lazyHtml = =>
            @render 150

            if @viewIndex < @views.length - 1
                requestAnimationFrame lazyHtml
            
            return
        
        requestAnimationFrame lazyHtml
        
        @
    
    destroy: ->
        @containerEl.removeChild @el

        window.removeEventListener 'scroll', @lazyloader, false
        window.removeEventListener 'resize', @lazyloader, false

        @trigger 'destroyed'
        
        return

    render: (viewCount) ->
        i = @viewIndex

        while i < Math.min(@viewIndex + viewCount, @views.length - 1)
            item = @views[i]
            attrs = item.attrs
            viewName = attrs.view_name
            match = views[viewName] ? View
            view = new match(attrs).render()

            if attrs.id? and typeof attrs.meta is 'object'
                @ids[attrs.id] = attrs.meta
            
            item.view = view

            @entries.push view.el if view.lazyload is true

            if item.parent? and item.parent.view?
                item.parent.view.el.appendChild view.el
            else
                @el.appendChild view.el
            
            i++
        
        @viewIndex = i
    
        return
    
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
    
    flattenViews: (views, attrs, parent) ->
        item =
            attrs: attrs
            view: null
            parent: parent
        
        views.push item
        
        if Array.isArray(attrs.child_views)
            attrs.child_views.forEach (childAttrs) =>
                @flattenViews views, childAttrs, item
        
        views

    loadFonts: (fontAssets = {}) ->
        if 'FontFace' of window
            for key, value of fontAssets
                urls = value.src.map((src) -> "url(#{src[1]})").join ', '
                font = new FontFace key, urls,
                    style: value.style ? 'normal'
                    weight: value.weight ? 'normal'
                    display: 'swap'

                document.fonts.add font

                font.load()
        else
            styleEl = document.createElement 'style'

            for key, value of fontAssets
                urls = value.src.map((src) -> "url('#{src[1]}') format('#{src[0]}')").join ', '
                text = """
                    @font-face {
                        font-family: '#{key}';
                        font-display: swap;
                        src: #{urls};
                    }
                """
                
                styleEl.appendChild document.createTextNode(text)

            document.head.appendChild styleEl
        
        return
    
    isInsideViewport: (el) ->
        threshold = 1000
        rect = el.getBoundingClientRect()
        windowHeight = window.innerHeight ? document.documentElement.clientHeight

        rect.top <= windowHeight + threshold and rect.top + rect.height >= -threshold
    
    lazyload: ->
        @entries = @entries.filter (el) =>
            if @isInsideViewport el
                @revealElement el

                false
            else
                true
        
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

            iframeEl.setAttribute 'allow', 'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
            iframeEl.setAttribute 'src', src

            el.appendChild iframeEl
        else
            el.style.backgroundImage = "url(#{src})"

        return

MicroEvent.mixin Incito

module.exports = Incito