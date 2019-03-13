{ escapeHTML, formatUnit, isDefinedStr } = require '../lib/coffeescript/utils'

describe 'Utils', ->
    test 'formatUnit', ->
        expect(formatUnit(32)).toBe('32px')
        expect(formatUnit('32dp')).toBe('32px')
        expect(formatUnit()).toBe(0)

        return

    test 'isDefinedStr', ->
        expect(isDefinedStr('')).toBe(false)
        expect(isDefinedStr(' ')).toBe(true)
    
        return

    return