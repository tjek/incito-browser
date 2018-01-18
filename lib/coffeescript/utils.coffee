utils =
    escapeHTML: (unsafe = '') ->
        unsafe
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace /'/g, '&#039;'

    formatUnit: (unit) ->
        if typeof unit is 'number'
            return "#{unit}px"
        else if typeof unit is 'string'
            return unit.replace 'dp', 'px'
        else
            return 0

module.exports = utils