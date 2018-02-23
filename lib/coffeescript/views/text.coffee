View = require './view'
utils = require '../utils'

module.exports = class TextView extends View
    tagName: 'p'

    className: 'incito__text-view'

    render: ->
        textStyles = (@attrs.text_style || '').split '|'
        parsedText = @parseSpans @attrs.text, @attrs.spans
        text = parsedText.map (item) ->
            escapedText = utils.escapeHTML item.text or ''

            if item.span? && item.span.name?
                spanName = utils.escapeHTML item.span.name

                '<span data-name="' + spanName + '">' + escapedText + '</span>'
            else
                escapedText

        if @attrs.text_prevent_widow
            @el.innerHTML = text.join('').replace(/\&nbsp;([^\s]+)$/,' $1').replace(/\s([^\s]+)\s*$/,'&nbsp;$1')
        else
            @el.innerHTML = text.join ''

        # Font family.
        if Array.isArray(@attrs.font_family) and @attrs.font_family.length > 0
            @el.style.fontFamily = @attrs.font_family.join(', ')

        # Text size.
        if @attrs.text_size?
            @el.style.fontSize = "#{@attrs.text_size}px"
        
        # Line height.
        if @attrs.line_spacing_multiplier?
            @el.style.lineHeight = @attrs.line_spacing_multiplier
        
        # Text color.
        if @attrs.text_color?
            @el.style.color = @attrs.text_color
        
        # Text styles.
        if 'bold' in textStyles
            @el.style.fontWeight = 'bold'
        if 'italic' in textStyles
            @el.style.fontStyle = 'italic'
        
        # Text shadow.
        textShadow = @getTextShadow()

        if textShadow?
            @el.style.textShadow = "#{textShadow.dx}px #{textShadow.dy}px #{textShadow.radius}px #{textShadow.color}"
        
        # Text alignment.
        if @attrs.text_alignment is 'left'
            @el.style.textAlign = 'left'
        else if @attrs.text_alignment is 'center'
            @el.style.textAlign = 'center'
        else if @attrs.text_alignment is 'right'
            @el.style.textAlign = 'right'
        
        # Font stretch.
        if @attrs.font_stretch in ['condensed', 'normal', 'expanded']
            @el.style.fontStretch = @attrs.font_stretch
        
        # Single line.
        if @attrs.single_line is true
            @el.setAttribute 'data-single-line', true
        
        # All caps.
        if @attrs.text_all_caps is true
            @el.style.textTransform = 'uppercase'

        @
    
    parseSpans: (text, spans = []) ->
        result = []

        if spans.length is 0
            result.push
                text: text
        else if spans[0].start > 0
            result.push
                text: text.slice(0, spans[0].start)

        spans.forEach (span, i) ->
            startIndex = span.start
            endIndex = span.end

            result.push
                text: text.slice(startIndex, endIndex)
                span: span

            if i is spans.length - 1
                if endIndex < text.length
                    result.push
                        text: text.slice(endIndex, text.length)
            else if endIndex < spans[i + 1].start
                result.push
                    text: text.slice(endIndex, spans[i + 1].start)

            return

        result
    
    getTextShadow: ->
        if utils.isDefinedStr @attrs.shadow_color
            dx = if typeof @attrs.shadow_dx is 'number' then @attrs.shadow_dx else 0
            dy = if typeof @attrs.shadow_dy is 'number' then @attrs.shadow_dy else 0
            radius = if typeof @attrs.shadow_radius is 'number' then @attrs.shadow_radius else 0
            color = @attrs.shadow_color

            dx: dx
            dy: dy
            radius: radius
            color: color