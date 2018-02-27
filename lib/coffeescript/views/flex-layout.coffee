View = require './view'

alignItemModes = ['stretch', 'center', 'flex-start', 'flex-end', 'baseline']
alignContentModes = ['stretch', 'center', 'flex-start', 'flex-end', 'space-between', 'space-around', 'initial', 'inherit']
flexJustifyModes = ['flex-start', 'flex-end', 'center', 'space-between', 'space-around']
flexDirectionModes = ['row', 'column']

module.exports = class FlexLayout extends View
    className: 'incito__flex-layout-view'

    render: ->
        if @attrs.layout_flex_align_items in alignItemModes
            @el.style.alignItems = @attrs.layout_flex_align_items
            @el.style.msAlignItems = @attrs.layout_flex_align_items

        if @attrs.layout_flex_align_content in alignContentModes
            @el.style.alignContent = @attrs.layout_flex_align_content
            @el.style.msAlignContent = @attrs.layout_flex_align_content

        if @attrs.layout_flex_justify_content in flexJustifyModes
            @el.style.justifyContent = @attrs.layout_flex_justify_content
            @el.style.msFlexPack = @attrs.layout_flex_justify_content

        if @attrs.layout_flex_direction in flexDirectionModes
            @el.style.flexDirection = @attrs.layout_flex_direction
            @el.style.msFlexDirection = @attrs.layout_flex_direction

        if typeof @attrs.layout_flex_shrink is 'number'
            @el.style.flexShrink = @attrs.layout_flex_shrink
            @el.style.msFlexShrink = @attrs.layout_flex_shrink
        
        if typeof @attrs.layout_flex_grow is 'number'
            @el.style.flexGrow = @attrs.layout_flex_grow
            @el.style.msFlexGrow = @attrs.layout_flex_grow
        
        if @attrs.layout_flex_basis?
            @el.style.flexBasis = @attrs.layout_flex_basis
            @el.style.msFlexBasis = @attrs.layout_flex_basis

        @