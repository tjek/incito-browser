import View from './view'
import { escapeHTML, isDefinedStr } from "../utils"

export default class TextView extends View
    tagName: 'p'

    className: 'incito__text-view'

    render: ->
        return @ if not isDefinedStr @attrs.text

        textStyles = (@attrs.text_style || '').split '|'
        text = @attrs.text

        if Array.isArray(@attrs.spans) and @attrs.spans.length > 0
            parsedText = @parseSpans text, @attrs.spans
            text = parsedText.map (item) ->
                escapedText = escapeHTML item.text or ''

                if item.span? and item.span.name is 'link' and item.span.url?
                    '<a href="' + encodeURI(item.span.url) + '" rel="external" target="_blank">' + escapedText + '</a>'
                else if item.span? and item.span.name?
                    spanName = item.span.name

                    '<span data-name="' + spanName + '">' + escapedText + '</span>'
                else
                    escapedText
            text = text.join ''
        else
            text = escapeHTML text

        if @attrs.text_prevent_widow
            text = text.replace(/\&nbsp;([^\s]+)$/,' $1').replace(/\s([^\s]+)\s*$/,'&nbsp;$1')
        else
            text = text
        
        @el.innerHTML = text.replace /\n/g, '<br>'

        # Font family.
        if Array.isArray(@attrs.font_family) and @attrs.font_family.length > 0
            @el.style.fontFamily = @attrs.font_family.join ', '
        else
            @el.style.fontFamily = 'inherit'

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
        
        if Array.isArray @attrs.text_decoration_line
            @el.style.textDecorationLine = @attrs.text_decoration_line.join ' '
        
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
        
        # Max lines.
        if @attrs.single_line is true or @attrs.max_lines is 1
            @el.setAttribute 'data-single-line', true
        else if typeof @attrs.max_lines is 'number'
            @el.style.display = '-webkit-box'
            @el.style.webkitLineClamp = @attrs.max_lines
            @el.style.webkitBoxOrient = 'vertical'
        
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
        if isDefinedStr @attrs.text_shadow_color
            dx = if typeof @attrs.text_shadow_dx is 'number' then @attrs.text_shadow_dx else 0
            dy = if typeof @attrs.text_shadow_dy is 'number' then @attrs.text_shadow_dy else 0
            radius = if typeof @attrs.text_shadow_radius is 'number' then @attrs.text_shadow_radius else 0
            color = @attrs.text_shadow_color

            dx: dx
            dy: dy
            radius: radius
            color: color