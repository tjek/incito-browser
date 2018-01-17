View = require './views/view'
ImageView = require './views/image'
TextView = require './views/text'
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
        
        @

    render: (el, view = {}) ->
        match = null
        viewName = view.view_name

        if !viewName or viewName is 'View'
            match = View
        else if viewName is 'ImageView'
            match = ImageView
        else if viewName is 'TextView'
            match = TextView
        else if viewName is 'LinearLayout'
            match = LinearLayout
        else if viewName is 'AbsoluteLayout'
            match = AbsoluteLayout
        else if viewName is 'FlexLayout'
            match = FlexLayout
        
        if match?
            viewEl = new match(view).render().el

            if Array.isArray(view.child_views)
                view.child_views.forEach (childView) =>
                    childEl = @render(viewEl, childView)

                    viewEl.appendChild childEl if childEl?

                    return
            
            el.appendChild viewEl
        
            viewEl
    
    applyTheme: (theme = {}) ->
        if theme.font_family?
            @el.style.fontFamily = theme.font_family.join(', ')
        
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

module.exports = Incito