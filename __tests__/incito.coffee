{ JSDOM } = require 'jsdom'
payload = require './stubs/test'
Incito = require '../lib/coffeescript/incito'
jsdom = require 'jsdom'
$ = require 'jquery'

describe 'Incito', ->
    describe 'Sample Payload', ->
        document.body.innerHTML = '<div id="main"></div>'
        main = $('#main')[0]
        incito = null
        init = -> incito = new Incito main, incito: payload
        expect(init).not.toThrow()
        expect(incito.start.bind incito).not.toThrow()

        elements = main: $ '#main > .incito'
        elements.linear = elements.main.find '.incito__linear-layout-view'
        elements.flex = elements.linear.find '.incito__flex-layout-view'
        elements.flexText = elements.flex.find '.incito__text-view'
        elements.absolute = elements.linear.find '.incito__absolute-layout-view'
        elements.absoluteView = elements.absolute.find '.incito__view'
        elements.absoluteViewFlex = elements.absoluteView.find '.incito__flex-layout-view'
        elements.absoluteViewTexts = elements.absoluteViewFlex.find 'p.incito__text-view'
        elements.images = elements.linear.find 'img.incito__image-view'
        elements.videoContainer = elements.linear.find '.incito__linear-layout-view'
        elements.video = elements.videoContainer.find 'iframe.incito__video-embed-view'

        expectedCss =
            main:
                fontFamily: 'Tangerine'
                backgroundColor: 'black'
                lineHeight: '1.3'
            flex:
                width: '300px'
                backgroundColor: 'rgb(0, 255, 0)'
                backgroundRepeat: 'repeat'
                backgroundPosition: 'center center'
                backgroundSize: 'cover'
                padding: '50px'
            flexText:
                fontSize: '56px'
                color: 'red'
                textAlign: 'center'
            absolute:
                width: '400px'
                height: '200px'
                backgroundColor: 'rgb(255, 0, 200)'
            absoluteView:
                width: '400px'
                height: '180px'
                left: '12px'
                bottom: '12px'
                backgroundColor: 'rgba(0, 0, 0, 0.2)'
                borderRadius: '100%'
            absoluteViewFlex:
                height: '30%'
                backgroundColor: 'rgba(0, 0, 0, 0.2)'
                paddingTop: '1px'
            absoluteViewTexts:
                overflow: 'visible'
                fontSize: '26px'
                color: 'rgb(255, 255, 255)'
                textAlign: 'center'
                fontStretch: 'condensed'
            images:
                width: '200px'
                height: '200px'
            videoContainer:
                width: '400px'
                height: '400px'
                backgroundColor: 'red'
            
        it 'should generate all views with proper class names', ->
            expect(elements.linear[0]).toBeDefined()
            expect(elements.flex[0]).toBeDefined()
            expect(elements.flexText[0]).toBeDefined()
            expect(elements.absolute[0]).toBeDefined()
            expect(elements.absoluteView[0]).toBeDefined()
            expect(elements.absoluteViewFlex[0]).toBeDefined()
            expect(elements.absoluteViewTexts[0]).toBeDefined()
            expect(elements.absoluteViewTexts[1]).toBeDefined()
            expect(elements.absoluteViewTexts[2]).toBeDefined()
            expect(elements.images[0]).toBeDefined()
            expect(elements.images[1]).toBeDefined()
            expect(elements.videoContainer[0]).toBeDefined()
            expect(elements.video[0]).toBeDefined()

            return
        
        it 'should add expected styles to views', ->
            for elemName, css of expectedCss
                for prop, val of css
                    expect(elements[elemName][0].style[prop]).toBe(val)
            
            return

        it 'should add fonts to document', ->
            style = document.styleSheets[0].cssRules[0].style
            expect(style['font-family']).toBe("'Tangerine'")
            expect(style['src']).toBe("url('https://fonts.gstatic.com/s/tangerine/v9/IurY6Y5j_oScZZow4VOxCZZM.woff2') format('woff2')")

            return

        it 'should add proper content', ->
            expect(elements.flexText.html()).toBe('Flex Layout')
            expect(elements.absoluteViewTexts.eq(0).html()).toBe('MANY')
            expect(elements.absoluteViewTexts.eq(1).html()).toBe('CHILD')
            expect(elements.absoluteViewTexts.eq(2).html()).toBe('VIEWS')
            expect(elements.images.eq(0).attr('data-src')).toBe('https://ddvcgkeorgbdk.cloudfront.net/assets/8f26f2af/img/team/mr.jpg')
            expect(elements.images.eq(1).attr('data-src')).toBe('https://ddvcgkeorgbdk.cloudfront.net/assets/8f26f2af/img/team/iz.jpg')
            expect(elements.video.attr('data-src')).toBe('https://www.youtube.com/embed/96j3lOyfwMs')

            return
        
        return
