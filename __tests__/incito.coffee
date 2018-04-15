Incito = require '../lib/coffeescript/incito'
generateFakeData = require 'incito/scripts/fake-data'
$ = require 'jquery'

describe 'Incito', ->
    it 'should handle valid JSON', ->
        document.body.innerHTML = '<div id="main"></div>'

        main = $('#main')[0]

        for i in [0...50]
            data = await generateFakeData()
            incito = new Incito main, incito: data
            start = ->
                incito.start()

            expect(start).not.toThrow()
        
        return
    
    return