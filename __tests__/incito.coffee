{ JSDOM } = require 'jsdom'
payload = require './stubs/test'
Incito = require '../lib/coffeescript/incito'
jsdom = require 'jsdom'
$ = require 'jquery'

describe 'Incito', ->
    test 'simple payload', ->
        document.body.innerHTML = '<div id="main"></div>'
        main = $('#main')[0]
        incito = null
        init = -> incito = new Incito main, incito: payload

        expect(init).not.toThrow()
        expect(incito.start.bind incito).not.toThrow()

        linear = $ '#main > .incito__linear-layout-view'
        flex = linear.find '.incito__flex-layout-view'
        flexText = flex.find '.incito__text-view'
        absolute = linear.find '.incito__absolute-layout-view'
        absoluteTexts = absolute.find '.incito__text-view'
        images = linear.find '.incito__image-view'
        videoContainer = linear.find '.incito__linear-layout-view'
        video = videoContainer.find '.incito__video-embed-view'

        expect(linear[0]).toBeDefined()
        expect(flex[0]).toBeDefined()
        expect(flexText[0]).toBeDefined()
        expect(absolute[0]).toBeDefined()
        expect(absoluteTexts[0]).toBeDefined()
        expect(absoluteTexts[1]).toBeDefined()
        expect(absoluteTexts[2]).toBeDefined()
        expect(images[0]).toBeDefined()
        expect(images[1]).toBeDefined()
        expect(videoContainer[0]).toBeDefined()
        expect(video[0]).toBeDefined()

        # TODO: Check styles

        return
