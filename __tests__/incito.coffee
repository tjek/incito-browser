import Incito from '../lib/coffeescript/incito'
import data from '../dist/example'

describe 'Incito', ->
    it 'should handle valid JSON and fire *Rendered events', (done) ->
        document.body.innerHTML = '<div id="main"></div>'

        main = document.getElementById('main')

        incito = new Incito main, incito: data, renderLaziness: 0
        allCallback = jest.fn()
        visibleCallback = jest.fn()

        incito.bind "allRendered", allCallback
        incito.bind "visibleRendered", visibleCallback

        expect(-> incito.start()).not.toThrow()
        expect(allCallback.mock.calls.length).toBe 1
        expect(visibleCallback.mock.calls.length).toBe 1

        done()
        
        return
    
    return