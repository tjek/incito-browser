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
        @lazyloader = utils.throttle @lazyload.bind(@), 150

        return

    start: ->
        @el.className = 'incito'
        @el.setAttribute 'lang', @incito.locale if @incito.locale?

        @loadFonts @incito.font_assets
        @applyTheme @incito.theme
        @render 400

        @containerEl.appendChild @el

        window.addEventListener 'scroll', @lazyloader, false

        @
    
    destroy: ->
        @containerEl.removeChild @el

        window.removeEventListener 'scroll', @lazyloader, false

        @trigger 'destroyed'
        
        return

    render: (viewCount) ->
        i = @viewIndex

        while i < Math.min(@viewIndex + viewCount, @views.length)
            item = @views[i]
            attrs = item.attrs
            viewName = attrs.view_name
            match = views[viewName] ? View
            view = new match(attrs).render()

            if attrs.id? and typeof attrs.meta is 'object'
                @ids[attrs.id] = attrs.meta
            
            item.view = view

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
    
    lazyload: ->
        rect = @el.getBoundingClientRect()

        @render 400 if rect.bottom <= window.innerHeight * 4

        return

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

MicroEvent.mixin Incito

module.exports = Incito