{ escapeHTML, formatUnit, isDefinedStr } = require '../lib/coffeescript/utils'

describe 'Utils', ->
    test 'formatUnit', ->
        expect(formatUnit(32)).toBe('32px')
        expect(formatUnit('32dp')).toBe('32px')
        expect(formatUnit()).toBe(0)

    test 'isDefinedStr', ->
        expect(isDefinedStr('')).toBe(false)
        expect(isDefinedStr(' ')).toBe(true)

    test 'escapeHTML', ->
        expect(escapeHTML()).toBe('')
        expect(-> escapeHTML(false)).toThrow()
        expect(escapeHTML('<span>"\'span&\'"</span>')).toBe('&lt;span&gt;&quot;&#039;span&amp;&#039;&quot;&lt;/span&gt;')