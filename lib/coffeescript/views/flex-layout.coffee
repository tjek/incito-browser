View = require './view'

module.exports = class FlexLayout extends View
    className: 'incito__flex-layout-view'

    render: ->
        if @attrs.layout_flex_align_items?
            @el.style.alignItems = @attrs.layout_flex_align_items

        if @attrs.layout_flex_align_content?
            @el.style.alignContent = @attrs.layout_flex_align_content

        if @attrs.layout_flex_justify_content?
            @el.style.justifyContent = @attrs.layout_flex_justify_content

        if @attrs.layout_flex_direction?
            @el.style.flexDirection = @attrs.layout_flex_direction

        @