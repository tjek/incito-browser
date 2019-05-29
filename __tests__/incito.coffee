import Incito from '../lib/coffeescript/incito'
import generateFakeData from 'incito/scripts/fake-data'

describe 'Incito', ->
    it 'should handle valid JSON and fire *Rendered events', ->
        document.body.innerHTML = '<div id="main"></div>'

        main = document.getElementById('main')

        for i in [0...50]
            data = await generateFakeData()
            incito = new Incito main, incito: data, renderLaziness: 0
            allCallback = jest.fn()
            visibleCallback = jest.fn()

            incito.bind "allRendered", allCallback
            incito.bind "visibleRendered", visibleCallback

            expect(-> incito.start()).not.toThrow()
            expect(allCallback.mock.calls.length).toBe 1
            expect(visibleCallback.mock.calls.length).toBe 1
        
        return
    
    return