LazyLoad = require 'vanilla-lazyload'
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

        return

    start: ->
        incito = @options.incito or {}
        frag = document.createDocumentFragment()

        @loadFonts incito.font_assets
        @applyTheme incito.theme
        @render frag, incito.root_view

        @el.className = 'incito'
        @el.setAttribute 'lang', incito.locale if incito.locale?
        @el.appendChild frag
        @containerEl.appendChild @el

        setTimeout =>
            @lazyload = new LazyLoad
                elements_selector: '.incito--lazyload'
                threshold: 1000
                callback_enter: (el) ->
                    if el.nodeName.toLowerCase() is 'video' and el.getAttribute('data-autoplay')
                        el.play()

                    return
            
            return
        , 0
        
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