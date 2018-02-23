View = require './view'
utils = require '../utils'

module.exports = class FlexLayout extends View
    className: 'incito__flex-layout-view'

    render: ->
        if utils.isDefinedStr @attrs.layout_flex_align_items
            @el.setAttribute 'data-align-items', @attrs.layout_flex_align_items
            @el.style.alignItems = @attrs.layout_flex_align_items

        if utils.isDefinedStr @attrs.layout_flex_align_content
            @el.setAttribute 'data-align-content', @attrs.layout_flex_align_content
            @el.style.alignContent = @attrs.layout_flex_align_content
        
        if utils.isDefinedStr @attrs.layout_flex_justify_content
            @el.setAttribute 'data-justify-content', @attrs.layout_flex_justify_content
            @el.style.justifyContent = @attrs.layout_flex_justify_content

        if utils.isDefinedStr @attrs.layout_flex_direction
            @el.setAttribute 'data-flex-direction', @attrs.layout_flex_direction
            @el.style.flexDirection = @attrs.layout_flex_direction

        if typeof @attrs.layout_flex_shrink is 'number'
            @el.setAttribute 'data-flex-shrink', @attrs.layout_flex_shrink
            @el.style.flexShrink = @attrs.layout_flex_shrink

        if typeof @attrs.layout_flex_grow is 'number'
            @el.setAttribute 'data-flex-grow', @attrs.layout_flex_grow
            @el.style.flexGrow = @attrs.layout_flex_grow

        if @attrs.layout_flex_basis?
            @el.setAttribute 'data-flex-basis', @attrs.layout_flex_basis
            @el.style.flexBasis = @attrs.layout_flex_basis

        @