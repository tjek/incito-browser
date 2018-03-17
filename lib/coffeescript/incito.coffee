LazyLoad = require './../../vendor/vanilla-lazyload'
LazyLoadLegacy = require './lazyload-legacy'
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

        @lazyLoader = @createLazyLoader()
        
        @
    
    destroy: ->
        @containerEl.removeChild @el
        @lazyload.destroy() if @lazyload?

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
    
    createLazyLoader: ->
        LazyLoader = if 'IntersectionObserver' of window then LazyLoad else LazyLoadLegacy

        return new LazyLoader
            container: @options.scrollEl ? window
            elements_selector: '.incito .incito--lazyload'
            threshold: 1000
            callback_enter: (el) ->
                completeEvent = null
                eventName = 'incito-lazyload'

                if typeof CustomEvent is 'function'
                    completeEvent = new CustomEvent eventName
                else
                    completeEvent = document.createEvent 'CustomEvent'

                    completeEvent.initCustomEvent eventName, false, false, undefined
                    
                el.dispatchEvent completeEvent

                return

MicroEvent.mixin Incito

module.exports = Incito