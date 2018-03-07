_extends = Object.assign or (target) ->
  i = 1
  while i < arguments.length
    source = arguments[i]
    for key of source
      if Object::hasOwnProperty.call(source, key)
        target[key] = source[key]
    i++
  target

defaultSettings = 
  elements_selector: 'img'
  container: window
  threshold: 300
  throttle: 150
  data_src: 'src'
  data_srcset: 'srcset'
  class_loading: 'loading'
  class_loaded: 'loaded'
  class_error: 'error'
  class_initial: 'initial'
  skip_invisible: true
  callback_load: null
  callback_error: null
  callback_set: null
  callback_processed: null
  callback_enter: null
isBot = !('onscroll' of window) or /glebot/.test(navigator.userAgent)

callCallback = (callback, argument) ->
  if callback
    callback argument
  return

getTopOffset = (element) ->
  element.getBoundingClientRect().top + window.pageYOffset - (element.ownerDocument.documentElement.clientTop)

isBelowViewport = (element, container, threshold) ->
  fold = if container == window then window.innerHeight + window.pageYOffset else getTopOffset(container) + container.offsetHeight
  fold <= getTopOffset(element) - threshold

getLeftOffset = (element) ->
  element.getBoundingClientRect().left + window.pageXOffset - (element.ownerDocument.documentElement.clientLeft)

isAtRightOfViewport = (element, container, threshold) ->
  documentWidth = window.innerWidth
  fold = if container == window then documentWidth + window.pageXOffset else getLeftOffset(container) + documentWidth
  fold <= getLeftOffset(element) - threshold

isAboveViewport = (element, container, threshold) ->
  fold = if container == window then window.pageYOffset else getTopOffset(container)
  fold >= getTopOffset(element) + threshold + element.offsetHeight

isAtLeftOfViewport = (element, container, threshold) ->
  fold = if container == window then window.pageXOffset else getLeftOffset(container)
  fold >= getLeftOffset(element) + threshold + element.offsetWidth

isInsideViewport = (element, container, threshold) ->
  !isBelowViewport(element, container, threshold) and !isAboveViewport(element, container, threshold) and !isAtRightOfViewport(element, container, threshold) and !isAtLeftOfViewport(element, container, threshold)

### Creates instance and notifies it through the window element ###

createInstance = (classObj, options) ->
  event = undefined
  eventString = 'LazyLoad::Initialized'
  instance = new classObj(options)
  try
    # Works in modern browsers
    event = new CustomEvent(eventString, detail: instance: instance)
  catch err
    # Works in Internet Explorer (all versions)
    event = document.createEvent('CustomEvent')
    event.initCustomEvent eventString, false, false, instance: instance
  window.dispatchEvent event
  return

dataPrefix = 'data-'

getData = (element, attribute) ->
  element.getAttribute dataPrefix + attribute

setData = (element, attribute, value) ->
  element.setAttribute dataPrefix + attribute, value

setSourcesForPicture = (element, srcsetDataAttribute) ->
  parent = element.parentNode
  if parent.tagName != 'PICTURE'
    return
  i = 0
  while i < parent.children.length
    pictureChild = parent.children[i]
    if pictureChild.tagName == 'SOURCE'
      sourceSrcset = getData(pictureChild, srcsetDataAttribute)
      if sourceSrcset
        pictureChild.setAttribute 'srcset', sourceSrcset
    i++
  return

setSources = (element, srcsetDataAttribute, srcDataAttribute) ->
  tagName = element.tagName
  elementSrc = getData(element, srcDataAttribute)
  if tagName == 'IMG'
    setSourcesForPicture element, srcsetDataAttribute
    imgSrcset = getData(element, srcsetDataAttribute)
    if imgSrcset
      element.setAttribute 'srcset', imgSrcset
    if elementSrc
      element.setAttribute 'src', elementSrc
    return
  if tagName == 'IFRAME'
    if elementSrc
      element.setAttribute 'src', elementSrc
    return
  if elementSrc
    element.style.backgroundImage = 'url("' + elementSrc + '")'
  return

supportsClassList = 'classList' of document.createElement('p')

addClass = (element, className) ->
  if supportsClassList
    element.classList.add className
    return
  element.className += (if element.className then ' ' else '') + className
  return

removeClass = (element, className) ->
  if supportsClassList
    element.classList.remove className
    return
  element.className = element.className.replace(new RegExp('(^|\\s+)' + className + '(\\s+|$)'), ' ').replace(/^\s+/, '').replace(/\s+$/, '')
  return

###
# Constructor
###

LazyLoad = (instanceSettings) ->
  @_settings = _extends({}, defaultSettings, instanceSettings)
  @_queryOriginNode = if @_settings.container == window then document else @_settings.container
  @_previousLoopTime = 0
  @_loopTimeout = null
  @_boundHandleScroll = @handleScroll.bind(this)
  @_isFirstLoop = true
  window.addEventListener 'resize', @_boundHandleScroll
  @update()
  return

LazyLoad.prototype =
  _reveal: (element) ->
    settings = @_settings

    errorCallback = ->

      ### As this method is asynchronous, it must be protected against external destroy() calls ###

      if !settings
        return
      element.removeEventListener 'load', loadCallback
      element.removeEventListener 'error', errorCallback
      removeClass element, settings.class_loading
      addClass element, settings.class_error
      callCallback settings.callback_error, element
      return

    loadCallback = ->

      ### As this method is asynchronous, it must be protected against external destroy() calls ###

      if !settings
        return
      removeClass element, settings.class_loading
      addClass element, settings.class_loaded
      element.removeEventListener 'load', loadCallback
      element.removeEventListener 'error', errorCallback
      callCallback settings.callback_load, element
      return

    callCallback settings.callback_enter, element
    if element.tagName == 'IMG' or element.tagName == 'IFRAME'
      element.addEventListener 'load', loadCallback
      element.addEventListener 'error', errorCallback
      addClass element, settings.class_loading
    setSources element, settings.data_srcset, settings.data_src
    callCallback settings.callback_set, element
    return
  _loopThroughElements: ->
    settings = @_settings
    elements = @_elements
    elementsLength = if !elements then 0 else elements.length
    i = undefined
    processedIndexes = []
    firstLoop = @_isFirstLoop
    i = 0
    while i < elementsLength
      element = elements[i]

      ### If must skip_invisible and element is invisible, skip it ###

      if settings.skip_invisible and element.offsetParent == null
        i++
        continue
      if isBot or isInsideViewport(element, settings.container, settings.threshold)
        if firstLoop
          addClass element, settings.class_initial

        ### Start loading the image ###

        @_reveal element

        ### Marking the element as processed. ###

        processedIndexes.push i
        setData element, 'was-processed', true
      i++

    ### Removing processed elements from this._elements. ###

    while processedIndexes.length
      elements.splice processedIndexes.pop(), 1
      callCallback settings.callback_processed, elements.length

    ### Stop listening to scroll event when 0 elements remains ###

    if elementsLength == 0
      @_stopScrollHandler()

    ### Sets isFirstLoop to false ###

    if firstLoop
      @_isFirstLoop = false
    return
  _purgeElements: ->
    elements = @_elements
    elementsLength = elements.length
    i = undefined
    elementsToPurge = []
    i = 0
    while i < elementsLength
      element = elements[i]

      ### If the element has already been processed, skip it ###

      if getData(element, 'was-processed')
        elementsToPurge.push i
      i++

    ### Removing elements to purge from this._elements. ###

    while elementsToPurge.length > 0
      elements.splice elementsToPurge.pop(), 1
    return
  _startScrollHandler: ->
    if !@_isHandlingScroll
      @_isHandlingScroll = true
      @_settings.container.addEventListener 'scroll', @_boundHandleScroll
    return
  _stopScrollHandler: ->
    if @_isHandlingScroll
      @_isHandlingScroll = false
      @_settings.container.removeEventListener 'scroll', @_boundHandleScroll
    return
  handleScroll: ->
    throttle = @_settings.throttle
    if throttle != 0
      now = Date.now()
      remainingTime = throttle - (now - (@_previousLoopTime))
      if remainingTime <= 0 or remainingTime > throttle
        if @_loopTimeout
          clearTimeout @_loopTimeout
          @_loopTimeout = null
        @_previousLoopTime = now
        @_loopThroughElements()
      else if !@_loopTimeout
        @_loopTimeout = setTimeout((->
          @_previousLoopTime = Date.now()
          @_loopTimeout = null
          @_loopThroughElements()
          return
        ).bind(this), remainingTime)
    else
      @_loopThroughElements()
    return
  update: ->
    # Converts to array the nodeset obtained querying the DOM from _queryOriginNode with elements_selector
    @_elements = Array::slice.call(@_queryOriginNode.querySelectorAll(@_settings.elements_selector))
    @_purgeElements()
    @_loopThroughElements()
    @_startScrollHandler()
    return
  destroy: ->
    window.removeEventListener 'resize', @_boundHandleScroll
    if @_loopTimeout
      clearTimeout @_loopTimeout
      @_loopTimeout = null
    @_stopScrollHandler()
    @_elements = null
    @_queryOriginNode = null
    @_settings = null
    return

module.exports = LazyLoad