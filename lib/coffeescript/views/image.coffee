import View from './view'
import { isDefinedStr } from "../utils"

export default class Image extends View
    tagName: 'img'

    className: 'incito__image-view'

    lazyload: true
    
    render: ->
        if isDefinedStr @attrs.src
            @el.setAttribute 'data-src', @attrs.src
        
        if isDefinedStr @attrs.label
            @el.setAttribute 'alt', @attrs.label
        else
            @el.setAttribute 'alt', ''

        @