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
        frag = document.createDocumentFragment()

        @loadFonts()
        @render frag, @options.incito.root_view

        @el.setAttribute 'lang', @options.incito.locale if @options.incito.locale?
        @el.appendChild frag
        
        @

    render: (el, view) ->
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

    loadFonts: ->
        if 'FontFace' of window
            for key, value of @options.incito.font_assets
                urls = value.src.map((src) -> "url(#{src[1]})").join ', '
                font = new FontFace key, urls,
                    style: value.style ? 'normal'
                    weight: value.weight ? 'normal'

                document.fonts.add font

                font.load()
        else
            style = document.createElement 'style'

            for key, value of @options.incito.font_assets
                urls = value.src.map((src) -> "url('#{src[1]}') format('#{src[0]}')").join ', '
                text = """
                    @font-face {
                        font-family: '#{key}';
                        src: #{urls};
                    }
                """
                
                style.appendChild document.createTextNode(text)

            document.head.appendChild style
        
        return

module.exports = Incito