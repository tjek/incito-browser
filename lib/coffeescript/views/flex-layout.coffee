import View from './view'

alignItemModes = ['stretch', 'center', 'flex-start', 'flex-end', 'baseline']
flexJustifyModes = ['flex-start', 'flex-end', 'center', 'space-between', 'space-around']
flexDirectionModes = ['row', 'column']

export default class FlexLayout extends View
    className: 'incito__flex-layout-view'

    render: ->
        if @attrs.layout_flex_align_items in alignItemModes
            @el.style.alignItems = @attrs.layout_flex_align_items
            @el.style.msAlignItems = @attrs.layout_flex_align_items

        if @attrs.layout_flex_justify_content in flexJustifyModes
            @el.style.justifyContent = @attrs.layout_flex_justify_content
            @el.style.msFlexPack = @attrs.layout_flex_justify_content

        if @attrs.layout_flex_direction in flexDirectionModes
            @el.style.flexDirection = @attrs.layout_flex_direction
            @el.style.msFlexDirection = @attrs.layout_flex_direction

        @