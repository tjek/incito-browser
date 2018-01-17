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
        if @attrs.id?
            @el.setAttribute 'data-id', @attrs.id

        # Gravity.
        if @attrs.gravity?
            @el.setAttribute 'data-gravity', @attrs.gravity

        # Width.
        if @attrs.layout_width is 'match_parent'
            @el.style.display = 'block'
        else if @attrs.layout_width is 'wrap_content'
            @el.style.display = 'inline-block'
        else if @attrs.layout_width?
            @el.style.width = @attrs.layout_width.replace 'dp', 'px'

        # Height.
        if @attrs.layout_height is 'match_parent'
            @el.style.height = '100%'
        else if @attrs.layout_height is 'wrap_content'
            @el.style.height = 'auto'
        else if @attrs.layout_height?
            @el.style.height = @attrs.layout_height.replace 'dp', 'px'

        # Min width.
        if @attrs.min_width?
            @el.style.minWidth = @attrs.min_width.replace 'dp', 'px'
        
        # Max width.
        if @attrs.max_width?
            @el.style.maxWidth = @attrs.max_width.replace 'dp', 'px'

        # Min height.
        if @attrs.min_height?
            @el.style.minHeight = @attrs.min_height.replace 'dp', 'px'

        # Max height.
        if @attrs.max_height?
            @el.style.maxHeight = @attrs.max_height.replace 'dp', 'px'
        
        # Position in relation to parent.
        if @attrs.layout_top?
            @el.style.top = @attrs.layout_top.replace 'dp', 'px'
        if @attrs.layout_left?
            @el.style.left = @attrs.layout_left.replace 'dp', 'px'
        if @attrs.layout_right?
            @el.style.right = @attrs.layout_right.replace 'dp', 'px'
        if @attrs.layout_bottom?
            @el.style.bottom = @attrs.layout_bottom.replace 'dp', 'px'
        
        # Background.
        if @attrs.background_color?
            @el.style.backgroundColor = @attrs.background_color
        if @attrs.background_image?
            @el.style.backgroundImage = "url(#{@attrs.background_image})"
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
            dropShadowLeft = @attrs.drop_shadow.left or '0dp'
            dropShadowTop = @attrs.drop_shadow.top or '0dp'
            dropShadowBlurRadius = @attrs.drop_shadow.blur_radius or '0dp'
            dropShadowColor = @attrs.drop_shadow.color or 'transparent'
            dropShadowValues = [
                dropShadowLeft.replace('dp', 'px'),
                dropShadowTop.replace('dp', 'px'),
                dropShadowBlurRadius.replace('dp', 'px'),
                dropShadowColor
            ].join(' ')

            @el.style.filter = "drop-shadow(#{dropShadowValues})"

        # Margin.
        if @attrs.layout_margin?
            @el.style.margin = @attrs.layout_margin.replace 'dp', 'px'
        else
            if @attrs.layout_margin_top?
                @el.style.marginTop = @attrs.layout_margin_top.replace 'dp', 'px'
            if @attrs.layout_margin_left?
                @el.style.marginLeft = @attrs.layout_margin_left.replace 'dp', 'px'
            if @attrs.layout_margin_right?
                @el.style.marginRight = @attrs.layout_margin_right.replace 'dp', 'px'
            if @attrs.layout_margin_bottom?
                @el.style.marginBottom = @attrs.layout_margin_bottom.replace 'dp', 'px'

        # Padding.
        if @attrs.padding?
            @el.style.padding = @attrs.padding.replace 'dp', 'px'
        else
            if @attrs.padding_top?
                @el.style.paddingTop = @attrs.padding_top.replace 'dp', 'px'
            if @attrs.padding_left?
                @el.style.paddingLeft = @attrs.padding_left.replace 'dp', 'px'
            if @attrs.padding_right?
                @el.style.paddingRight = @attrs.padding_right.replace 'dp', 'px'
            if @attrs.padding_bottom?
                @el.style.paddingBottom = @attrs.padding_bottom.replace 'dp', 'px'
        
        # Corner radius.
        if @attrs.corner_radius?
            @el.style.borderRadius = @attrs.corner_radius + 'px'
        else
            if @attrs.corner_top_left_radius?
                @el.style.borderTopleftRadius = @attrs.corner.corner_top_left_radius
            if @attrs.corner_top_right_radius?
                @el.style.borderTopleftRadius = @attrs.corner.corner_top_right_radius
            if @attrs.corner_bottom_left_radius?
                @el.style.borderTopleftRadius = @attrs.corner.corner_bottom_left_radius
            if @attrs.corner_bottom_right_radius?
                @el.style.borderTopleftRadius = @attrs.corner.corner_bottom_right_radius
        
        # Clip children.
        if @attrs.clip_children is false
            @el.style.overflow = 'visible'
        
        # Stroke.
        strokeStyles = ['solid', 'dotted', 'dashed']

        if @attrs.stroke_width?
            @el.style.borderWidth = @attrs.stroke_width.replace 'dp', 'px'
        if @attrs.stroke_color?
            @el.style.borderColor = @attrs.stroke_color
        if @attrs.stroke_style in strokeStyles
            @el.style.borderStyle = @attrs.stroke_style

        if @attrs.stroke_top_width?
            @el.style.borderTopWidth = @attrs.stroke_top_width.replace 'dp', 'px'
        if @attrs.stroke_top_color?
            @el.style.borderTopColor = @attrs.stroke_top_color
        if @attrs.stroke_top_style in strokeStyles
            @el.style.borderTopStyle = @attrs.stroke_top_style

        if @attrs.stroke_left_width?
            @el.style.borderLeftWidth = @attrs.stroke_left_width.replace 'dp', 'px'
        if @attrs.stroke_left_color?
            @el.style.borderLeftColor = @attrs.stroke_left_color
        if @attrs.stroke_left_style in strokeStyles
            @el.style.borderLeftStyle = @attrs.stroke_left_style

        if @attrs.stroke_right_width?
            @el.style.borderRightWidth = @attrs.stroke_right_width.replace 'dp', 'px'
        if @attrs.stroke_right_color?
            @el.style.borderRightColor = @attrs.stroke_right_color
        if @attrs.stroke_right_style in strokeStyles
            @el.style.borderRightStyle = @attrs.stroke_right_style

        if @attrs.stroke_bottom_width?
            @el.style.borderBottomWidth = @attrs.stroke_bottom_width.replace 'dp', 'px'
        if @attrs.stroke_bottom_color?
            @el.style.borderBottomColor = @attrs.stroke_bottom_color
        if @attrs.stroke_bottom_style in strokeStyles
            @el.style.borderBottomStyle = @attrs.stroke_bottom_style

        # Flex layout.
        if @attrs.layout_flex_shrink?
            @el.style.flexShrink = @attrs.layout_flex_shrink
        
        if @attrs.layout_flex_grow?
            @el.style.flexGrow = @attrs.layout_flex_grow
        
        if @attrs.layout_flex_basis?
            @el.style.flexBasis = @attrs.layout_flex_basis
        
        # Transforms.
        transforms = @getTransforms()

        if transforms.length > 0
            @el.style.transform = transforms.join ' '

        return
    
    getTransforms: ->
        transforms = []

        if @attrs.transform_rotate?
            transforms.push "rotate(#{@attrs.transform_rotate}deg)"
        
        if @attrs.transform_scale?
            transforms.push "scale(#{@attrs.transform_scale})"
        
        if @attrs.transform_translate_x?
            translateX = @attrs.transform_translate_x.replace 'dp', 'px'

            transforms.push "translateX(#{translateX})"

        if @attrs.transform_translate_y?
            translateY = @attrs.transform_translate_y.replace 'dp', 'px'

            transforms.push "translateY(#{translateY})"
        
        transforms