utils = require '../utils'
vent = require '../vent'

module.exports = class View
    tagName: 'div'

    className: null
    
    constructor: (@attrs = {}) ->
        @el = @createElement()

        @setAttributes()
        @initialize()
    
    initialize: ->
        return
    
    render: ->
        @

    createElement: ->
        el = document.createElement @tagName

        el.className = 'incito__view'
        el.className += ' ' + @className if @className?

        el
    
    setAttributes: ->
        # Identifier.
        if typeof @attrs.id is 'string'
            @el.setAttribute 'data-id', @attrs.id
        
        # Accessibility label.
        if typeof @attrs.accessibility_label is 'string'
            @el.setAttribute 'aria-label', @attrs.accessibility_label
            @el.setAttribute 'title', @attrs.accessibility_label

        # Gravity.
        if typeof @attrs.gravity is 'string'
            @el.setAttribute 'data-gravity', @attrs.gravity
        
        # Link or callback.
        if typeof @attrs.link is 'string'
            @el.setAttribute 'data-link', @attrs.link
            @el.onclick = (e) =>
                e.stopPropagation()

                window.open @attrs.link, '_blank'

                return
        else if typeof @attrs.on_click is 'string'
            @el.setAttribute 'data-callback', @attrs.on_click
            @el.onclick = (e) =>
                e.stopPropagation()

                vent.trigger @attrs.on_click, @attrs

                return

        # Width.
        if @attrs.layout_width is 'match_parent'
            @el.style.display = 'block'
        else if @attrs.layout_width is 'wrap_content'
            @el.style.display = 'inline-block'
        else if @attrs.layout_width?
            @el.style.width = utils.formatUnit @attrs.layout_width

        # Height.
        if @attrs.layout_height is 'match_parent'
            @el.style.height = '100%'
        else if @attrs.layout_height is 'wrap_content'
            @el.style.height = 'auto'
        else if @attrs.layout_height?
            @el.style.height = utils.formatUnit @attrs.layout_height

        # Min width.
        if @attrs.min_width?
            @el.style.minWidth = utils.formatUnit @attrs.min_width
        
        # Max width.
        if @attrs.max_width?
            @el.style.maxWidth = utils.formatUnit @attrs.max_width

        # Min height.
        if @attrs.min_height?
            @el.style.minHeight = utils.formatUnit @attrs.min_height

        # Max height.
        if @attrs.max_height?
            @el.style.maxHeight = utils.formatUnit @attrs.max_height
        
        # Position in relation to parent.
        if @attrs.layout_top?
            @el.style.top = utils.formatUnit @attrs.layout_top
        if @attrs.layout_left?
            @el.style.left = utils.formatUnit @attrs.layout_left
        if @attrs.layout_right?
            @el.style.right = utils.formatUnit @attrs.layout_right
        if @attrs.layout_bottom?
            @el.style.bottom = utils.formatUnit @attrs.layout_bottom
        
        # Background.
        if @attrs.background_color?
            @el.style.backgroundColor = @attrs.background_color
        if @attrs.background_image?
            @el.setAttribute 'data-background-image', @attrs.background_image
            @el.className += ' incito--lazyload'
        if @attrs.background_tile_mode in ['repeat_x', 'repeat_y', 'repeat']
            @el.style.backgroundRepeat = @attrs.background_tile_mode.replace '_', '-'
        if @attrs.background_image_position?
            @el.style.backgroundPosition = @attrs.background_image_position.replace '_', ' '
        if @attrs.background_image_scale_type is 'center_crop'
            @el.style.backgroundSize = 'cover'
        else if @attrs.background_image_scale_type is 'center_inside'
            @el.style.backgroundSize = 'contain'
        
        # Drop shadow.
        if @attrs.drop_shadow?
            dropShadowLeft = @attrs.drop_shadow.left
            dropShadowTop = @attrs.drop_shadow.top
            dropShadowBlurRadius = @attrs.drop_shadow.blur_radius
            dropShadowColor = @attrs.drop_shadow.color or 'transparent'
            dropShadowValues = [
                utils.formatUnit(dropShadowLeft),
                utils.formatUnit(dropShadowTop),
                utils.formatUnit(dropShadowBlurRadius),
                dropShadowColor
            ].join(' ')

            @el.style.filter = "drop-shadow(#{dropShadowValues})"

        # Margin.
        if @attrs.layout_margin?
            @el.style.margin = utils.formatUnit @attrs.layout_margin
        else
            if @attrs.layout_margin_top?
                @el.style.marginTop = utils.formatUnit @attrs.layout_margin_top
            if @attrs.layout_margin_left?
                @el.style.marginLeft = utils.formatUnit @attrs.layout_margin_left
            if @attrs.layout_margin_right?
                @el.style.marginRight = utils.formatUnit @attrs.layout_margin_right
            if @attrs.layout_margin_bottom?
                @el.style.marginBottom = utils.formatUnit @attrs.layout_margin_bottom

        # Padding.
        if @attrs.padding?
            @el.style.padding = utils.formatUnit @attrs.padding
        else
            if @attrs.padding_top?
                @el.style.paddingTop = utils.formatUnit @attrs.padding_top
            if @attrs.padding_left?
                @el.style.paddingLeft = utils.formatUnit @attrs.padding_left
            if @attrs.padding_right?
                @el.style.paddingRight = utils.formatUnit @attrs.padding_right
            if @attrs.padding_bottom?
                @el.style.paddingBottom = utils.formatUnit @attrs.padding_bottom
        
        # Corner radius.
        if @attrs.corner_radius?
            @el.style.borderRadius = utils.formatUnit @attrs.corner_radius
        else
            if @attrs.corner_top_left_radius?
                @el.style.borderTopLeftRadius = utils.formatUnit @attrs.corner_top_left_radius
            if @attrs.corner_top_right_radius?
                @el.style.borderTopRightRadius = utils.formatUnit @attrs.corner_top_right_radius
            if @attrs.corner_bottom_left_radius?
                @el.style.borderBottomLeftRadius = utils.formatUnit @attrs.corner_bottom_left_radius
            if @attrs.corner_bottom_right_radius?
                @el.style.borderBottomRightRadius = utils.formatUnit @attrs.corner_bottom_right_radius
        
        # Clip children.
        if @attrs.clip_children is false
            @el.style.overflow = 'visible'
        
        # Stroke.
        strokeStyles = ['solid', 'dotted', 'dashed']

        if @attrs.stroke_width?
            @el.style.borderWidth = utils.formatUnit @attrs.stroke_width
        if @attrs.stroke_color?
            @el.style.borderColor = @attrs.stroke_color
        if @attrs.stroke_style in strokeStyles
            @el.style.borderStyle = @attrs.stroke_style

        if @attrs.stroke_top_width?
            @el.style.borderTopWidth = utils.formatUnit @attrs.stroke_top_width
        if @attrs.stroke_top_color?
            @el.style.borderTopColor = @attrs.stroke_top_color
        if @attrs.stroke_top_style in strokeStyles
            @el.style.borderTopStyle = @attrs.stroke_top_style

        if @attrs.stroke_left_width?
            @el.style.borderLeftWidth = utils.formatUnit @attrs.stroke_left_width
        if @attrs.stroke_left_color?
            @el.style.borderLeftColor = @attrs.stroke_left_color
        if @attrs.stroke_left_style in strokeStyles
            @el.style.borderLeftStyle = @attrs.stroke_left_style

        if @attrs.stroke_right_width?
            @el.style.borderRightWidth = utils.formatUnit @attrs.stroke_right_width
        if @attrs.stroke_right_color?
            @el.style.borderRightColor = @attrs.stroke_right_color
        if @attrs.stroke_right_style in strokeStyles
            @el.style.borderRightStyle = @attrs.stroke_right_style

        if @attrs.stroke_bottom_width?
            @el.style.borderBottomWidth = utils.formatUnit @attrs.stroke_bottom_width
        if @attrs.stroke_bottom_color?
            @el.style.borderBottomColor = @attrs.stroke_bottom_color
        if @attrs.stroke_bottom_style in strokeStyles
            @el.style.borderBottomStyle = @attrs.stroke_bottom_style

        # Flex layout.
        if typeof @attrs.layout_flex_shrink is 'number'
            @el.style.flexShrink = @attrs.layout_flex_shrink
        if typeof @attrs.layout_flex_grow is 'number'
            @el.style.flexGrow = @attrs.layout_flex_grow
        if @attrs.layout_flex_basis?
            @el.style.flexBasis = @attrs.layout_flex_basis
        
        # Transforms.
        transforms = @getTransforms()
        if transforms.length > 0
            @el.style.transform = transforms.join ' '
        
        # Transform origin.
        if Array.isArray(@attrs.transform_origin) and @attrs.transform_origin.length is 2
            @el.style.transformOrigin = [
                utils.formatUnit(@attrs.transform_origin[0]),
                utils.formatUnit(@attrs.transform_origin[1])
            ].join ' '

        return
    
    getTransforms: ->
        transforms = []
        
        if @attrs.transform_translate_x?
            translateX = utils.formatUnit @attrs.transform_translate_x

            transforms.push "translateX(#{translateX})"

        if @attrs.transform_translate_y?
            translateY = utils.formatUnit @attrs.transform_translate_y

            transforms.push "translateY(#{translateY})"

        if @attrs.transform_scale?
            transforms.push "scale(#{@attrs.transform_scale})"

        if @attrs.transform_rotate?
            transforms.push "rotate(#{@attrs.transform_rotate}deg)"
        
        transforms