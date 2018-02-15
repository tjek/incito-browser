require 'intersection-observer'

MicroEvent = require 'microevent'
lozad = require 'lozad'
View = require './views/view'
FragView = require './views/frag'
ImageView = require './views/image'
TextView = require './views/text'
VideoEmbedView = require './views/video-embed'
LinearLayout = require './views/linear-layout'
AbsoluteLayout = require './views/absolute-layout'
FlexLayout = require './views/flex-layout'

class Incito
    constructor: (@el, @options = {}) ->
        return
    
    start: ->
        incito = @options.incito or {}
        frag = document.createDocumentFragment()

        @loadFonts incito.font_assets
        @applyTheme incito.theme
        @render frag, incito.root_view

        @el.setAttribute 'lang', incito.locale if incito.locale?
        @el.setAttribute 'data-debug', true if incito.debug is true
        @el.appendChild frag

        @lazyload = lozad '.incito--lazyload',
            rootMargin: '1500px 0px'
        @lazyload.observe()
        
        @

    render: (el, attrs = {}) ->
        match = null
        viewName = attrs.view_name

        if !viewName or viewName is 'View'
            match = View
        else if viewName is 'FragView'
            match = FragView
        else if viewName is 'ImageView'
            match = ImageView
        else if viewName is 'TextView'
            match = TextView
        else if viewName is 'VideoEmbedView'
            match = VideoEmbedView
        else if viewName is 'LinearLayout'
            match = LinearLayout
        else if viewName is 'AbsoluteLayout'
            match = AbsoluteLayout
        else if viewName is 'FlexLayout'
            match = FlexLayout
        
        if match?
            view = new match attrs
            trigger = view.trigger

            view.trigger = (args...) =>
                trigger.apply view, args
                @trigger.apply @, args

                return
            view.render()

            if Array.isArray(attrs.child_views)
                attrs.child_views.forEach (childView) =>
                    childEl = @render(view.el, childView)

                    view.el.appendChild childEl if childEl?

                    return
            
            el.appendChild view.el
        
            view.el
    
    applyTheme: (theme = {}) ->
        if theme.font_family?
            @el.style.fontFamily = theme.font_family.join(', ')
        
        if theme.background_color?
            @el.style.backgroundColor = theme.background_color
        
        if theme.line_spacing_multiplier?
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

MicroEvent.mixin Incito

module.exports = Incito