validate = require '../lib/coffeescript/validator'
correctJson = require './stubs/correct'
wrongJson = require './stubs/wrong'

describe 'Schema validation', ->
    it 'should work for correct input', ->
        validation = validate correctJson
        expect(validation.valid).toEqual(true)

        return
    
    describe 'Erroneus input', ->
        validation = validate wrongJson
        errors = {}
        errors[e.property] = e for e in validation.errors

        expectedErrors = [
            "id"
            "version"
            "locale"
            "debug"
            "meta"
            "font_assets.wrong-font.src[0]"
            "font_assets.wrong-font.src[1]"
            "theme.font_family[1]"
            "theme.background_color"
            "root_view.child_views[0].view_name"
            "root_view.child_views[1].gravity"
            "root_view.child_views[1].background_image_position"
            "root_view.child_views[1].background_color"
            "root_view.child_views[1].stroke_style"
            "root_view.child_views[1].transform_origin"
            "root_view.child_views[1].src"
            "root_view.child_views[1].link"
            "root_view.child_views[1].text"
            "root_view.child_views[1].text_style"
        ]

        for expectedError in expectedErrors
            err = errors["instance.#{expectedError}"]
            it "should have error in instance.#{expectedError}", ->
                expect(err).toBeDefined()

        expect(validation.errors.length).toEqual 19

        return