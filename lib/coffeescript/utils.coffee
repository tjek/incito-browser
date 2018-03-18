utils =
    formatUnit: (unit) ->
        if not unit?
            return 0
        else if typeof unit is 'number'
            return "#{unit}px"
        else if typeof unit is 'string'
            return unit.replace 'dp', 'px'
        else
            return 0
    
    isDefinedStr: (value) ->
        typeof value is 'string' and value.length > 0

    escapeHTML: (unsafe = '') ->
        unsafe
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace /'/g, '&#039;'

    throttle: (func, limit) ->
        inThrottle = undefined
  
        ->
            args = arguments
            context = this

            if !inThrottle
                func.apply context, args
                inThrottle = true
                
                setTimeout ->
                    inThrottle = false
                    
                    return
                , limit

            return

module.exports = utils