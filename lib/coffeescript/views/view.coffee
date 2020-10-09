import { formatUnit, isDefinedStr } from "../utils"

export default class View
    tagName: 'div'

    className: null
    
    constructor: (@attrs = {}) ->
        @el = @createElement()

        @setAttributes()
        
        return
    
    render: ->
        @

    createElement: ->
        el = document.createElement @tagName
        className = @className ? ''

        el.className = 'incito__view ' + className

        el
    
    setAttributes: ->
        # Identifier.
        if isDefinedStr @attrs.id
            @el.setAttribute 'data-id', @attrs.id
        
        # Role.
        if isDefinedStr @attrs.role
            @el.setAttribute 'data-role', @attrs.role
        
        # Accessibility label.
        if isDefinedStr @attrs.accessibility_label
            @el.setAttribute 'aria-label', @attrs.accessibility_label

        # Accessibility visibility.
        if @attrs.accessibility_hidden is true
            @el.setAttribute 'aria-hidden', true
        
        # Feature labels.
        if Array.isArray(@attrs.feature_labels)
            featureLabels = @attrs.feature_labels.filter (featureLabel) -> /^[a-z_-]{1,14}$/.test featureLabel
            
            @el.setAttribute 'data-feature-labels', featureLabels.join(',') if featureLabels.length

        # Title.
        if isDefinedStr @attrs.title
            @el.setAttribute 'title', @attrs.title

        # Metadata Title
        if isDefinedStr @attrs.meta.title
            @el.setAttribute 'data-title', @attrs.meta.title

        # Gravity.
        if isDefinedStr @attrs.gravity
            @el.setAttribute 'data-gravity', @attrs.gravity
        
        # Link.
        if isDefinedStr @attrs.link
            @el.setAttribute 'data-link', ''
            @el.addEventListener 'click', =>
                window.open @attrs.link, '_blank'

                return
            , false

        # Width.
        if @attrs.layout_width is 'match_parent'
            @el.style.width = '100%'
        else if @attrs.layout_width is 'wrap_content'
            @el.style.display = 'inline-block'
        else if @attrs.layout_width?
            @el.style.width = formatUnit @attrs.layout_width

        # Height.
        if @attrs.layout_height is 'match_parent'
            @el.style.height = '100%'
        else if @attrs.layout_height is 'wrap_content'
            @el.style.height = 'auto'
        else if @attrs.layout_height?
            @el.style.height = formatUnit @attrs.layout_height

        # Min width.
        if @attrs.min_width?
            @el.style.minWidth = formatUnit @attrs.min_width
        
        # Max width.
        if @attrs.max_width?
            @el.style.maxWidth = formatUnit @attrs.max_width

        # Min height.
        if @attrs.min_height?
            @el.style.minHeight = formatUnit @attrs.min_height

        # Max height.
        if @attrs.max_height?
            @el.style.maxHeight = formatUnit @attrs.max_height
        
        # Position in relation to parent.
        if @attrs.layout_top?
            @el.style.top = formatUnit @attrs.layout_top
        if @attrs.layout_left?
            @el.style.left = formatUnit @attrs.layout_left
        if @attrs.layout_right?
            @el.style.right = formatUnit @attrs.layout_right
        if @attrs.layout_bottom?
            @el.style.bottom = formatUnit @attrs.layout_bottom
        
        # Background.
        if isDefinedStr @attrs.background_color
            @el.style.backgroundColor = @attrs.background_color
        if isDefinedStr @attrs.background_image
            @el.setAttribute 'data-src', @attrs.background_image
            @lazyload = true
        if @attrs.background_tile_mode in ['repeat_x', 'repeat_y', 'repeat']
            @el.style.backgroundRepeat = @attrs.background_tile_mode.replace '_', '-'
        if isDefinedStr @attrs.background_image_position
            @el.style.backgroundPosition = @attrs.background_image_position.replace '_', ' '
        if @attrs.background_image_scale_type is 'center_crop'
            @el.style.backgroundSize = 'cover'
        else if @attrs.background_image_scale_type is 'center_inside'
            @el.style.backgroundSize = 'contain'

        # Margin.
        if @attrs.layout_margin?
            @el.style.margin = formatUnit @attrs.layout_margin
        if @attrs.layout_margin_top?
            @el.style.marginTop = formatUnit @attrs.layout_margin_top
        if @attrs.layout_margin_left?
            @el.style.marginLeft = formatUnit @attrs.layout_margin_left
        if @attrs.layout_margin_right?
            @el.style.marginRight = formatUnit @attrs.layout_margin_right
        if @attrs.layout_margin_bottom?
            @el.style.marginBottom = formatUnit @attrs.layout_margin_bottom

        # Padding.
        if @attrs.padding?
            @el.style.padding = formatUnit @attrs.padding
        if @attrs.padding_top?
            @el.style.paddingTop = formatUnit @attrs.padding_top
        if @attrs.padding_left?
            @el.style.paddingLeft = formatUnit @attrs.padding_left
        if @attrs.padding_right?
            @el.style.paddingRight = formatUnit @attrs.padding_right
        if @attrs.padding_bottom?
            @el.style.paddingBottom = formatUnit @attrs.padding_bottom
        
        # Corner radius.
        if @attrs.corner_radius?
            @el.style.borderRadius = formatUnit @attrs.corner_radius
        if @attrs.corner_top_left_radius?
            @el.style.borderTopLeftRadius = formatUnit @attrs.corner_top_left_radius
        if @attrs.corner_top_right_radius?
            @el.style.borderTopRightRadius = formatUnit @attrs.corner_top_right_radius
        if @attrs.corner_bottom_left_radius?
            @el.style.borderBottomLeftRadius = formatUnit @attrs.corner_bottom_left_radius
        if @attrs.corner_bottom_right_radius?
            @el.style.borderBottomRightRadius = formatUnit @attrs.corner_bottom_right_radius
        
        # Clip children.
        if @attrs.clip_children is false
            @el.style.overflow = 'visible'

        # Shadow.
        shadow = @getShadow()

        if shadow?
            @el.style.boxShadow = "#{shadow.dx}px #{shadow.dy}px #{shadow.radius}px #{shadow.color}"
        
        # Stroke.
        strokeStyles = ['solid', 'dotted', 'dashed']

        if @attrs.stroke_width?
            @el.style.borderWidth = formatUnit @attrs.stroke_width
        if @attrs.stroke_color?
            @el.style.borderColor = @attrs.stroke_color
        if @attrs.stroke_style in strokeStyles
            @el.style.borderStyle = @attrs.stroke_style

        if @attrs.stroke_top_width?
            @el.style.borderTopWidth = formatUnit @attrs.stroke_top_width
        if @attrs.stroke_top_color?
            @el.style.borderTopColor = @attrs.stroke_top_color

        if @attrs.stroke_left_width?
            @el.style.borderLeftWidth = formatUnit @attrs.stroke_left_width
        if @attrs.stroke_left_color?
            @el.style.borderLeftColor = @attrs.stroke_left_color

        if @attrs.stroke_right_width?
            @el.style.borderRightWidth = formatUnit @attrs.stroke_right_width
        if @attrs.stroke_right_color?
            @el.style.borderRightColor = @attrs.stroke_right_color

        if @attrs.stroke_bottom_width?
            @el.style.borderBottomWidth = formatUnit @attrs.stroke_bottom_width
        if @attrs.stroke_bottom_color?
            @el.style.borderBottomColor = @attrs.stroke_bottom_color

        # Flex.
        if typeof @attrs.layout_flex_shrink is 'number'
            @el.style.flexShrink = @attrs.layout_flex_shrink
            @el.style.msFlexShrink = @attrs.layout_flex_shrink
        if typeof @attrs.layout_flex_grow is 'number'
            @el.style.flexGrow = @attrs.layout_flex_grow
            @el.style.msFlexGrow = @attrs.layout_flex_grow
        if @attrs.layout_flex_basis?
            @el.style.flexBasis = formatUnit @attrs.layout_flex_basis
            @el.style.msFlexBasis = formatUnit @attrs.layout_flex_basis
        
        # Transforms.
        transforms = @getTransforms()
        
        if transforms.length > 0
            @el.style.transform = transforms.join ' '
        
        # Transform origin.
        if Array.isArray(@attrs.transform_origin) and @attrs.transform_origin.length is 2
            @el.style.transformOrigin = [
                formatUnit(@attrs.transform_origin[0]),
                formatUnit(@attrs.transform_origin[1])
            ].join ' '

        return
    
    getTransforms: ->
        transforms = []
        translateX = formatUnit @attrs.transform_translate_x
        translateY = formatUnit @attrs.transform_translate_y

        if translateX isnt 0
            transforms.push "translateX(#{translateX})"
        
        if  translateY isnt 0
            transforms.push "translateY(#{translateY})"

        if typeof @attrs.transform_rotate is 'number' and @attrs.transform_rotate isnt 0
            transforms.push "rotate(#{@attrs.transform_rotate}deg)"

        if typeof @attrs.transform_scale is 'number' and @attrs.transform_scale isnt 1
            transforms.push "scale(#{@attrs.transform_scale})"
        
        transforms

    getShadow: ->
        if isDefinedStr @attrs.shadow_color
            dx = if typeof @attrs.shadow_dx is 'number' then @attrs.shadow_dx else 0
            dy = if typeof @attrs.shadow_dy is 'number' then @attrs.shadow_dy else 0
            radius = if typeof @attrs.shadow_radius is 'number' then @attrs.shadow_radius else 0
            color = @attrs.shadow_color

            dx: dx
            dy: dy
            radius: radius
            color: color