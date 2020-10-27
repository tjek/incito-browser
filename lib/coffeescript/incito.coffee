import { isDefinedStr, throttle } from './utils'
import * as views from './views'

if typeof window != 'undefined' and typeof window.requestIdleCallback == 'function'
    requestIdleCallback = window.requestIdleCallback
else
    requestIdleCallback = (cb) ->
        setTimeout(->
            start = Date.now()
            cb
                didTimeout: false
                timeRemaining: -> Math.max(0, 50 - (Date.now() - start))
        , 1)

# like requestIdleCallback but effectively synchronous
# as we give infinite time to run
syncIdleCallback = (cb) ->
    cb
        timeRemaining: -> Number.MAX_VALUE
        didTimeout: false
    return

export default class Incito
    constructor: (@containerEl, {
        @incito = {}
        @renderLaziness = 1 # 0: All synchronous. 1: Visible synchronous, rest lazy. 2: All lazy.
    }) ->
        @el = document.createElement 'div'
        @ids = {}
        @views = flattenViews [], @incito.root_view
        @viewsLength = @views.length
        @viewIndex = 0
        @lazyloadables = []
        @lazyloader = throttle @lazyload.bind(@), 150
        @renderedOutsideOfViewport = false
        @_events = {}

        return
    
    bind: (event, fn) ->
        @_events[event] = @_events[event] or []
        @_events[event].push fn

    unbind: (event, fn) ->
        if @_events[event]
            @_events[event].splice(@_events[event].indexOf(fn), 1)

    trigger: (event) ->
        if @_events[event]
            @_events[event].map (e) -> e.apply(this, Array.prototype.slice.call(arguments, 1))

    start: ->
        triggeredVisibleRendered = false
        render = (IdleDeadline) =>
            @render IdleDeadline

            if @viewIndex <= @viewsLength - 1
                @renderCallbackHandle = requestIdleCallback render
            else
                # make sure visibleRendered gets triggered even
                # if renderedOutsideOfViewport wasn't
                @renderedOutsideOfViewport = true
                @trigger 'allRendered'

            if @renderedOutsideOfViewport and not triggeredVisibleRendered
                @trigger 'visibleRendered'

                triggeredVisibleRendered = true
                
            @lazyload 0 if @renderedOutsideOfViewport

            return

        @el.className = 'incito'
        @el.setAttribute 'lang', @incito.locale if @incito.locale?

        loadFonts @incito.font_assets
        @applyTheme @incito.theme

        @containerEl.appendChild @el

        # do first render synchronously unless we're very lazy
        if @renderLaziness == 2
            @renderCallbackHandle = requestIdleCallback render
        else
            syncIdleCallback render

        document.addEventListener 'scroll', @lazyloader, true
        window.addEventListener 'resize', @lazyloader, false

        @
    
    destroy: ->
        cancelIdleCallback @renderCallbackHandle
        @containerEl.removeChild @el

        document.removeEventListener 'scroll', @lazyloader, true
        window.removeEventListener 'resize', @lazyloader, false

        @trigger 'destroyed'
        
        return

    render: (IdleDeadline) ->
        while IdleDeadline.timeRemaining() > 0 and @viewIndex <= @viewsLength - 1
            item = @views[@viewIndex]
            attrs = item.attrs
            match = views[attrs.view_name] ? views.View
            view = new match(attrs).render()

            @ids[attrs.id] = attrs.meta if attrs.id? and typeof attrs.meta is 'object'

            @lazyloadables.push view.el if view.lazyload is true

            item.view = view

            if item.parent? and item.parent.view?
                item.parent.view.el.appendChild view.el
            else
                @el.appendChild view.el

            @viewIndex++

            # check if we rendered something out of the viewport for the first time and yield.
            # the check is expensive so it's faster to only check every few iterations, the downside is that
            # we might overrender a tiny bit but it comes out to faster than checking every iteration.
            if @renderLaziness and not (@viewIndex % 20) and not @renderedOutsideOfViewport and not isInsideViewport(view.el)
                @renderedOutsideOfViewport = true

                break

        return
    
    applyTheme: (theme = {}) ->
        if Array.isArray theme.font_family
            @el.style.fontFamily = theme.font_family.join(', ')
        
        if isDefinedStr theme.background_color
            @el.style.backgroundColor = theme.background_color

        if isDefinedStr theme.text_color
            @el.style.color = theme.text_color
        
        if typeof theme.line_spacing_multiplier is 'number'
            @el.style.lineHeight = theme.line_spacing_multiplier
        
        return
    
    lazyload: (threshold) ->
        @lazyloadables = @lazyloadables.filter (el) ->
            if isInsideViewport el, threshold
                revealElement el

                false
            else
                true
        
        return

flattenViews = (views, attrs, parent) ->
    item =
        attrs: attrs
        view: null
        parent: parent
    
    views.push item
    
    if Array.isArray(attrs.child_views)
        attrs.child_views.forEach (childAttrs) ->
            flattenViews views, childAttrs, item
    
    views

loadFonts = (fontAssets = {}) ->
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
    
isInsideViewport = (el, threshold) ->
    windowHeight = window.innerHeight
    threshold = threshold ? windowHeight
    rect = el.getBoundingClientRect()

    rect.top <= windowHeight + threshold and rect.top + rect.height >= -threshold

revealElement = (el) ->
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

        iframeEl.setAttribute 'allow', 'fullscreen; accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
        iframeEl.setAttribute 'src', src

        el.appendChild iframeEl
    else
        el.style.backgroundImage = "url(#{src})"

    return
