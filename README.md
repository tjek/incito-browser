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

### Version 1.1.0

- Removed click, longclick and contextclick handlers. This is no longer the responsibility of the library. Instead, delegate whatever events you want on top of Incito. It's just plain old HTML after all.