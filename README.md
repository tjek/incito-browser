# Incito

[![Build Status](https://travis-ci.org/shopgun/incito-browser.svg?branch=develop)](https://travis-ci.org/shopgun/incito-browser)
[![NPM version](https://img.shields.io/npm/v/incito-browser.svg?style=flat)](https://npmjs.org/package/incito-browser)

This library can render the Incito format into HTML elements.

## Installation

- `npm install --save incito-browser`

## Development

- `npm install`
- `npm run dev`

## Changelog

### Version ?.?.?
- Upgrade to core-js 3

### Version 1.1.28

- Small rendering speedup
- Size reduction(about half)
- Introduced a `renderLaziness` options, which lets a rendering mode be chosen:
    - `renderLaziness: 0`: Render completely synchronously, this can percievably lock up a browser from user input but is the fastest way to render.
    - `renderLaziness: 1`: **DEFAULT** Render stuff in the browser viewport synchronously, but the rest of the incito lazily.
    - `renderLaziness: 2`: Render everything lazily. This ensures absolutely smooth user experience, but takes longer to show the user anything.
- Internal refactor for ES6 modules.
- Shed microevent dependency.

### Version 1.1.21

- Revert to core-js 2 for now

### Version 1.1.20

- Update dependencies
- Fix missing core-js runtime dependency

### Version 1.1.9

- Removed support for LinearLayout as it's the same as View

### Version 1.1.5

- Resolved issue where lazyloading didn't trigger when scrolling rapidly in browsers that don't support `IntersectionObserver`
- Updated dependencies

### Version 1.1.3

- Custom lazyloader
- Removed `scrollEl` parameter

### Version 1.1.0

- Removed click, longclick and contextclick handlers. This is no longer the responsibility of the library. Instead, delegate whatever events you want on top of Incito. It's just plain old HTML after all.
